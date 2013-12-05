Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3LEAsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:48:13 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:41939 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab3LEAsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:48:10 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 3/3] Staging: bcm: DDRInit: Fixed coding style issue, replaced spaces w/ tab.(patch set)
Date: Wed,  4 Dec 2013 19:47:14 -0500
Message-Id: <1386204434-21714-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third patch of a series.(3)
Replaced spaces in margin w/ 1 tab for lines:
 121-125, 128-134, 136, 138-171, 173, 175

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
 On branch staging-next
---
 drivers/staging/bcm/DDRInit.c | 98 +++++++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 6f5880b..d31dc71 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -118,61 +118,61 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[]= {//   # DPLL Clock Setting
 //100Mhz
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 13  //index for 0x0F007000
 static struct bcm_ddr_setting asT3_DDRSetting100MHz[]= {//  # DPLL Clock Setting
-                                        {0x0F000800,0x00007008},
-                                        {0x0f000810,0x00000F95},
-                                        {0x0f000820,0x07F13E3F},
-                                        {0x0f000860,0x00000000},
-                                        {0x0f000880,0x000003DD},
+	{0x0F000800,0x00007008},
+	{0x0f000810,0x00000F95},
+	{0x0f000820,0x07F13E3F},
+	{0x0f000860,0x00000000},
+	{0x0f000880,0x000003DD},
                                 // Changed source for X-bar and MIPS clock to APLL
                                 //0x0f000840,0x0FFF1800,
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
                                 //# Enable 2 ports within X-bar
-                                        {0x0F00A000,0x00000016},
+	{0x0F00A000,0x00000016},
                                 //Memcontroller Default values
-                                        {0x0F007000,0x00010001},
-                                        {0x0F007004,0x01010100},
-                                        {0x0F007008,0x01000001},
-                                        {0x0F00700c,0x00000000},
-                                        {0x0F007010,0x01000000},
-                                        {0x0F007014,0x01000100},
-                                        {0x0F007018,0x01000000},
-                                        {0x0F00701c,0x01020001}, // POP - 0x00020000 Normal 0x01020000
-                                        {0x0F007020,0x04020107},//Normal - 0x04030107 POP - 0x05030107
-                                        {0x0F007024,0x00000007},
-                                        {0x0F007028,0x01020201},
-                                        {0x0F00702c,0x0204040A},
-                                        {0x0F007030,0x06000000},
-                                        {0x0F007034,0x00000004},
-                                        {0x0F007038,0x20080200},
-                                        {0x0F00703C,0x02030320},
-                                        {0x0F007040,0x6E7F1200},
-                                        {0x0F007044,0x01190A00},
-                                        {0x0F007048,0x06120305},//0x02690204 // 0x06120305
-                                        {0x0F00704c,0x00000000},
-                                        {0x0F007050,0x0000001C},
-                                        {0x0F007054,0x00000000},
-                                        {0x0F007058,0x00000000},
-                                        {0x0F00705c,0x00000000},
-                                        {0x0F007060,0x00082ED6},
-                                        {0x0F007064,0x0000000A},
-                                        {0x0F007068,0x00000000},
-                                        {0x0F00706c,0x00000001},
-                                        {0x0F007070,0x00005000},
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
+	{0x0F00701c,0x01020001}, // POP - 0x00020000 Normal 0x01020000
+	{0x0F007020,0x04020107},//Normal - 0x04030107 POP - 0x05030107
+	{0x0F007024,0x00000007},
+	{0x0F007028,0x01020201},
+	{0x0F00702c,0x0204040A},
+	{0x0F007030,0x06000000},
+	{0x0F007034,0x00000004},
+	{0x0F007038,0x20080200},
+	{0x0F00703C,0x02030320},
+	{0x0F007040,0x6E7F1200},
+	{0x0F007044,0x01190A00},
+	{0x0F007048,0x06120305},//0x02690204 // 0x06120305
+	{0x0F00704c,0x00000000},
+	{0x0F007050,0x0000001C},
+	{0x0F007054,0x00000000},
+	{0x0F007058,0x00000000},
+	{0x0F00705c,0x00000000},
+	{0x0F007060,0x00082ED6},
+	{0x0F007064,0x0000000A},
+	{0x0F007068,0x00000000},
+	{0x0F00706c,0x00000001},
+	{0x0F007070,0x00005000},
+	{0x0F007074,0x00000000},
+	{0x0F007078,0x00000000},
+	{0x0F00707C,0x00000000},
+	{0x0F007080,0x00000000},
+	{0x0F007084,0x00000000},
                                 //# Enable BW improvement within memory controller
-                                        {0x0F007094,0x00000104},
+	{0x0F007094,0x00000104},
                                 //# Enable start bit within memory controller
-                                        {0x0F007018,0x01010000}
+	{0x0F007018,0x01010000}
                                 };
 
 //Net T3B DDR Settings
-- 
1.8.4

