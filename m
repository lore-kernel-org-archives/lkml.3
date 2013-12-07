Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3LGEwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 23:52:40 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:51643 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab3LGEwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 23:52:39 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 5/9] Staging: bcm: DDRInit: replaced C99 comments.
Date: Fri,  6 Dec 2013 23:52:35 -0500
Message-Id: <1386391955-11713-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fifth patch of a series.

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
---
On branch staging-next
 drivers/staging/bcm/DDRInit.c | 270 +++++++++++++++++++++---------------------
 1 file changed, 135 insertions(+), 135 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index cb4dd53..1a08b17 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -5,15 +5,15 @@
 #define DDR_DUMP_INTERNAL_DEVICE_MEMORY 0xBFC02B00
 #define MIPS_CLOCK_REG 	0x0f000820
 
-    //DDR INIT-133Mhz
-#define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  //index for 0x0F007000
-static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {//      # DPLL Clock Setting
+    /* DDR INIT-133Mhz */
+#define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  /* index for 0x0F00700 */0
+static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {     /* # DPLL Clock Setting */
 	{0x0F000800, 0x00007212},
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00000F95},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-                                        // Changed source for X-bar and MIPS clock to APLL
+                                        /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000840, 0x0FFF1B00},
 	{0x0f000870, 0x00000002},
 	{0x0F00a044, 0x1fffffff},
@@ -21,7 +21,7 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {//      # DPLL Clock Se
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a04C, 0x0000000C},
-                                        //Memcontroller Default values
+                                        /* Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
@@ -29,17 +29,17 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {//      # DPLL Clock Se
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001},// POP - 0x00020001 Normal 0x01020001
-	{0x0F007020, 0x04030107}, //Normal - 0x04030107 POP - 0x05030107
+	{0x0F00701c, 0x01020001},/*  POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04030107}, /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x02000007},
 	{0x0F007028, 0x02020202},
-	{0x0F00702c, 0x0206060a},//ROB- 0x0205050a,//0x0206060a
+	{0x0F00702c, 0x0206060a},/* ROB- 0x0205050a,0x0206060a */
 	{0x0F007030, 0x05000000},
 	{0x0F007034, 0x00000003};
-	{0x0F007038, 0x110a0200},//ROB - 0x110a0200,//0x180a0200,// 0x1f0a0200
-	{0x0F00703C, 0x02101010},//ROB - 0x02101010,//0x02101018},
-	{0x0F007040, 0x45751200},//ROB - 0x45751200,//0x450f1200},
-	{0x0F007044, 0x110a0d00},//ROB - 0x110a0d00//0x111f0d00
+	{0x0F007038, 0x110a0200},/* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
+	{0x0F00703C, 0x02101010},/* ROB - 0x02101010,0x02101018}, */
+	{0x0F007040, 0x45751200},/* ROB - 0x45751200,0x450f1200}, */
+	{0x0F007044, 0x110a0d00},/*ROB - 0x110a0d00.0x111f0d00 */
 	{0x0F007048, 0x081b0306},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0000001c},
