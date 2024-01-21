import 'dart:convert';
import 'dart:developer';

import 'package:dart_code_algorithms/custom_widgets/custom_dropdown_menu.dart';
import 'package:dart_code_algorithms/profile_info.dart/shared_data.dart';
import 'package:dart_code_algorithms/profile_info.dart/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../custom_widgets/custom_text_form_field.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool? isSaved;

  List<UserInfoModel?>? userModelList;

  final SharedPreferancesDataMethods _pref = SharedPreferancesDataMethods();

  Future<List<UserInfoModel?>?> getUserData() async {
    List<String?>? data = await _pref.getUserListData();
    userModelList = data?.map((e) {
      log(e.toString());
      return UserInfoModel.fromJson(jsonDecode(e ?? ""));
    }).toList();
    setState(() {});
    return userModelList;
  }

  String? defaultDropDownMenuItem = "mersin";

  @override
  void initState() {
    getUserData();
    // _pref.deleteUserData();
    super.initState();
  }

  Future<List<UserInfoModel?>?> getUserModelData() async {
    UserInfoModel userModel = UserInfoModel(
        name: nameController.text,
        surname: surnameController.text,
        userId: int.tryParse(idController.text),
        city: cityController.text,
        email: mailController.text,
        phone: phoneController.text);

    // String newUser = jsonEncode(userModel.toJson());
    userModelList?.add(userModel);
    List<String> newUserList = userModelList
            ?.map((userModel) => jsonEncode(userModel?.toJson()))
            .toList() ??
        [];

    await _pref.saveUserListData(newUserList);
    return userModelList;
  }

  Future<List<UserInfoModel?>?> saveUserModelData() async {
    List<String> newUserList = userModelList
            ?.map((userModel) => jsonEncode(userModel?.toJson()))
            .toList() ??
        [];
    await _pref.saveUserListData(newUserList);
    return userModelList;
  }

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text("profil"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          await getUserData();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          children: [
            if (userModelList?.isEmpty == true)
              const Text(
                "Henüz bir kullanıcı yok!",
                textAlign: TextAlign.center,
              ),
            ...List.generate(userModelList?.length ?? 0, (index) {
              final item = userModelList?[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    dense: true,
                    tileColor: index.isEven
                        ? Colors.grey.shade300
                        : Colors.grey.shade100,
                    title: Text(item?.name ?? "null"),
                    leading: Text(item?.userId.toString() ?? "null"),
                    subtitle: Text(item?.surname ?? "null"),
                    trailing: SizedBox(
                      width: 150,
                      height: 40,
                      child: Row(
                        children: [
                          TextButton(
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Güncelle",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              userModelList?[index] = UserInfoModel(
                                  name: nameController.text,
                                  surname: surnameController.text,
                                  city: cityController.text,
                                  email: mailController.text,
                                  phone: phoneController.text,
                                  userId: int.tryParse(idController.text));
                              setState(() {});
                              saveUserModelData();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              "Sil",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              userModelList?.remove(item);
                              await saveUserModelData();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    )),
              );
            }).toList(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              child: ElevatedButton.icon(
                  onPressed: () async {
                    userModelList = await showDialog<List<UserInfoModel?>?>(
                        barrierDismissible: false,
                        barrierColor: const Color.fromARGB(136, 63, 62, 62),
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("kullanıcı ekle"),
                            content: SizedBox(
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      CustomTextFormField(
                                        keywordtype: TextInputType.number,
                                        title: "Numara",
                                        textController: idController,
                                      ),
                                      CustomTextFormField(
                                        // val: (nameVal) {
                                        //   if (nameVal?.isEmpty == true) {
                                        //     "boş değer girmeyin";
                                        //   }
                                        //   return null;
                                        // },
                                        title: "adı",
                                        textController: nameController,
                                      ),
                                      CustomTextFormField(
                                        title: "Soyadı",
                                        textController: surnameController,
                                        val: (surVal) {
                                          if (surVal?.isEmpty == true) {
                                            "boş değer girmeyin";
                                          }
                                          return null;
                                        },
                                      ),
                                      CustomTextFormField(
                                        title: "e posta",
                                        // val: (mailVal) {
                                        //   if (mailVal?.contains("@") == false ||
                                        //       mailVal?.contains(".com") == false) {
                                        //     return "E-Mail adresinizi kontrol edin";
                                        //   }
                                        //   return null;
                                        // },
                                        textController: mailController,
                                      ),
                                      CustomTextFormField(
                                        helperText: "550 555 5555",
                                        title: "telefon",
                                        // val: (phoneVal) {
                                        //   if (phoneVal?.split("").length != 10) {
                                        //     return "telefon numarasını kontrol edin";
                                        //   }
                                        //   return null;
                                        // },
                                        textController: phoneController,
                                      ),
                                      Row(
                                        children: [
                                          Text(defaultDropDownMenuItem
                                              .toString()),
                                          CustomDropDownMenu(
                                            dropDownVal:
                                                defaultDropDownMenuItem,
                                            items: city,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton.icon(
                                          onPressed: () async {
                                            if (nameController.text.isEmpty ||
                                                surnameController
                                                    .text.isEmpty) {
                                              await Fluttertoast.showToast(
                                                  msg: "Boş değer girmeyin",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                              return;
                                            }

                                            if (_formKey.currentState
                                                    ?.validate() ==
                                                false) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text('hata')),
                                              );
                                              return;
                                            }

                                            return await getUserModelData()
                                                .then((val) => Navigator.pop(
                                                    context, val));
                                          },
                                          icon: const Icon(
                                              Icons.account_circle_rounded),
                                          label: const Text("kaydet"))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });

                    setState(() {});
                    // setState(() {
                    //   isSaved = false;
                    // });
                    // await Future.delayed(const Duration(seconds: 1));

                    // List<String> userlist = userModelList
                    //         ?.map((e) => jsonEncode(e?.toJson()))
                    //         .toList() ??
                    //     [];
                    // final res = await _pref.saveUserListData(userlist);
                    // await getUserData();
                    // setState(() {
                    //   isSaved = res;
                    // });
                  },
                  icon: isSaved == false
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.purple,
                            strokeWidth: 2,
                          )),
                        )
                      : const Icon(Icons.save),
                  label: const Text("Yeni Kullanıcı Kaydet")),
            )
          ],
        ),
      ),
    );
  }
}

List<Map<int, String>> city = [
  {01: "adana"},
  {02: "ankara"},
  {03: "mersin"},
  {04: "elazığ"},
  {05: "adıyaman"},
  {06: "konya"}
];
