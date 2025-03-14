import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ice_live_viewer/pages/help.dart';
import 'package:ice_live_viewer/pages/settings.dart';
import 'package:ice_live_viewer/utils/linkparser.dart';
import 'package:ice_live_viewer/utils/storage.dart' as storage;
import 'package:ice_live_viewer/widgets/about.dart';
import 'package:ice_live_viewer/widgets/platformlisttile.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  //homepage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IceLiveViewer'),
      ),
      body: const ListViewFutureBuilder(),
      drawer: const HomeDrawer(),
      floatingActionButton: const FloatingButton(),
    );
  }
}

/// 首页的悬浮按钮
class FloatingButton extends StatelessWidget {
  const FloatingButton({Key? key}) : super(key: key);
  //create floating button
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        //create a new dialog window to ask a number
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController linkTextController = TextEditingController();
            return AlertDialog(
              title: const Text('Enter the link'),
              content: TextField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Enter link',
                  hintText: 'https://m.huya.com/243547',
                ),
                onChanged: (String value) {},
                //get the text and store it
                controller: linkTextController,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return FutureBuilder(
                              future: LinkParser()
                                  .formatUrl(linkTextController.text),
                              //.then((value) => storage.saveSingleLink(value)),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text('${snapshot.error}'),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const Home();
                                            }));
                                          },
                                          child: const Text('Refresh'))
                                    ],
                                  );
                                } else if (snapshot.hasData) {
                                  storage
                                      .saveSingleLink(snapshot.data.toString());
                                  return AlertDialog(
                                    title: const Text('Success'),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const Home();
                                            }));
                                          },
                                          child: const Text('Refresh'))
                                    ],
                                  );
                                } else {
                                  return const AlertDialog(
                                    title: Text('Loading'),
                                    content: LinearProgressIndicator(
                                      minHeight: 10,
                                    ),
                                  );
                                }
                              });
                        });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// 首页的侧边栏
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);
  //create the drawer
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        primary: false,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Center(
                    child: Image.asset('assets/icon.png'),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Center(
                    child: Text('IceLiveViewer',
                        style: Theme.of(context).textTheme.headline1)),
              ],
            ),
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Refresh Data'),
            leading: const Icon(Icons.refresh),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Home();
              }));
            },
          ),
          ListTile(
            title: const Text('Clear Data'),
            leading: const Icon(Icons.delete),
            onTap: () {
              //ask user if he is sure to clear the data
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Clear Data'),
                    content: const Text(
                        'Are you sure to clear all the data?\nAll these data will disappear!'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          storage.clearData();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Success'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const Home();
                                        }));
                                      },
                                      child: const Text('Refresh'))
                                ],
                              );
                            },
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Help'),
            leading: const Icon(Icons.help_outline_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
          const About()
        ],
      ),
    );
  }
}

/// 首页列表视图的骨架
class ListViewFutureBuilder extends StatefulWidget {
  const ListViewFutureBuilder({Key? key}) : super(key: key);

  @override
  State<ListViewFutureBuilder> createState() => _ListViewFutureBuilderState();
}

class _ListViewFutureBuilderState extends State<ListViewFutureBuilder> {
  @override
  void initState() {
    super.initState();
    storage.initStorage().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return storage.getAllLinks().then((value) {
          setState(() {});
        });
      },
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            //enable the drag on mouse and touch devices
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        child: FutureBuilder(
          future: storage.getAllLinks(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ListTile(
                leading: const Icon(Icons.error_outline),
                title: Text('Error:Storage Error${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final Object? links = snapshot.data;
              int count = (links as Map<String, dynamic>).length;
              //debugPrint(snapshot.data.toString());
              if (count == 0) {
                return Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.edit_note_rounded,
                          size: 150,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                            'No data :(\n\nClick the button below \n to add your first link',
                            style: Theme.of(context).textTheme.headline2,
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemExtent: 65.0,
                itemCount: count,
                itemBuilder: (context, index) {
                  int indexNum = index + 1;
                  String url = (links)['$indexNum'].toString();
                  String type = LinkParser().checkType(url);
                  if (type == 'huya') {
                    return HuyaFutureListTileSkeleton(url: url);
                  } else if (type == 'bilibili') {
                    return BilibiliFutureListTileSkeleton(url: url);
                  } else if (type == 'douyu') {
                    return DouyuFutureListTileSkeleton(url: url);
                  } else {
                    return ErrorListTile(
                      error: type,
                      rawLink: url,
                      stackTrace: '',
                    );
                  }
                },
              );
            } else {
              return const LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
