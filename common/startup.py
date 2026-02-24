# disable python history
__import__("readline").write_history_file = lambda x: None;
# quit function
class Q:
    def __repr__(self):
        __import__("sys").exit(0);
q = Q();
