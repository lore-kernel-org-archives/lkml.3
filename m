Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3LGHkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 02:40:12 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52727 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3LGHkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 02:40:10 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 10/10] Staging: bcm: DDRInit: tidy up comments.
Date: Sat,  7 Dec 2013 02:40:02 -0500
Message-Id: <1386402002-14884-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the tenth patch of a series.

Signed-off-by:Gary Alan Rookard <garyrookard@gmail.com>
---
On branch staging-next
 drivers/staging/bcm/DDRInit.c | 231 +++++++++++++++++++++---------------------
 1 file changed, 116 insertions(+), 115 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 1b73819..96afa15 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -7,37 +7,37 @@
 
     /* DDR INIT-133Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {     /* # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {  /* # DPLL Clock Setting */
 	{0x0F000800, 0x00007212},
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00000F95},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-	{0x0f000840, 0x0FFF1B00},       /* Changed source for X-bar and MIPS clock to APLL */
+	{0x0f000840, 0x0FFF1B00},  /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000870, 0x00000002},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a04C, 0x0000000C},
-	{0x0F007000, 0x00010001},       /* Memcontroller Default values */
+	{0x0F007000, 0x00010001},  /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001},/*  POP - 0x00020001 Normal 0x01020001 */
-	{0x0F007020, 0x04030107}, /* Normal - 0x04030107 POP - 0x05030107 */
+	{0x0F00701c, 0x01020001},  /*  POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04030107},  /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x02000007},
 	{0x0F007028, 0x02020202},
-	{0x0F00702c, 0x0206060a},/* ROB- 0x0205050a,0x0206060a */
+	{0x0F00702c, 0x0206060a},  /* ROB- 0x0205050a,0x0206060a */
 	{0x0F007030, 0x05000000},
 	{0x0F007034, 0x00000003};
-	{0x0F007038, 0x110a0200},/* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
-	{0x0F00703C, 0x02101010},/* ROB - 0x02101010,0x02101018}, */
-	{0x0F007040, 0x45751200},/* ROB - 0x45751200,0x450f1200}, */
-	{0x0F007044, 0x110a0d00},/*ROB - 0x110a0d00.0x111f0d00 */
+	{0x0F007038, 0x110a0200},  /* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
+	{0x0F00703C, 0x02101010},  /* ROB - 0x02101010,0x02101018}, */
+	{0x0F007040, 0x45751200},  /* ROB - 0x45751200,0x450f1200}, */
+	{0x0F007044, 0x110a0d00},  /*ROB - 0x110a0d00.0x111f0d00 */
 	{0x0F007048, 0x081b0306},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0000001c},
@@ -54,13 +54,13 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {     /* # DPLL Clock Se
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-	{0x0F007094, 0x00000104},       /* # Enable BW improvement within memory controller */
-	{0x0F00A000, 0x00000016},       /* # Enable 2 ports within X-bar */
-	{0x0F007018, 0x01010000}        /* # Enable start bit within memory controller */
+	{0x0F007094, 0x00000104},  /* # Enable BW improvement within memory controller */
+	{0x0F00A000, 0x00000016},  /* # Enable 2 ports within X-bar */
+	{0x0F007018, 0x01010000}   /* # Enable start bit within memory controller */
 };
 /* 80Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 10  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = { /*  # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = {  /*  # DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07f1ffff},
 	{0x0f000860, 0x00000000},
@@ -106,18 +106,18 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = { /*  # DPLL Clock Settin
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
 	{0x0F007094, 0x00000104},
-	{0x0F007018, 0x01010000}        /* # Enable start bit within memory controller */
+	{0x0F007018, 0x01010000}   /* # Enable start bit within memory controller */
 };
 /* 100Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 13  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {/*  # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {  /* # DPLL Clock Setting */
 	{0x0F000800, 0x00007008},
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13E3F},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-	{0x0f000840, 0x0FFF1B00}, /* Changed source for X-bar and MIPS clock to APLL */
-	/* 0x0f000840,0x0FFF1800, */
+	{0x0f000840, 0x0FFF1B00},  /* Changed source for X-bar and MIPS clock to APLL */
+                                   /* 0x0f000840,0x0FFF1800, */
 	{0x0f000870, 0x00000002},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