@@ -56,16 +56,16 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {//      # DPLL Clock Se
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-                                        //# Enable BW improvement within memory controller
+                                        /* # Enable BW improvement within memory controller */
 	{0x0F007094, 0x00000104},
-                                        //# Enable 2 ports within X-bar
+                                        /* # Enable 2 ports within X-bar */
 	{0x0F00A000, 0x00000016},
-                                        //# Enable start bit within memory controller
+                                        /* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
                                         };
-//80Mhz
-#define T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 10  //index for 0x0F007000
-static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = {//   # DPLL Clock Setting
+/* 80Mhz */
+#define T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 10  /* index for 0x0F007000 */
+static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = { /*  # DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07f1ffff},
 	{0x0f000860, 0x00000000},
@@ -76,7 +76,7 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = {//   # DPLL Clock Settin
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a000, 0x00000016},
 	{0x0F00a04C, 0x0000000C},
-                                //Memcontroller Default values
+                                /* Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01000000},
 	{0x0F007008, 0x01000001},
@@ -112,19 +112,19 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = {//   # DPLL Clock Settin
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
 	{0x0F007094, 0x00000104},
-                                        //# Enable start bit within memory controller
+                                        /*# Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
                                 };
-//100Mhz
-#define T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 13  //index for 0x0F007000
-static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {//  # DPLL Clock Setting
+/* 100Mhz */
+#define T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 13  /* index for 0x0F007000 */
+static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {/*  # DPLL Clock Setting */
 	{0x0F000800, 0x00007008},
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13E3F},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-                                // Changed source for X-bar and MIPS clock to APLL
-                                //0x0f000840,0x0FFF1800,
+                                /* Changed source for X-bar and MIPS clock to APLL */
+                                /* 0x0f000840,0x0FFF1800, */
 	{0x0f000840, 0x0FFF1B00},
 	{0x0f000870, 0x00000002},
 	{0x0F00a044, 0x1fffffff},
@@ -132,9 +132,9 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {//  # DPLL Clock Settin
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a04C, 0x0000000C},
-                                //# Enable 2 ports within X-bar
+                                /* # Enable 2 ports within X-bar */
 	{0x0F00A000, 0x00000016},
-                                //Memcontroller Default values
+                                /*Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
@@ -142,8 +142,8 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {//  # DPLL Clock Settin
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001}, // POP - 0x00020000 Normal 0x01020000
-	{0x0F007020, 0x04020107},//Normal - 0x04030107 POP - 0x05030107
+	{0x0F00701c, 0x01020001}, /* POP - 0x00020000 Normal 0x01020000 */
+	{0x0F007020, 0x04020107},/* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x00000007},
 	{0x0F007028, 0x01020201},
 	{0x0F00702c, 0x0204040A},
@@ -153,7 +153,7 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {//  # DPLL Clock Settin
 	{0x0F00703C, 0x02030320},
 	{0x0F007040, 0x6E7F1200},
 	{0x0F007044, 0x01190A00},
-	{0x0F007048, 0x06120305},//0x02690204 // 0x06120305
+	{0x0F007048, 0x06120305},/* 0x02690204  0x06120305 */
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0000001C},
 	{0x0F007054, 0x00000000},
@@ -169,43 +169,43 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {//  # DPLL Clock Settin
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-                                //# Enable BW improvement within memory controller
+                                /* # Enable BW improvement within memory controller */
 	{0x0F007094, 0x00000104},
-                                //# Enable start bit within memory controller
+                                /* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
                                 };
 
-//Net T3B DDR Settings
-//DDR INIT-133Mhz
+/* Net T3B DDR Settings */
+/* DDR INIT-133Mhz */
 static struct bcm_ddr_setting asDPLL_266MHZ[] = {
 	{0x0F000800, 0x00007212},
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00000F95},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-                                        // Changed source for X-bar and MIPS clock to APLL
+                                        /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000840, 0x0FFF1B00},
 	{0x0f000870, 0x00000002}
 									  };
 
