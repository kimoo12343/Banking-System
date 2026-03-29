import tkinter as tk
from tkinter import ttk, messagebox, filedialog
from db import get_server_connection, run_sql_file, get_db_connection, fetch_all

TABLES = ["CLIENT", "ACCOUNT", "ACCOUNT_TRANSACTION", "LOAN", "LOAN_PAYMENT"]

class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Banking System GUI")
        self.geometry("1000x600")

        self.host = tk.StringVar(value="localhost")
        self.user = tk.StringVar(value="root")
        self.password = tk.StringVar(value="Kimko777-")
        self.table = tk.StringVar(value=TABLES[0])

        self._build()

    def _build(self):
        top = ttk.Frame(self)
        top.pack(fill="x", padx=10, pady=10)

        ttk.Label(top, text="Host").grid(row=0, column=0)
        ttk.Entry(top, textvariable=self.host, width=15).grid(row=0, column=1, padx=5)

        ttk.Label(top, text="User").grid(row=0, column=2)
        ttk.Entry(top, textvariable=self.user, width=15).grid(row=0, column=3, padx=5)

        ttk.Label(top, text="Password").grid(row=0, column=4)
        ttk.Entry(top, textvariable=self.password, width=15, show="*").grid(row=0, column=5, padx=5)

        ttk.Button(top, text="Initialize DB from SQL file", command=self.init_db).grid(row=0, column=6, padx=10)

        mid = ttk.Frame(self)
        mid.pack(fill="x", padx=10)

        ttk.Label(mid, text="Table").pack(side="left")
        ttk.Combobox(mid, values=TABLES, textvariable=self.table, state="readonly", width=25).pack(side="left", padx=8)
        ttk.Button(mid, text="View Table", command=self.view_table).pack(side="left", padx=10)

        box = ttk.LabelFrame(self, text="Run SELECT Query")
        box.pack(fill="x", padx=10, pady=10)
        self.query = tk.Text(box, height=4)
        self.query.pack(fill="x", padx=8, pady=8)
        self.query.insert("1.0", "SELECT * FROM CLIENT;")
        ttk.Button(box, text="Run Query", command=self.run_query).pack(pady=6)

        self.result_frame = ttk.LabelFrame(self, text="Results")
        self.result_frame.pack(fill="both", expand=True, padx=10, pady=10)

    def init_db(self):
        path = filedialog.askopenfilename(filetypes=[("SQL files", "*.sql")])
        if not path:
            return
        try:
            conn = get_server_connection(self.host.get(), self.user.get(), self.password.get())
            run_sql_file(conn, path)
            conn.close()
            messagebox.showinfo("Done", "Database created and script executed.")
        except Exception as e:
            messagebox.showerror("Error", str(e))

    def _render(self, cols, rows):
        for w in self.result_frame.winfo_children():
            w.destroy()

        tree = ttk.Treeview(self.result_frame, columns=cols, show="headings")
        tree.pack(fill="both", expand=True)

        for c in cols:
            tree.heading(c, text=c)
            tree.column(c, width=140)

        for r in rows:
            tree.insert("", "end", values=r)

    def view_table(self):
        try:
            conn = get_db_connection(self.host.get(), self.user.get(), self.password.get())
            cols, rows = fetch_all(conn, f"SELECT * FROM {self.table.get()};")
            conn.close()
            self._render(cols, rows)
        except Exception as e:
            messagebox.showerror("Error", str(e))

    def run_query(self):
        q = self.query.get("1.0", "end").strip()
        if not q.lower().startswith("select"):
            messagebox.showwarning("Blocked", "Only SELECT queries are allowed here.")
            return
        try:
            conn = get_db_connection(self.host.get(), self.user.get(), self.password.get())
            cols, rows = fetch_all(conn, q)
            conn.close()
            self._render(cols, rows)
        except Exception as e:
            messagebox.showerror("Error", str(e))

if __name__ == "__main__":
    App().mainloop()