@@ -132,8 +132,8 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {/*  # DPLL Clock Settin
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001}, /* POP - 0x00020000 Normal 0x01020000 */
-	{0x0F007020, 0x04020107},/* Normal - 0x04030107 POP - 0x05030107 */
+	{0x0F00701c, 0x01020001},  /* POP - 0x00020000 Normal 0x01020000 */
+	{0x0F007020, 0x04020107},  /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x00000007},
 	{0x0F007028, 0x01020201},
 	{0x0F00702c, 0x0204040A},
@@ -143,7 +143,7 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {/*  # DPLL Clock Settin
 	{0x0F00703C, 0x02030320},
 	{0x0F007040, 0x6E7F1200},
 	{0x0F007044, 0x01190A00},
-	{0x0F007048, 0x06120305},/* 0x02690204  0x06120305 */
+	{0x0F007048, 0x06120305},  /* 0x02690204  0x06120305 */
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0000001C},
 	{0x0F007054, 0x00000000},
@@ -160,7 +160,7 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {/*  # DPLL Clock Settin
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
 	{0x0F007094, 0x00000104},  /* # Enable BW improvement within memory controller */
-	{0x0F007018, 0x01010000}  /* # Enable start bit within memory controller */
+	{0x0F007018, 0x01010000}   /* # Enable start bit within memory controller */
 };
 /* Net T3B DDR Settings */
 /* DDR INIT-133Mhz */
@@ -175,37 +175,37 @@ static struct bcm_ddr_setting asDPLL_266MHZ[] = {
 };
 
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 11  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {/* # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {  /* # DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000810, 0x00000F95},
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13652},
 	{0x0f000840, 0x0FFF0800},
-	{0x0f000880, 0x000003DD},       /* Changed source for X-bar and MIPS clock to APLL */
+	{0x0f000880, 0x000003DD},  /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000860, 0x00000000},
-	{0x0F00a044, 0x1fffffff},       /* Changed source for X-bar and MIPS clock to APLL */
+	{0x0F00a044, 0x1fffffff},  /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
-	{0x0F00A000, 0x00000016},       /* # Enable 2 ports within X-bar */
-	{0x0F007000, 0x00010001},       /* Memcontroller Default values */
+	{0x0F00A000, 0x00000016},  /* # Enable 2 ports within X-bar */
+	{0x0F007000, 0x00010001},  /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001},/* POP - 0x00020001 Normal 0x01020001 */
-	{0x0F007020, 0x04030107}, /* Normal - 0x04030107 POP - 0x05030107 */
+	{0x0F00701c, 0x01020001},  /* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04030107},  /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x02000007},
 	{0x0F007028, 0x02020202},
-	{0x0F00702c, 0x0206060a},/* ROB- 0x0205050a,0x0206060a */
+	{0x0F00702c, 0x0206060a},  /* ROB- 0x0205050a,0x0206060a */
 	{0x0F007030, 0x05000000},
 	{0x0F007034, 0x00000003},
-	{0x0F007038, 0x130a0200},/* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
-	{0x0F00703C, 0x02101012},/* ROB - 0x02101010,0x02101018}, */
-	{0x0F007040, 0x457D1200},/* ROB - 0x45751200,0x450f1200}, */
-	{0x0F007044, 0x11130d00},/* ROB - 0x110a0d00 0x111f0d00 */
+	{0x0F007038, 0x130a0200},  /* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
+	{0x0F00703C, 0x02101012},  /* ROB - 0x02101010,0x02101018}, */
+	{0x0F007040, 0x457D1200},  /* ROB - 0x45751200,0x450f1200}, */
+	{0x0F007044, 0x11130d00},  /* ROB - 0x110a0d00 0x111f0d00 */
 	{0x0F007048, 0x040D0306},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0000001c},
