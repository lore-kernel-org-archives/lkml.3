Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbaGCKSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:18:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51493 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbaGCJVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alessandro Miceli <angelofsky1980@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 022/198] [media] rtl28xxu: add [1b80:d39d] Sveon STV20
Date: Thu,  3 Jul 2014 10:17:45 +0100
Message-Id: <1404379241-8590-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Miceli <angelofsky1980@gmail.com>

commit f27f5b0ee4967babfb8b03511f5e76b79d781014 upstream.

Added Sveon STV20 device based on Realtek RTL2832U and FC0012 tuner

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 54e803a45e7e..143d90819ec3 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -359,6 +359,7 @@
 #define USB_PID_FRIIO_WHITE				0x0001
 #define USB_PID_TVWAY_PLUS				0x0002
 #define USB_PID_SVEON_STV20				0xe39d
+#define USB_PID_SVEON_STV20_RTL2832U			0xd39d
 #define USB_PID_SVEON_STV22				0xe401
 #define USB_PID_SVEON_STV22_IT9137			0xe411
 #define USB_PID_AZUREWAVE_AZ6027			0x3275
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index be665b845434..fe8d9ec53be3 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1392,6 +1392,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
 		&rtl2832u_props, "Peak DVB-T USB", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
+		&rtl2832u_props, "Sveon STV20", NULL) },
 
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
-- 
1.9.1

