Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3KBTMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 15:12:40 -0400
Received: from [199.73.29.170] ([199.73.29.170]:58018 "EHLO
	gumby.musicalcarrion.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab3KBTMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 15:12:38 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Nov 2013 15:12:38 EDT
From: matthew@incomplete.io
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, Matthew Geddes <matthew@incomplete.io>
Subject: [PATCH] INPUT: wacom: Added definition for Wacom CTH680 The Wacom Creative Pen & Touch Tablet M (CTH680, 056A:0303) is a newer revision of the Bamboo series. This patch adds product 0303 to wacom.ko.
Date: Sat,  2 Nov 2013 12:04:49 -0700
Message-Id: <1383419089-31248-1-git-send-email-matthew@incomplete.io>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Geddes <matthew@incomplete.io>

Signed-off-by: Matthew Geddes <matthew@incomplete.io>
---
 drivers/input/tablet/wacom_wac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index c59b797..5015269 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -2128,6 +2128,9 @@ static const struct wacom_features wacom_features_0x300 =
 static const struct wacom_features wacom_features_0x301 =
 	{ "Wacom Bamboo One M",    WACOM_PKGLEN_BBPEN,    21648, 13530, 1023,
 	  31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
+static const struct wacom_features wacom_features_0x303 =
+	{ "Wacom Creative Touch & Pen M", WACOM_PKGLEN_BBPEN, 21648, 13530,
+	  1023, 31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
 static const struct wacom_features wacom_features_0x6004 =
 	{ "ISD-V4",               WACOM_PKGLEN_GRAPHIRE,  12800,  8000,  255,
 	  0, TABLETPC, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
@@ -2258,6 +2261,7 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x10F) },
 	{ USB_DEVICE_WACOM(0x300) },
 	{ USB_DEVICE_WACOM(0x301) },
+	{ USB_DEVICE_WACOM(0x303) },
 	{ USB_DEVICE_WACOM(0x304) },
 	{ USB_DEVICE_WACOM(0x4001) },
 	{ USB_DEVICE_WACOM(0x47) },
-- 
1.8.3.2