@@ -222,12 +222,12 @@ static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {/* # DPLL Clock Settin
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-	{0x0F007094, 0x00000104},       /* # Enable BW improvement within memory controller */
-	{0x0F007018, 0x01010000},       /* # Enable start bit within memory controller */
+	{0x0F007094, 0x00000104},  /* # Enable BW improvement within memory controller */
+	{0x0F007018, 0x01010000},  /* # Enable start bit within memory controller */
 };
 
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  /*index for 0x0F007000 */
-static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {/* # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {  /* # DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000840, 0x0FFF1F00},
@@ -238,7 +238,7 @@ static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {/* # DPLL Clock Setting
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00a000, 0x00000016},
-	{0x0F007000, 0x00010001},                                               /* Memcontroller Default values */
+	{0x0F007000, 0x00010001},  /* Memcontroller Default values */
 	{0x0F007004, 0x01000000},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
@@ -273,11 +273,11 @@ static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {/* # DPLL Clock Setting
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
 	{0x0F007094, 0x00000104},
-	{0x0F007018, 0x01010000}                                                /* # Enable start bit within memory controller */
+	{0x0F007018, 0x01010000}   /* # Enable start bit within memory controller */
 };
 /* 100Mhz */
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 9  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {/* # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {  /* # DPLL Clock Setting */
 	{0x0f000810, 0x00000F95},
 	{0x0f000820, 0x07F1369B},
 	{0x0f000840, 0x0FFF0800},
@@ -287,16 +287,16 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {/* # DPLL Clock Settin
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
-	{0x0F00A000, 0x00000016},                                               /*# Enable 2 ports within X-bar */
-	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
+	{0x0F00A000, 0x00000016},  /*# Enable 2 ports within X-bar */
+	{0x0F007000, 0x00010001},  /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020000}, /* POP - 0x00020000 Normal 0x01020000 */
-	{0x0F007020, 0x04020107},/* Normal - 0x04030107 POP - 0x05030107 */
+	{0x0F00701c, 0x01020000},  /* POP - 0x00020000 Normal 0x01020000 */
+	{0x0F007020, 0x04020107},  /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x00000007},
 	{0x0F007028, 0x01020201},
 	{0x0F00702c, 0x0204040A},
@@ -306,7 +306,7 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {/* # DPLL Clock Settin
 	{0x0F00703C, 0x02030320},
 	{0x0F007040, 0x6E7F1200},
 	{0x0F007044, 0x01190A00},
-	{0x0F007048, 0x06120305},/*0x02690204  0x06120305 */
+	{0x0F007048, 0x06120305},  /*0x02690204  0x06120305 */
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001C},
 	{0x0F007054, 0x00000000},
@@ -322,39 +322,39 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {/* # DPLL Clock Settin
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-	{0x0F007094, 0x00000104},                               /* # Enable BW improvement within memory controller */
-	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
+	{0x0F007094, 0x00000104},  /* # Enable BW improvement within memory controller */
+	{0x0F007018, 0x01010000}   /* # Enable start bit within memory controller */
 };
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 9  /*index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {/* # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {  /* # DPLL Clock Setting */
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
-	{0x0f000840, 0x0FFF0000},                               /* Changed source for X-bar and MIPS clock to APLL */
+	{0x0f000840, 0x0FFF0000},  /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000860, 0x00000000},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
-	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
+	{0x0F007000, 0x00010001},  /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001},/* POP - 0x00020001 Normal 0x01020001 */
-	{0x0F007020, 0x04030107}, /* Normal - 0x04030107 POP - 0x05030107 */
+	{0x0F00701c, 0x01020001},  /* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04030107},  /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x02000007},
 	{0x0F007028, 0x02020200},
-	{0x0F00702c, 0x0206060a},/* ROB- 0x0205050a,//0x0206060a */
+	{0x0F00702c, 0x0206060a},  /* ROB- 0x0205050a,//0x0206060a */
 	{0x0F007030, 0x05000000},
 	{0x0F007034, 0x00000003},
