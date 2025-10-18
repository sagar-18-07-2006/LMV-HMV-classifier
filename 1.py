from graphviz import Digraph

# Create a new directed graph
dot = Digraph(comment='Class Diagram for Vehicle Detection App')

# Define classes
dot.node('App', 'App\n- user_id\n- password\n+ login()\n+ register()\n+ showHome()')
dot.node('Camera', 'Camera\n- camera_id\n- location\n+ connect()\n+ streamVideo()')
dot.node('AIModel', 'AIModel\n+ detectVehicles(video)\n+ classifyVehicle()\n+ detectNumberPlate()')
dot.node('Backend', 'Backend\n+ receiveVideo()\n+ processDetection()\n+ sendNotification()')
dot.node('ViolationLog', 'ViolationLog\n- date_time\n- vehicle_type\n- number_plate\n- location\n+ logViolation()')
dot.node('RestrictedZone', 'RestrictedZone\n- location\n- is_restricted\n+ isRestricted(location)')
dot.node('LoginInfo', 'LoginInfo\n- user_id\n- password')
dot.node('Notification', 'Notification\n+ send()')
dot.node('VideoFeed', 'VideoFeed\n- annotated_video\n+ showRealTimeDetection()')

# Define relationships
dot.edge('App', 'Camera', label='manages')
dot.edge('App', 'ViolationLog', label='views history')
dot.edge('App', 'RestrictedZone', label='adds/updates')
dot.edge('App', 'LoginInfo', label='authenticates via')
dot.edge('App', 'VideoFeed', label='views')

dot.edge('Camera', 'Backend', label='sends video to')
dot.edge('Backend', 'AIModel', label='uses for detection')
dot.edge('AIModel', 'VideoFeed', label='returns output to')
dot.edge('Backend', 'RestrictedZone', label='checks location in')
dot.edge('Backend', 'ViolationLog', label='stores to')
dot.edge('Backend', 'Notification', label='triggers')

# Render the diagram
dot.graph_attr['rankdir'] = 'LR'  # Left to right
dot.render('class_diagram_vehicle_detection', format='png', cleanup=False)
