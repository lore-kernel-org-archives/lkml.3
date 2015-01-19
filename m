Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbbASIM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:12:27 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33836 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbASILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:11:31 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH v2 4/7] staging: sm7xxfb: add missing blank line
Date: Mon, 19 Jan 2015 13:41:03 +0530
Message-Id: <1421655067-7490-4-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1421655067-7490-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1421655067-7490-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch cleanup to add missing blank line after declaration

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/sm7xxfb/sm7xxfb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index c550b71..6bce9f1 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -259,6 +259,7 @@ static int smtc_setcolreg(unsigned regno, unsigned red, unsigned green,
 		if (regno < 16) {
 			if (sfb->fb.var.bits_per_pixel == 16) {
 				u32 *pal = sfb->fb.pseudo_palette;
+
 				val = chan_to_field(red, &sfb->fb.var.red);
 				val |= chan_to_field(green, &sfb->fb.var.green);
 				val |= chan_to_field(blue, &sfb->fb.var.blue);
@@ -273,6 +274,7 @@ static int smtc_setcolreg(unsigned regno, unsigned red, unsigned green,
 #endif
 			} else {
 				u32 *pal = sfb->fb.pseudo_palette;
+
 				val = chan_to_field(red, &sfb->fb.var.red);
 				val |= chan_to_field(green, &sfb->fb.var.green);
 				val |= chan_to_field(blue, &sfb->fb.var.blue);
-- 
1.8.1.2