-	{0x0F007038, 0x200a0200},/* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
-	{0x0F00703C, 0x02101020},/* ROB - 0x02101010,0x02101018, */
-	{0x0F007040, 0x45711200},/* ROB - 0x45751200,0x450f1200, */
-	{0x0F007044, 0x110D0D00},/* ROB - 0x110a0d00 0x111f0d00 */
+	{0x0F007038, 0x200a0200},  /* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
+	{0x0F00703C, 0x02101020},  /* ROB - 0x02101010,0x02101018, */
+	{0x0F007040, 0x45711200},  /* ROB - 0x45751200,0x450f1200, */
+	{0x0F007044, 0x110D0D00},  /* ROB - 0x110a0d00 0x111f0d00 */
 	{0x0F007048, 0x04080306},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001c},
@@ -374,42 +374,42 @@ static struct bcm_ddr_setting asT3LP_DDRSetting133MHz[] = {/* # DPLL Clock Setti
 	{0x0F007088, 0x01000001},
 	{0x0F00708c, 0x00000101},
 	{0x0F007090, 0x00000000},
-	{0x0F007094, 0x00040000},                               /*# Enable BW improvement within memory controller */
+	{0x0F007094, 0x00040000},  /*# Enable BW improvement within memory controller */
 	{0x0F007098, 0x00000000},
 	{0x0F0070c8, 0x00000104},
-								/* # Enable 2 ports within X-bar */
-	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
+                                   /* # Enable 2 ports within X-bar */
+	{0x0F007018, 0x01010000}   /* # Enable start bit within memory controller */
 };
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 11  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {/*	# DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {  /*	# DPLL Clock Setting */
 	{0x0f000810, 0x00002F95},
 	{0x0f000820, 0x03F1369B},
 	{0x0f000840, 0x0fff0000},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-	{0x0f000840, 0x0FFF0000},                               /* Changed source for X-bar and MIPS clock to APLL */
+	{0x0f000840, 0x0FFF0000},  /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
 	{0x0F00a084, 0x1Cffffff},
 	{0x0F00a080, 0x1C000000},
-	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
+	{0x0F007000, 0x00010001},  /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020000},/* POP - 0x00020001 Normal 0x01020001 */
-	{0x0F007020, 0x04020107}, /* Normal - 0x04030107 POP - 0x05030107 */
+	{0x0F00701c, 0x01020000},  /* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04020107},  /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x00000007},
 	{0x0F007028, 0x01020200},
-	{0x0F00702c, 0x0204040a},/* ROB- 0x0205050a,//0x0206060a */
+	{0x0F00702c, 0x0204040a},  /* ROB- 0x0205050a,//0x0206060a */
 	{0x0F007030, 0x06000000},
 	{0x0F007034, 0x00000004},
-	{0x0F007038, 0x1F080200},/* ROB - 0x110a0200,0x180a0200, 0x1f0a0200 */
-	{0x0F00703C, 0x0203031F},/* ROB - 0x02101010,//0x02101018, */
-	{0x0F007040, 0x6e001200},/* ROB - 0x45751200,//0x450f1200, */
-	{0x0F007044, 0x011a0a00},/* ROB - 0x110a0d00//0x111f0d00 */
+	{0x0F007038, 0x1F080200},  /* ROB - 0x110a0200,0x180a0200, 0x1f0a0200 */
+	{0x0F00703C, 0x0203031F},  /* ROB - 0x02101010,//0x02101018, */
+	{0x0F007040, 0x6e001200},  /* ROB - 0x45751200,//0x450f1200, */
+	{0x0F007044, 0x011a0a00},  /* ROB - 0x110a0d00//0x111f0d00 */
 	{0x0F007048, 0x03000305},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001c},
