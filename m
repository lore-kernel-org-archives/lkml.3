Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab3LEBNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:13:39 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50645 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3LEBNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:13:12 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 4/5] Staging: bcm: DDRInit: Fixed coding style issue, repaced spaces w/ tab.(patch set)
Date: Wed,  4 Dec 2013 20:13:05 -0500
Message-Id: <1386205985-3502-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth patch of a series.(4)
Replaced spaces in margin w/ 1 tab for lines:
 181-185, 187-188

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
 On branch staging-next
---
 drivers/staging/bcm/DDRInit.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index d31dc71..fdeb4f6 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -178,14 +178,14 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[]= {//  # DPLL Clock Setting
 //Net T3B DDR Settings
 //DDR INIT-133Mhz
 static struct bcm_ddr_setting asDPLL_266MHZ[] = {
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
-                                        {0x0f000870,0x00000002}
+	{0x0f000840,0x0FFF1B00},
+	{0x0f000870,0x00000002}
 									  };
 
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 11  //index for 0x0F007000
-- 
1.8.4

