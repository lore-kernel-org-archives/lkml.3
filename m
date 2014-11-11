Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaKKMLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:11:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaKKLJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 008/170] wireless: rt2x00: add new rt2800usb devices
Date: Tue, 11 Nov 2014 11:06:07 +0000
Message-Id: <1415704129-12709-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

commit 6a06e554daef86c4e8d290284927b081fedb249e upstream.

0x0b05 0x17e8 RT5372 USB 2.0  bgn 2x2 ASUS USB-N14
0x0411 0x0253 RT5572 USB 2.0 abgn 2x2 BUFFALO WLP-U2-300D
0x0df6 0x0078 RT???? Sitecom N300

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 832006b5aab1..573897b8e878 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1284,6 +1284,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Arcadyan */
 	{ USB_DEVICE(0x043e, 0x7a12) },
 	{ USB_DEVICE(0x043e, 0x7a32) },
+	/* ASUS */
+	{ USB_DEVICE(0x0b05, 0x17e8) },
 	/* Azurewave */
 	{ USB_DEVICE(0x13d3, 0x3329) },
 	{ USB_DEVICE(0x13d3, 0x3365) },
@@ -1320,6 +1322,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x057c, 0x8501) },
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x0241) },
+	{ USB_DEVICE(0x0411, 0x0253) },
 	/* D-Link */
 	{ USB_DEVICE(0x2001, 0x3c1a) },
 	{ USB_DEVICE(0x2001, 0x3c21) },
@@ -1410,6 +1413,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x0053) },
 	{ USB_DEVICE(0x0df6, 0x0069) },
 	{ USB_DEVICE(0x0df6, 0x006f) },
+	{ USB_DEVICE(0x0df6, 0x0078) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0xa512) },
 	{ USB_DEVICE(0x083a, 0xc522) },
-- 
2.1.0