@@ -432,11 +432,11 @@ static struct bcm_ddr_setting asT3LP_DDRSetting100MHz[] = {/*	# DPLL Clock Setti
 	{0x0F007094, 0x00010000},
 	{0x0F007098, 0x00000000},
 	{0x0F0070C8, 0x00000104},
-	{0x0F00A000, 0x00000016},                               /* # Enable 2 ports within X-bar */
-	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
+	{0x0F00A000, 0x00000016},  /* # Enable 2 ports within X-bar */
+	{0x0F007018, 0x01010000}   /* # Enable start bit within memory controller */
 };
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {/* # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {  /* # DPLL Clock Setting */
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00002F95},
 	{0x0f000860, 0x00000000},
@@ -491,7 +491,7 @@ static struct bcm_ddr_setting asT3LP_DDRSetting80MHz[] = {/* # DPLL Clock Settin
 };
 /* T3 LP-B (UMA-B) */
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ 7  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {/* # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {  /* # DPLL Clock Setting */
 	{0x0f000820, 0x03F137DB},
 	{0x0f000810, 0x01842795},
 	{0x0f000860, 0x00000000},
@@ -499,8 +499,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {/* # DPLL Clock Sett
 	{0x0f000840, 0x0FFF0400},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},/* this is flash/eeprom clock divisor which set the flash clock to 20 MHz */
-	{0x0F00a084, 0x1Cffffff},/* Now dump from her in internal memory */
+	{0x0f003050, 0x00000021},  /* this is flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0F00a084, 0x1Cffffff},  /* Now dump from her in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
 	{0x0f007000, 0x00010001},
@@ -546,36 +546,36 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting160MHz[] = {/* # DPLL Clock Sett
 	{0x0F007018, 0x01010000}
 };
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 7  /* index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {/*	# DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {  /*	# DPLL Clock Setting */
 	{0x0f000820, 0x03F1365B},
 	{0x0f000810, 0x00002F95},
 	{0x0f000880, 0x000003DD},
-	{0x0f000840, 0x0FFF0000},                               /* Changed source for X-bar and MIPS clock to APLL */
+	{0x0f000840, 0x0FFF0000},  /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000860, 0x00000000},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},/* flash/eeprom clock divisor which set the flash clock to 20 MHz */
-	{0x0F00a084, 0x1Cffffff},/* dump from here in internal memory */
+	{0x0f003050, 0x00000021},  /* flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0F00a084, 0x1Cffffff},  /* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
-	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
+	{0x0F007000, 0x00010001},  /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020001},/* POP - 0x00020001 Normal 0x01020001 */
-	{0x0F007020, 0x04030107}, /* Normal - 0x04030107 POP - 0x05030107 */
+	{0x0F00701c, 0x01020001},  /* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04030107},  /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x02000007},
 	{0x0F007028, 0x02020200},
-	{0x0F00702c, 0x0206060a},/* ROB- 0x0205050a,//0x0206060a */
+	{0x0F00702c, 0x0206060a},  /* ROB- 0x0205050a,//0x0206060a */
 	{0x0F007030, 0x05000000},
 	{0x0F007034, 0x00000003},
-	{0x0F007038, 0x190a0200},/* ROB - 0x110a0200,0x180a0200, 0x1f0a0200 */
-	{0x0F00703C, 0x02101017},/* ROB - 0x02101010,0x02101018, */
-	{0x0F007040, 0x45171200},/* ROB - 0x45751200,0x450f1200, */
-	{0x0F007044, 0x11290D00},/* ROB - 0x110a0d00//0x111f0d00 */
+	{0x0F007038, 0x190a0200},  /* ROB - 0x110a0200,0x180a0200, 0x1f0a0200 */
+	{0x0F00703C, 0x02101017},  /* ROB - 0x02101010,0x02101018, */
+	{0x0F007040, 0x45171200},  /* ROB - 0x45751200,0x450f1200, */
+	{0x0F007044, 0x11290D00},  /* ROB - 0x110a0d00//0x111f0d00 */
 	{0x0F007048, 0x04080306},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001c},
