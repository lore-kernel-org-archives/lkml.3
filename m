Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab3I0MRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:17:20 -0400
Received: from mailrelay.sea-ab.se ([91.223.232.53]:39705 "EHLO
	mailrelay.sea-ab.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3I0MRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:17:19 -0400
X-Greylist: delayed 634 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Sep 2013 08:17:18 EDT
From: Martin Berglund <martin@rogsta.net>
To: teddy.wang@siliconmotion.com.cn
Cc: gregkh@linuxfoundation.org, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Martin Berglund <martin@rogsta.net>
Subject: [PATCH] Staging: sm7xxfb: fixed line break coding style issues
Date: Fri, 27 Sep 2013 14:08:07 +0200
Message-Id: <1380283687-21524-1-git-send-email-martin@rogsta.net>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.

Signed-off-by: Martin Berglund <martin@rogsta.net>
---
 drivers/staging/sm7xxfb/sm7xxfb.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 8add64b..57d8145 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -259,8 +259,7 @@ static int smtc_setcolreg(unsigned regno, unsigned red, unsigned green,
 			if (sfb->fb.var.bits_per_pixel == 16) {
 				u32 *pal = sfb->fb.pseudo_palette;
 				val = chan_to_field(red, &sfb->fb.var.red);
-				val |= chan_to_field(green, \
-						&sfb->fb.var.green);
+				val |= chan_to_field(green, &sfb->fb.var.green);
 				val |= chan_to_field(blue, &sfb->fb.var.blue);
 #ifdef __BIG_ENDIAN
 				pal[regno] =
@@ -274,8 +273,7 @@ static int smtc_setcolreg(unsigned regno, unsigned red, unsigned green,
 			} else {
 				u32 *pal = sfb->fb.pseudo_palette;
 				val = chan_to_field(red, &sfb->fb.var.red);
-				val |= chan_to_field(green, \
-						&sfb->fb.var.green);
+				val |= chan_to_field(green, &sfb->fb.var.green);
 				val |= chan_to_field(blue, &sfb->fb.var.blue);
 #ifdef __BIG_ENDIAN
 				val =
@@ -508,9 +506,8 @@ static void sm7xx_set_timing(struct smtcfb_info *sfb)
 
 			/* init SEQ register SR30 - SR75 */
 			for (i = 0; i < SIZE_SR30_SR75; i++)
-				if (((i + 0x30) != 0x62) \
-					&& ((i + 0x30) != 0x6a) \
-					&& ((i + 0x30) != 0x6b))
+				if (((i + 0x30) != 0x62) && ((i + 0x30) != 0x6a)
+							&& ((i + 0x30) != 0x6b))
 					smtc_seqw(i + 0x30,
 						VGAMode[j].Init_SR30_SR75[i]);
 
-- 
1.8.4