-#define T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 11  //index for 0x0F007000
-static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {//      # DPLL Clock Setting
+#define T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 11  /* index for 0x0F007000 */
+static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {/* # DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000810, 0x00000F95},
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13652},
 	{0x0f000840, 0x0FFF0800},
-                                        // Changed source for X-bar and MIPS clock to APLL
+                                        /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000880, 0x000003DD},
 	{0x0f000860, 0x00000000},
-                                        // Changed source for X-bar and MIPS clock to APLL
+                                        /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
-                                        //# Enable 2 ports within X-bar
+                                        /* # Enable 2 ports within X-bar */
 	{0x0F00A000, 0x00000016},
-                                        //Memcontroller Default values
+                                        /* Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
@@ -213,17 +213,17 @@ static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {//      # DPLL Clock S
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001},// POP - 0x00020001 Normal 0x01020001
-	{0x0F007020, 0x04030107}, //Normal - 0x04030107 POP - 0x05030107
+	{0x0F00701c, 0x01020001},/* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04030107}, /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x02000007},
 	{0x0F007028, 0x02020202},
-	{0x0F00702c, 0x0206060a},//ROB- 0x0205050a,//0x0206060a
+	{0x0F00702c, 0x0206060a},/* ROB- 0x0205050a,0x0206060a */
 	{0x0F007030, 0x05000000},
 	{0x0F007034, 0x00000003},
-	{0x0F007038, 0x130a0200},//ROB - 0x110a0200,//0x180a0200,// 0x1f0a0200
-	{0x0F00703C, 0x02101012},//ROB - 0x02101010,//0x02101018},
-	{0x0F007040, 0x457D1200},//ROB - 0x45751200,//0x450f1200},
-	{0x0F007044, 0x11130d00},//ROB - 0x110a0d00//0x111f0d00
+	{0x0F007038, 0x130a0200},/* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
+	{0x0F00703C, 0x02101012},/* ROB - 0x02101010,0x02101018}, */
+	{0x0F007040, 0x457D1200},/* ROB - 0x45751200,0x450f1200}, */
+	{0x0F007044, 0x11130d00},/* ROB - 0x110a0d00 0x111f0d00 */
 	{0x0F007048, 0x040D0306},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0000001c},
@@ -240,14 +240,14 @@ static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {//      # DPLL Clock S
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-                                        //# Enable BW improvement within memory controller
+                                        /* # Enable BW improvement within memory controller */
 	{0x0F007094, 0x00000104},
-                                        //# Enable start bit within memory controller
+                                        /* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000},
                                         };
 
-#define T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  //index for 0x0F007000
-static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {//       # DPLL Clock Setting
+#define T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  /*index for 0x0F007000 */
+static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {/* # DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000840, 0x0FFF1F00},
@@ -259,7 +259,7 @@ static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {//       # DPLL Clock S
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a000, 0x00000016},
-										//Memcontroller Default values
+										/* Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01000000},
 	{0x0F007008, 0x01000001},
@@ -295,13 +295,13 @@ static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {//       # DPLL Clock S
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
 	{0x0F007094, 0x00000104},
-										//# Enable start bit within memory controller
+										/* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
 								};
 
-//100Mhz
-#define T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 9  //index for 0x0F007000
-static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {//      # DPLL Clock Setting
+/* 100Mhz */
+#define T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 9  /* index for 0x0F007000 */
+static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {/* # DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F1369B},
 	{0x0f000840, 0x0FFF0800},
@@ -311,9 +311,9 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {//      # DPLL Clock S
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
-										//# Enable 2 ports within X-bar
+										/*# Enable 2 ports within X-bar */
 	{0x0F00A000, 0x00000016},
-								//Memcontroller Default values
+								/* Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
@@ -321,8 +321,8 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {//      # DPLL Clock S
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020000}, // POP - 0x00020000 Normal 0x01020000
-	{0x0F007020, 0x04020107},//Normal - 0x04030107 POP - 0x05030107
+	{0x0F00701c, 0x01020000}, /* POP - 0x00020000 Normal 0x01020000 */
+	{0x0F007020, 0x04020107},/* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x00000007},
 	{0x0F007028, 0x01020201},
 	{0x0F00702c, 0x0204040A},
@@ -332,7 +332,7 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {//      # DPLL Clock S
 	{0x0F00703C, 0x02030320},
 	{0x0F007040, 0x6E7F1200},
 	{0x0F007044, 0x01190A00},
-	{0x0F007048, 0x06120305},//0x02690204 // 0x06120305
+	{0x0F007048, 0x06120305},/*0x02690204  0x06120305 */
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001C},
 	{0x0F007054, 0x00000000},
@@ -348,19 +348,19 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {//      # DPLL Clock S
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-								//# Enable BW improvement within memory controller
+								/* # Enable BW improvement within memory controller */
 	{0x0F007094, 0x00000104},
-								//# Enable start bit within memory controller
+								/* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
 							};
 
 
-#define T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 9  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {//	# DPLL Clock Setting
+#define T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 9  /*index for 0x0F007000 */
+static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {/* # DPLL Clock Setting */
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
-								// Changed source for X-bar and MIPS clock to APLL
+								/* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000840, 0x0FFF0000},
 	{0x0f000860, 0x00000000},
 	{0x0F00a044, 0x1fffffff},
@@ -368,7 +368,7 @@ static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {//	# DPLL Clock Setti
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
-								//Memcontroller Default values
+								/* Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
@@ -376,17 +376,17 @@ static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {//	# DPLL Clock Setti
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001},// POP - 0x00020001 Normal 0x01020001
-	{0x0F007020, 0x04030107}, //Normal - 0x04030107 POP - 0x05030107
+	{0x0F00701c, 0x01020001},/* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04030107}, /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x02000007},
 	{0x0F007028, 0x02020200},
-	{0x0F00702c, 0x0206060a},//ROB- 0x0205050a,//0x0206060a
+	{0x0F00702c, 0x0206060a},/* ROB- 0x0205050a,//0x0206060a */
 	{0x0F007030, 0x05000000},
 	{0x0F007034, 0x00000003},
-	{0x0F007038, 0x200a0200},//ROB - 0x110a0200,//0x180a0200,// 0x1f0a0200
-	{0x0F00703C, 0x02101020},//ROB - 0x02101010,//0x02101018,
-	{0x0F007040, 0x45711200},//ROB - 0x45751200,//0x450f1200,
-	{0x0F007044, 0x110D0D00},//ROB - 0x110a0d00//0x111f0d00
+	{0x0F007038, 0x200a0200},/* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
+	{0x0F00703C, 0x02101020},/* ROB - 0x02101010,0x02101018, */
+	{0x0F007040, 0x45711200},/* ROB - 0x45751200,0x450f1200, */
+	{0x0F007044, 0x110D0D00},/* ROB - 0x110a0d00 0x111f0d00 */
 	{0x0F007048, 0x04080306},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001c},
@@ -406,29 +406,29 @@ static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {//	# DPLL Clock Setti
 	{0x0F007088, 0x01000001},
 	{0x0F00708c, 0x00000101},
 	{0x0F007090, 0x00000000},
-								//# Enable BW improvement within memory controller
+								/*# Enable BW improvement within memory controller */
 	{0x0F007094, 0x00040000},
 	{0x0F007098, 0x00000000},
 	{0x0F0070c8, 0x00000104},
-								//# Enable 2 ports within X-bar
-								//# Enable start bit within memory controller
+								/* # Enable 2 ports within X-bar */
+								/* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
 };
 
-#define T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 11  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {//	# DPLL Clock Setting
+#define T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 11  /* index for 0x0F007000 */
+static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {/*	# DPLL Clock Setting */
 	{0x0f000810, 0x00002F95},
 	{0x0f000820, 0x03F1369B},
 	{0x0f000840, 0x0fff0000},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-								// Changed source for X-bar and MIPS clock to APLL
+								/* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000840, 0x0FFF0000},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
-								//Memcontroller Default values
+								/* Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
@@ -436,17 +436,17 @@ static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {//	# DPLL Clock Setti
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020000},// POP - 0x00020001 Normal 0x01020001
-	{0x0F007020, 0x04020107}, //Normal - 0x04030107 POP - 0x05030107
+	{0x0F00701c, 0x01020000},/* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04020107}, /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x00000007},
 	{0x0F007028, 0x01020200},
-	{0x0F00702c, 0x0204040a},//ROB- 0x0205050a,//0x0206060a
+	{0x0F00702c, 0x0204040a},/* ROB- 0x0205050a,//0x0206060a */
 	{0x0F007030, 0x06000000},
 	{0x0F007034, 0x00000004},
-	{0x0F007038, 0x1F080200},//ROB - 0x110a0200,//0x180a0200,// 0x1f0a0200
-	{0x0F00703C, 0x0203031F},//ROB - 0x02101010,//0x02101018,
-	{0x0F007040, 0x6e001200},//ROB - 0x45751200,//0x450f1200,
-	{0x0F007044, 0x011a0a00},//ROB - 0x110a0d00//0x111f0d00
+	{0x0F007038, 0x1F080200},/* ROB - 0x110a0200,0x180a0200, 0x1f0a0200 */
+	{0x0F00703C, 0x0203031F},/* ROB - 0x02101010,//0x02101018, */
+	{0x0F007040, 0x6e001200},/* ROB - 0x45751200,//0x450f1200, */
+	{0x0F007044, 0x011a0a00},/* ROB - 0x110a0d00//0x111f0d00 */
 	{0x0F007048, 0x03000305},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001c},
@@ -469,14 +469,14 @@ static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {//	# DPLL Clock Setti
 	{0x0F007094, 0x00010000},
 	{0x0F007098, 0x00000000},
 	{0x0F0070C8, 0x00000104},
-								//# Enable 2 ports within X-bar
+								/* # Enable 2 ports within X-bar */
 	{0x0F00A000, 0x00000016},
-								//# Enable start bit within memory controller
+								/* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
 };
 
-#define T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {//	# DPLL Clock Setting
+#define T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  /* index for 0x0F007000 */
+static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {/* # DPLL Clock Setting */
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00002F95},
 	{0x0f000860, 0x00000000},
@@ -533,10 +533,10 @@ static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {//	# DPLL Clock Settin
 
 
 
-///T3 LP-B (UMA-B)
+/* T3 LP-B (UMA-B) */
 
-#define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ 7  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {//	# DPLL Clock Setting
+#define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ 7  /* index for 0x0F007000 */
+static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {/* # DPLL Clock Setting */
 
 	{0x0f000820, 0x03F137DB},
 	{0x0f000810, 0x01842795},
@@ -545,8 +545,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {//	# DPLL Clock Sett
 	{0x0f000840, 0x0FFF0400},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},//this is flash/eeprom clock divisor which set the flash clock to 20 MHz
-	{0x0F00a084, 0x1Cffffff},//Now dump from her in internal memory
+	{0x0f003050, 0x00000021},/* this is flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0F00a084, 0x1Cffffff},/* Now dump from her in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
 	{0x0f007000, 0x00010001},
@@ -593,21 +593,21 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {//	# DPLL Clock Sett
 };
 
 
-#define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 7  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {//	# DPLL Clock Setting
+#define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 7  /* index for 0x0F007000 */
+static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {/*	# DPLL Clock Setting */
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
-								// Changed source for X-bar and MIPS clock to APLL
+								/* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000840, 0x0FFF0000},
 	{0x0f000860, 0x00000000},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},//flash/eeprom clock divisor which set the flash clock to 20 MHz
-	{0x0F00a084, 0x1Cffffff},//dump from here in internal memory
+	{0x0f003050, 0x00000021},/* flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0F00a084, 0x1Cffffff},/* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
-								//Memcontroller Default values
+								/* Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
@@ -615,17 +615,17 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {//	# DPLL Clock Sett
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001},// POP - 0x00020001 Normal 0x01020001
-	{0x0F007020, 0x04030107}, //Normal - 0x04030107 POP - 0x05030107
+	{0x0F00701c, 0x01020001},/* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04030107}, /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x02000007},
 	{0x0F007028, 0x02020200},
-	{0x0F00702c, 0x0206060a},//ROB- 0x0205050a,//0x0206060a
+	{0x0F00702c, 0x0206060a},/* ROB- 0x0205050a,//0x0206060a */
 	{0x0F007030, 0x05000000},
 	{0x0F007034, 0x00000003},
-	{0x0F007038, 0x190a0200},//ROB - 0x110a0200,//0x180a0200,// 0x1f0a0200
-	{0x0F00703C, 0x02101017},//ROB - 0x02101010,//0x02101018,
-	{0x0F007040, 0x45171200},//ROB - 0x45751200,//0x450f1200,
-	{0x0F007044, 0x11290D00},//ROB - 0x110a0d00//0x111f0d00
+	{0x0F007038, 0x190a0200},/* ROB - 0x110a0200,0x180a0200, 0x1f0a0200 */
+	{0x0F00703C, 0x02101017},/* ROB - 0x02101010,0x02101018, */
+	{0x0F007040, 0x45171200},/* ROB - 0x45751200,0x450f1200, */
+	{0x0F007044, 0x11290D00},/* ROB - 0x110a0d00//0x111f0d00 */
 	{0x0F007048, 0x04080306},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001c},
@@ -645,30 +645,30 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {//	# DPLL Clock Sett
 	{0x0F007088, 0x01000001},
 	{0x0F00708c, 0x00000101},
 	{0x0F007090, 0x00000000},
-								//# Enable BW improvement within memory controller
+								/* # Enable BW improvement within memory controller */
 	{0x0F007094, 0x00040000},
 	{0x0F007098, 0x00000000},
 	{0x0F0070c8, 0x00000104},
-								//# Enable 2 ports within X-bar
-								//# Enable start bit within memory controller
+								/* # Enable 2 ports within X-bar */
+								/* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
 };
 
-#define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 8  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {//	# DPLL Clock Setting
+#define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 8  /*index for 0x0F007000 */
+static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {/*	# DPLL Clock Setting */
 	{0x0f000810, 0x00002F95},
 	{0x0f000820, 0x03F1369B},
 	{0x0f000840, 0x0fff0000},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-								// Changed source for X-bar and MIPS clock to APLL
+								/* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000840, 0x0FFF0000},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},//flash/eeprom clock divisor which set the flash clock to 20 MHz
-	{0x0F00a084, 0x1Cffffff}, //dump from here in internal memory
+	{0x0f003050, 0x00000021},/* flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0F00a084, 0x1Cffffff}, /* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
-								//Memcontroller Default values
+								/* Memcontroller Default values */
 	{0x0F007000, 0x00010001},
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
@@ -676,17 +676,17 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {//	# DPLL Clock Sett
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020000},// POP - 0x00020001 Normal 0x01020001
-	{0x0F007020, 0x04020107}, //Normal - 0x04030107 POP - 0x05030107
+	{0x0F00701c, 0x01020000},/* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04020107}, /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x00000007},
 	{0x0F007028, 0x01020200},
-	{0x0F00702c, 0x0204040a},//ROB- 0x0205050a,//0x0206060a
+	{0x0F00702c, 0x0204040a},/*ROB- 0x0205050a,//0x0206060a */
 	{0x0F007030, 0x06000000},
 	{0x0F007034, 0x00000004},
-	{0x0F007038, 0x1F080200},//ROB - 0x110a0200,//0x180a0200,// 0x1f0a0200
-	{0x0F00703C, 0x0203031F},//ROB - 0x02101010,//0x02101018,
-	{0x0F007040, 0x6e001200},//ROB - 0x45751200,//0x450f1200,
-	{0x0F007044, 0x011a0a00},//ROB - 0x110a0d00//0x111f0d00
+	{0x0F007038, 0x1F080200},/* ROB - 0x110a0200,0x180a0200, 0x1f0a0200 */
+	{0x0F00703C, 0x0203031F},/* ROB - 0x02101010,//0x02101018, */
+	{0x0F007040, 0x6e001200},/* ROB - 0x45751200,//0x450f1200, */
+	{0x0F007044, 0x011a0a00},/* ROB - 0x110a0d00//0x111f0d00 */
 	{0x0F007048, 0x03000305},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001c},
@@ -709,14 +709,14 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {//	# DPLL Clock Sett
 	{0x0F007094, 0x00010000},
 	{0x0F007098, 0x00000000},
 	{0x0F0070C8, 0x00000104},
-								//# Enable 2 ports within X-bar
+								/* # Enable 2 ports within X-bar */
 	{0x0F00A000, 0x00000016},
-								//# Enable start bit within memory controller
+								/* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
 };
 
-#define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 7  //index for 0x0F007000
-static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {//	# DPLL Clock Setting
+#define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 7  /*index for 0x0F007000 */
+static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {/* # DPLL Clock Setting */
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00002F95},
 	{0x0f000860, 0x00000000},
@@ -724,8 +724,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {//	# DPLL Clock Setti
 	{0x0f000840, 0x0FFF1F00},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},//flash/eeprom clock divisor which set the flash clock to 20 MHz
-	{0x0F00a084, 0x1Cffffff},// dump from here in internal memory
+	{0x0f003050, 0x00000021},/* flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0F00a084, 0x1Cffffff},/* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
 	{0x0f007000, 0x00010001},
@@ -925,7 +925,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			break;
             case DDR_133_MHZ:
 
-				if(Adapter->bDPLLConfig == PLL_266_MHZ)//266Mhz PLL selected.
+				if(Adapter->bDPLLConfig == PLL_266_MHZ)/*266Mhz PLL selected. */
 				{
 					memcpy(asT3B_DDRSetting133MHz, asDPLL_266MHZ,
 									 sizeof(asDPLL_266MHZ));
@@ -1230,7 +1230,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	default:
 		return -EINVAL;
 	}
-	//total number of Register that has to be dumped
+	/* total number of Register that has to be dumped */
 	value = RegCount  ;
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if(retval)
-- 
1.8.4