@@ -595,43 +595,43 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting133MHz[] = {/*	# DPLL Clock Sett
 	{0x0F007088, 0x01000001},
 	{0x0F00708c, 0x00000101},
 	{0x0F007090, 0x00000000},
-	{0x0F007094, 0x00040000},                               /* # Enable BW improvement within memory controller */
+	{0x0F007094, 0x00040000},  /* # Enable BW improvement within memory controller */
 	{0x0F007098, 0x00000000},
 	{0x0F0070c8, 0x00000104},
-								/* # Enable 2 ports within X-bar */
-	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
+                                   /* # Enable 2 ports within X-bar */
+	{0x0F007018, 0x01010000}   /* # Enable start bit within memory controller */
 };
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 8  /*index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {/*	# DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {   /* # DPLL Clock Setting */
 	{0x0f000810, 0x00002F95},
 	{0x0f000820, 0x03F1369B},
 	{0x0f000840, 0x0fff0000},
 	{0x0f000860, 0x00000000},
 	{0x0f000880, 0x000003DD},
-	{0x0f000840, 0x0FFF0000},                               /* Changed source for X-bar and MIPS clock to APLL */
+	{0x0f000840, 0x0FFF0000},  /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},/* flash/eeprom clock divisor which set the flash clock to 20 MHz */
-	{0x0F00a084, 0x1Cffffff}, /* dump from here in internal memory */
+	{0x0f003050, 0x00000021},  /* flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0F00a084, 0x1Cffffff},  /* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
-	{0x0F007000, 0x00010001},                               /* Memcontroller Default values */
+	{0x0F007000, 0x00010001},  /* Memcontroller Default values */
 	{0x0F007004, 0x01010100},
 	{0x0F007008, 0x01000001},
 	{0x0F00700c, 0x00000000},
 	{0x0F007010, 0x01000000},
 	{0x0F007014, 0x01000100},
 	{0x0F007018, 0x01000000},
-	{0x0F00701c, 0x01020000},/* POP - 0x00020001 Normal 0x01020001 */
-	{0x0F007020, 0x04020107}, /* Normal - 0x04030107 POP - 0x05030107 */
+	{0x0F00701c, 0x01020000},  /* POP - 0x00020001 Normal 0x01020001 */
+	{0x0F007020, 0x04020107},  /* Normal - 0x04030107 POP - 0x05030107 */
 	{0x0F007024, 0x00000007},
 	{0x0F007028, 0x01020200},
-	{0x0F00702c, 0x0204040a},/*ROB- 0x0205050a,//0x0206060a */
+	{0x0F00702c, 0x0204040a},  /*ROB- 0x0205050a,//0x0206060a */
 	{0x0F007030, 0x06000000},
 	{0x0F007034, 0x00000004},
-	{0x0F007038, 0x1F080200},/* ROB - 0x110a0200,0x180a0200, 0x1f0a0200 */
-	{0x0F00703C, 0x0203031F},/* ROB - 0x02101010,//0x02101018, */
-	{0x0F007040, 0x6e001200},/* ROB - 0x45751200,//0x450f1200, */
-	{0x0F007044, 0x011a0a00},/* ROB - 0x110a0d00//0x111f0d00 */
+	{0x0F007038, 0x1F080200},  /* ROB - 0x110a0200,0x180a0200, 0x1f0a0200 */
+	{0x0F00703C, 0x0203031F},  /* ROB - 0x02101010,//0x02101018, */
+	{0x0F007040, 0x6e001200},  /* ROB - 0x45751200,//0x450f1200, */
+	{0x0F007044, 0x011a0a00},  /* ROB - 0x110a0d00//0x111f0d00 */
 	{0x0F007048, 0x03000305},
 	{0x0F00704c, 0x00000000},
 	{0x0F007050, 0x0100001c},
