# Imports
import redis

"""
Represents Redis API
- Person has: id: int, name: str, knows: set, bought: set
- Book has: id: int, name: str, price: int
- The knows and bought set for a Person will represent edges to other nodes as an adjacency list
"""
class Redis_api:
    def __init__(self, host, port):
        self.r = redis.Redis(host, port, decode_responses=True)
        self.r.set('person_id', 0)
        self.r.set('book_id', 0)

    # Add a new node to graph DB
    def add_node(self, name, type):
        if type == 'person':
            new_id = self.r.get('person_id')
            self.r.hset('person' + new_id, mapping={'id': new_id,
                                                    'name': name,
                                                    'knows': set(),
                                                    'bought': set()})
            self.r.incr('person_id')

        if type == 'book':
            new_id = self.r.get('book_id')
            self.r.hset('book' + new_id, mapping={'id': new_id,
                                                  'name': name,
                                                  'price': 0})
            self.r.incr('book_id')


    # Adds an edge to corresponding set of name1 by updating the set
    def add_edge(self, name1, name2, type):
        id = self.r.hget('person' + name1, 'id')
        name = self.r.hget('person' + name1, 'name')
        knows = self.r.hget('person' + name1, 'knows')
        bought = self.r.hget('person' + name1, 'bought')

        self.r.srem('person' + id)

        if type == 'knows':
            name2_id = self.r.hget('person' + name2, 'id')
            new_knows = knows.add('name2' + name2_id)
            self.r.hset('person' + id, mapping={'id': id,
                                                'name': name,
                                                'knows': new_knows,
                                                'bought': bought})
        if type == 'bought':
            name2_id = self.r.hget('book' + name2, 'id')
            new_bought = bought.add('name2' + name2_id)
            self.r.hset('person' + id, mapping={'id': id,
                                                'name': name,
                                                'knows': knows,
                                                'bought': new_bought})


    def get_adjacent(name, node_type=None, edge_type=None):
        return


    # Run DFS with given name as root and return all nodes seen
    def get_recommendations(name):
        return

