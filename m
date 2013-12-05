Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3LEA1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:27:43 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:55302 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3LEA1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:27:41 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 1/5] Staging: bcm: DDRInit: Fixed coding style issue, replaced spaces w/ tabs.(patch set)
Date: Wed,  4 Dec 2013 19:26:19 -0500
Message-Id: <1386203179-21041-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first patch of a series.
Replaced spaces in margin w/ 1 tab for lines:
 11-15, 17-23, 25-58, 60, 62, 64

 On branch staging-next
---
 drivers/staging/bcm/DDRInit.c | 98 +++++++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 9f7e30f..9ee844c 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -8,60 +8,60 @@
     //DDR INIT-133Mhz
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  //index for 0x0F007000
 static struct bcm_ddr_setting asT3_DDRSetting133MHz[]= {//      # DPLL Clock Setting
-                                        {0x0F000800,0x00007212},
-                                        {0x0f000820,0x07F13FFF},
-                                        {0x0f000810,0x00000F95},
-                                        {0x0f000860,0x00000000},
-                                        {0x0f000880,0x000003DD},
+	{0x0F000800,0x00007212},
+	{0x0f000820,0x07F13FFF},
+	{0x0f000810,0x00000F95},
+	{0x0f000860,0x00000000},
+	{0x0f000880,0x000003DD},
                                         // Changed source for X-bar and MIPS clock to APLL
-                                        {0x0f000840,0x0FFF1B00},
-                                        {0x0f000870,0x00000002},
-                                        {0x0F00a044,0x1fffffff},
-                                        {0x0F00a040,0x1f000000},
-                                        {0x0F00a084,0x1Cffffff},
-                                        {0x0F00a080,0x1C000000},
-                                        {0x0F00a04C,0x0000000C},
+	{0x0f000840,0x0FFF1B00},
+	{0x0f000870,0x00000002},
+	{0x0F00a044,0x1fffffff},
+	{0x0F00a040,0x1f000000},
+	{0x0F00a084,0x1Cffffff},
+	{0x0F00a080,0x1C000000},
+	{0x0F00a04C,0x0000000C},
                                         //Memcontroller Default values
-                                        {0x0F007000,0x00010001},
-                                        {0x0F007004,0x01010100},
-                                        {0x0F007008,0x01000001},
-                                        {0x0F00700c,0x00000000},
-                                        {0x0F007010,0x01000000},
-                                        {0x0F007014,0x01000100},
-                                        {0x0F007018,0x01000000},
-                                        {0x0F00701c,0x01020001},// POP - 0x00020001 Normal 0x01020001
-                                        {0x0F007020,0x04030107}, //Normal - 0x04030107 POP - 0x05030107
-                                        {0x0F007024,0x02000007},
-                                        {0x0F007028,0x02020202},
-                                        {0x0F00702c,0x0206060a},//ROB- 0x0205050a,//0x0206060a
-                                        {0x0F007030,0x05000000},
-                                        {0x0F007034,0x00000003},
-                                        {0x0F007038,0x110a0200},//ROB - 0x110a0200,//0x180a0200,// 0x1f0a0200
-                                        {0x0F00703C,0x02101010},//ROB - 0x02101010,//0x02101018},
-                                        {0x0F007040,0x45751200},//ROB - 0x45751200,//0x450f1200},
-                                        {0x0F007044,0x110a0d00},//ROB - 0x110a0d00//0x111f0d00
-                                        {0x0F007048,0x081b0306},
-                                        {0x0F00704c,0x00000000},
-                                        {0x0F007050,0x0000001c},
-                                        {0x0F007054,0x00000000},
-                                        {0x0F007058,0x00000000},
-                                        {0x0F00705c,0x00000000},
-                                        {0x0F007060,0x0010246c},
-                                        {0x0F007064,0x00000010},
-                                        {0x0F007068,0x00000000},
-                                        {0x0F00706c,0x00000001},
-                                        {0x0F007070,0x00007000},
-                                        {0x0F007074,0x00000000},
-                                        {0x0F007078,0x00000000},
-                                        {0x0F00707C,0x00000000},
-                                        {0x0F007080,0x00000000},
-                                        {0x0F007084,0x00000000},
+	{0x0F007000,0x00010001},
+	{0x0F007004,0x01010100},
+	{0x0F007008,0x01000001},
+	{0x0F00700c,0x00000000},
+	{0x0F007010,0x01000000},
+	{0x0F007014,0x01000100},
+	{0x0F007018,0x01000000},
+	{0x0F00701c,0x01020001},// POP - 0x00020001 Normal 0x01020001
+	{0x0F007020,0x04030107}, //Normal - 0x04030107 POP - 0x05030107
+	{0x0F007024,0x02000007},
+	{0x0F007028,0x02020202},
+	{0x0F00702c,0x0206060a},//ROB- 0x0205050a,//0x0206060a
+	{0x0F007030,0x05000000},
+	{0x0F007034,0x00000003},
+	{0x0F007038,0x110a0200},//ROB - 0x110a0200,//0x180a0200,// 0x1f0a0200
+	{0x0F00703C,0x02101010},//ROB - 0x02101010,//0x02101018},
+	{0x0F007040,0x45751200},//ROB - 0x45751200,//0x450f1200},
+	{0x0F007044,0x110a0d00},//ROB - 0x110a0d00//0x111f0d00
+	{0x0F007048,0x081b0306},
+	{0x0F00704c,0x00000000},
+	{0x0F007050,0x0000001c},
+	{0x0F007054,0x00000000},
+	{0x0F007058,0x00000000},
+	{0x0F00705c,0x00000000},
+	{0x0F007060,0x0010246c},
+	{0x0F007064,0x00000010},
+	{0x0F007068,0x00000000},
+	{0x0F00706c,0x00000001},
+	{0x0F007070,0x00007000},
+	{0x0F007074,0x00000000},
+	{0x0F007078,0x00000000},
+	{0x0F00707C,0x00000000},
+	{0x0F007080,0x00000000},
+	{0x0F007084,0x00000000},
                                         //# Enable BW improvement within memory controller
-                                        {0x0F007094,0x00000104},
+	{0x0F007094,0x00000104},
                                         //# Enable 2 ports within X-bar
-                                        {0x0F00A000,0x00000016},
+	{0x0F00A000,0x00000016},
                                         //# Enable start bit within memory controller
-                                        {0x0F007018,0x01010000}
+	{0x0F007018,0x01010000}
                                         };
 //80Mhz
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 10  //index for 0x0F007000
-- 
1.8.4