@@ -654,11 +654,11 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting100MHz[] = {/*	# DPLL Clock Sett
 	{0x0F007094, 0x00010000},
 	{0x0F007098, 0x00000000},
 	{0x0F0070C8, 0x00000104},
-	{0x0F00A000, 0x00000016},				/* # Enable 2 ports within X-bar */
-	{0x0F007018, 0x01010000}                                /* # Enable start bit within memory controller */
+	{0x0F00A000, 0x00000016},  /* # Enable 2 ports within X-bar */
+	{0x0F007018, 0x01010000}   /* # Enable start bit within memory controller */
 };
 #define T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 7  /*index for 0x0F007000 */
-static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {/* # DPLL Clock Setting */
+static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {  /* # DPLL Clock Setting */
 	{0x0f000820, 0x07F13FFF},
 	{0x0f000810, 0x00002F95},
 	{0x0f000860, 0x00000000},
@@ -666,8 +666,8 @@ static struct bcm_ddr_setting asT3LPB_DDRSetting80MHz[] = {/* # DPLL Clock Setti
 	{0x0f000840, 0x0FFF1F00},
 	{0x0F00a044, 0x1fffffff},
 	{0x0F00a040, 0x1f000000},
-	{0x0f003050, 0x00000021},/* flash/eeprom clock divisor which set the flash clock to 20 MHz */
-	{0x0F00a084, 0x1Cffffff},/* dump from here in internal memory */
+	{0x0f003050, 0x00000021},  /* flash/eeprom clock divisor which set the flash clock to 20 MHz */
+	{0x0F00a084, 0x1Cffffff},  /* dump from here in internal memory */
 	{0x0F00a080, 0x1C000000},
 	{0x0F00A000, 0x00000016},
 	{0x0f007000, 0x00010001},
@@ -753,9 +753,9 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	case BCS220_2BC:
 	case BCS250_BC:
 	case BCS220_3:
-		/* Set bit 2 and bit 6 to 1 for BBIC 2mA drive
-		 * (please check current value and additionally set these bits)
-		 */
+/* Set bit 2 and bit 6 to 1 for BBIC 2mA drive
+ * (please check current value and additionally set these bits)
+ */
 	if ((Adapter->chip_id !=  BCS220_2) &&
 		(Adapter->chip_id !=  BCS220_2BC) &&
 		(Adapter->chip_id != BCS220_3)) {
@@ -839,7 +839,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		sizeof(struct bcm_ddr_setting));
 			break;
 		case DDR_133_MHZ:
-			if (Adapter->bDPLLConfig == PLL_266_MHZ) { /*266Mhz PLL selected. */
+			if (Adapter->bDPLLConfig == PLL_266_MHZ) {  /*266Mhz PLL selected. */
 				memcpy(asT3B_DDRSetting133MHz, asDPLL_266MHZ,
 				sizeof(asDPLL_266MHZ));
 				psDDRSetting = asT3B_DDRSetting133MHz;
@@ -915,8 +915,8 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		 * This is to be done only for Hybrid PMU mode.
 		 * with the current h/w there is no way to detect this.
 		 * and since we dont have internal PMU lets do it under UMA-B chip id.
-	     * we will change this when we will have internal PMU.
-	     */
+	         * we will change this when we will have internal PMU.
+	         */
 		if (Adapter->PmuMode == HYBRID_MODE_7C) {
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if (retval < 0) {
@@ -1119,7 +1119,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 		return retval;
 	}
 	ul_ddr_setting_load_addr += sizeof(ULONG);
-	/*signature */
+	/* signature */
 	value = (0x1d1e0dd0);
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if (retval) {
@@ -1158,3 +1158,4 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 }
 
 
+
-- 
1.8.4

