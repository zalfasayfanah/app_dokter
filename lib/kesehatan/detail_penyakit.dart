import 'package:flutter/material.dart';
import 'data_penyakit.dart';

class DetailPenyakit extends StatefulWidget {
  final String namaPenyakit;

  const DetailPenyakit({
    super.key,
    required this.namaPenyakit,
  });

  @override
  State<DetailPenyakit> createState() =>
      _DetailPenyakitState();
}

class _DetailPenyakitState
    extends State<DetailPenyakit> {

  bool penyebab = true;
  bool gejala = false;
  bool bahaya = false;
  bool pengobatan = false;

  @override
  Widget build(BuildContext context) {

    final data =
        dataPenyakit[widget.namaPenyakit] ?? {};

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // tombol kembali
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },

                child: const Row(
                  children: [

                    Icon(
                      Icons.arrow_back,
                      color: Colors.indigo,
                    ),

                    SizedBox(width:8),

                    Text(
                      "Kembali",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height:15),

              // JUDUL
              Row(
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          widget.namaPenyakit,

                          style:
                              const TextStyle(
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Color(0xff1A237E),
                          ),
                        ),

                        const SizedBox(
                            height:6),

                        Text(
                          data["namaLengkap"] ??
                              "-",

                          style:
                              const TextStyle(
                            color:
                                Colors.indigo,
                          ),
                        ),

                        const SizedBox(
                            height:10),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:12,
                            vertical:6,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.indigo,
                            borderRadius:
                                BorderRadius.circular(
                                    8),
                          ),

                          child: Text(
                            data["kategori"] ??
                                "-",

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  CircleAvatar(
                    radius: 45,
                    backgroundColor:
                        Colors.grey.shade200,

                    child: Image.asset(
                      data["gambar"] ??
                          "assets/images/gerd.png",

                      errorBuilder:
                          (context,error,stackTrace){

                        return const Icon(
                          Icons.medical_services,
                          size:40,
                        );
                      },
                    ),
                  )
                ],
              ),

              const SizedBox(height:20),

              // DESKRIPSI

              Container(
                padding:
                    const EdgeInsets.all(
                        15),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                          0xffF5EFD9),

                  borderRadius:
                      BorderRadius.circular(
                          10),

                  border:
                      Border.all(
                    color:
                        Colors.indigo,
                  ),
                ),

                child: Text(
                  data["deskripsi"] ??
                      "Deskripsi belum tersedia",
                ),
              ),

              const SizedBox(
                  height:15),

              // GAMBAR

              Row(
                children: [

                  Expanded(
                    child: _gambar(
                        "assets/images/g1.png"),
                  ),

                  const SizedBox(
                      width:10),

                  Expanded(
                    child: _gambar(
                        "assets/images/g2.png"),
                  ),

                  const SizedBox(
                      width:10),

                  Expanded(
                    child: _gambar(
                        "assets/images/g3.png"),
                  ),

                ],
              ),

              const SizedBox(
                  height:20),

              _expandTile(
                "Penyebab Utama",
                Icons.help,
                Colors.blue,
                penyebab,
                (){},
                data["penyebab"] ??
                    "Belum tersedia",
              ),

              _expandTile(
                "Gejala",
                Icons.sentiment_satisfied,
                Colors.orange,
                gejala,
                (){},
                data["gejala"] ??
                    "Belum tersedia",
              ),

              _expandTile(
                "Bahaya Jika Dibiarkan",
                Icons.warning,
                Colors.amber,
                bahaya,
                (){},
                data["bahaya"] ??
                    "Belum tersedia",
              ),

              const SizedBox(
                  height:20),

              Row(
                children: [

                  Expanded(
                    child: _caraCard(
                      "Cara Mencegah",

                      data["mencegah"]
                          ?? [],
                    ),
                  ),

                  const SizedBox(
                      width:10),

                  Expanded(
                    child: _caraCard(
                      "Cara Pengobatan",

                      data["pengobatan"]
                          ?? [],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _gambar(String path){

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(
              10),

      child: Image.asset(
        path,
        height:80,
        fit:BoxFit.cover,

        errorBuilder:
            (context,error,stackTrace){

          return Container(
            height:80,
            color:
                Colors.grey.shade200,

            child: const Icon(
              Icons.image,
            ),
          );
        },
      ),
    );
  }

  Widget _expandTile(
      String title,
      IconData icon,
      Color warna,
      bool buka,
      VoidCallback onTap,
      String isi){

    return Card(

      margin:
          const EdgeInsets.only(
              bottom:10),

      child: ExpansionTile(

        initiallyExpanded:
            buka,

        leading: CircleAvatar(
          backgroundColor:
              warna,

          child: Icon(
            icon,
            color:
                Colors.white,
          ),
        ),

        title: Text(
          title,

          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        children: [

          Padding(
            padding:
                const EdgeInsets.all(
                    15),

            child:
                Text(isi),
          )

        ],
      ),
    );
  }

  Widget _caraCard(
      String title,
      List isi){

    return Container(

      padding:
          const EdgeInsets.all(
              15),

      decoration:
          BoxDecoration(

        color:
            const Color(
                0xFFFBFCFF),

        borderRadius:
            BorderRadius.circular(
                15),

        border:
            Border.all(
          color:
              Colors.grey.shade300,
        ),

        boxShadow:
            const [

          BoxShadow(
            color:
                Colors.black12,
            blurRadius:5,
            offset:
                Offset(0,2),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          Text(
            title,

            style:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
              height:10),

          ...isi.map(
            (e)=>Padding(
              padding:
                  const EdgeInsets.only(
                      bottom:5),

              child: Text(
                "• $e",
              ),
            ),
          )
        ],
      ),
    );
  }
}