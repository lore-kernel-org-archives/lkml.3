Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaJSNLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:11:21 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58201 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaJSNLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:11:00 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Greg Donald <gdonald@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Artem Fetishev <wwctrsrx@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] staging: ft1000: else should follow close brace '}'
Date: Sun, 19 Oct 2014 20:59:47 +0800
Message-Id: <1413723590-19690-5-git-send-email-weixiang.chen@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
References: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code style error from ft1000/ft1000-pcmcia/ft1000_hw.c:
ERROR: else should follow close brace '}'

Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index fc28dee..1bf685a 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -595,8 +595,7 @@ static void ft1000_hbchk(u_long data)
 		if (tempword != ho) {
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-			}
-			else {
+			} else {
 				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
 			}
 		}
@@ -715,15 +714,13 @@ static void ft1000_hbchk(u_long data)
 		if (tempword != hi) {
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				ft1000_write_dpram(dev, FT1000_HI_HO, hi);
-			}
-			else {
+			} else {
 				ft1000_write_dpram_mag_16(dev, FT1000_MAG_HI_HO, hi_mag, FT1000_MAG_HI_HO_INDX);
 			}
 
 			if (info->AsicID == ELECTRABUZZ_ID) {
 				tempword = ft1000_read_dpram(dev, FT1000_HI_HO);
-			}
-			else {
+			} else {
 				tempword = ntohs(ft1000_read_dpram_mag_16(dev, FT1000_MAG_HI_HO, FT1000_MAG_HI_HO_INDX));
 			}
 
@@ -994,8 +991,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 
     if (info->AsicID == ELECTRABUZZ_ID) {
         tempword = FT1000_DPRAM_RX_BASE+2;
-    }
-    else {
+    } else {
         tempword = FT1000_DPRAM_MAG_RX_BASE;
     }
     if ( ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword) ) {
@@ -1075,8 +1071,7 @@ static void ft1000_proc_drvmsg(struct net_device *dev)
 					info->ConTm = 0;
 				}
 			}
-            }
-            else {
+            } else {
                 DEBUG(1, "Media is down\n");
                 if (info->mediastate == 1) {
                     info->mediastate = 0;
-- 
2.1.1

