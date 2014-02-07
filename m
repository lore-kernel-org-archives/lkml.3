Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaBGNIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:08:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41686 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbaBGLtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 062/233] [media] it913x: Add support for Avermedia H335 id 0x0335
Date: Fri,  7 Feb 2014 11:44:41 +0000
Message-Id: <1391773652-25214-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 17f335c304ac19d9b11814238fe8a7519d80e2ff upstream.

Trivial USB ID addition for Avermedia H335.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
 drivers/media/usb/dvb-usb-v2/it913x.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 886da16..54e803a 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -239,6 +239,7 @@
 #define USB_PID_AVERMEDIA_A835B_4835			0x4835
 #define USB_PID_AVERMEDIA_1867				0x1867
 #define USB_PID_AVERMEDIA_A867				0xa867
+#define USB_PID_AVERMEDIA_H335				0x0335
 #define USB_PID_AVERMEDIA_TWINSTAR			0x0825
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index 1cb6899..fe95a58 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -799,6 +799,9 @@ static const struct usb_device_id it913x_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CTVDIGDUAL_V2,
 		&it913x_properties, "Digital Dual TV Receiver CTVDIGDUAL_V2",
 			RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_H335,
+		&it913x_properties, "Avermedia H335",
+			RC_MAP_IT913X_V2) },
 	{}		/* Terminating entry */
 };
 
-- 
1.8.3.2

