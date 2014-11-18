Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbaKRO7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:59:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbaKROJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 048/206] wireless: rt2x00: rt2800usb: add new devices
Date: Tue, 18 Nov 2014 15:06:43 +0100
Message-Id: <f8c0eb576c0dc53ecf22087359a7f0d79abeb277.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 274dede8c52036a1849ea970fab8d185fb0dce2b upstream.

0411,0241  RT5572  BUFFALO WI-U2-300D Wireless LAN Adapter
0789,0170  RT3572  Logitec LAN-W300AN/U2
0846,9013  RT3573  NETGEAR Adaptador USB Inalambrico Movistar
0df6,006e  RT3573  Sitecom WiFi USB adapter N900
2001,3c1f  RT3573  D-Link DWA-162 Wireless N900 Dual Band Adapter
2001,3c20  RT5372  D-Link DWA-140 Wireless N USB Adapter(rev.D)
2001,3c21  RT5572  D-Link DWA-160 Xtreme N Dual Band USB Adapter(rev.C)
2001,3c22  RT5372  D-Link DWA-132 Wireless N USB Adapter(rev.B)
2001,3c23  RT5372  D-Link GO-USB-N300 Wireless N Easy USB Adapter
2019,ab29  ?       Planex GW-USMirco300
20f4,724a  RT5572  TRENDnet N600 Wireless Dual Band USB Adapter

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 4feb35aef990..997df03a0c2e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1180,6 +1180,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Linksys */
 	{ USB_DEVICE(0x13b1, 0x002f) },
 	{ USB_DEVICE(0x1737, 0x0079) },
+	/* Logitec */
+	{ USB_DEVICE(0x0789, 0x0170) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3572) },
 	/* Sitecom */
@@ -1203,6 +1205,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x050d, 0x1103) },
 	/* Cameo */
 	{ USB_DEVICE(0x148f, 0xf301) },
+	/* D-Link */
+	{ USB_DEVICE(0x2001, 0x3c1f) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x7733) },
 	/* Hawking */
@@ -1216,6 +1220,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0789, 0x016b) },
 	/* NETGEAR */
 	{ USB_DEVICE(0x0846, 0x9012) },
+	{ USB_DEVICE(0x0846, 0x9013) },
 	{ USB_DEVICE(0x0846, 0x9019) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xed19) },
@@ -1224,6 +1229,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0067) },
 	{ USB_DEVICE(0x0df6, 0x006a) },
+	{ USB_DEVICE(0x0df6, 0x006e) },
 	/* ZyXEL */
 	{ USB_DEVICE(0x0586, 0x3421) },
 #endif
@@ -1240,6 +1246,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x2001, 0x3c1c) },
 	{ USB_DEVICE(0x2001, 0x3c1d) },
 	{ USB_DEVICE(0x2001, 0x3c1e) },
+	{ USB_DEVICE(0x2001, 0x3c20) },
+	{ USB_DEVICE(0x2001, 0x3c22) },
+	{ USB_DEVICE(0x2001, 0x3c23) },
 	/* LG innotek */
 	{ USB_DEVICE(0x043e, 0x7a22) },
 	{ USB_DEVICE(0x043e, 0x7a42) },
@@ -1262,12 +1271,17 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x043e, 0x7a32) },
 	/* AVM GmbH */
 	{ USB_DEVICE(0x057c, 0x8501) },
-	/* D-Link DWA-160-B2 */
+	/* Buffalo */
+	{ USB_DEVICE(0x0411, 0x0241) },
+	/* D-Link */
 	{ USB_DEVICE(0x2001, 0x3c1a) },
+	{ USB_DEVICE(0x2001, 0x3c21) },
 	/* Proware */
 	{ USB_DEVICE(0x043e, 0x7a13) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x5572) },
+	/* TRENDnet */
+	{ USB_DEVICE(0x20f4, 0x724a) },
 #endif
 #ifdef CONFIG_RT2800USB_UNKNOWN
 	/*
@@ -1337,6 +1351,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x1d4d, 0x0010) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xab24) },
+	{ USB_DEVICE(0x2019, 0xab29) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6259) },
 	/* RadioShack */
-- 
2.1.3

