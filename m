Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbaGCKRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:17:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51536 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbaGCJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alessandro Miceli <angelofsky1980@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 024/198] [media] rtl28xxu: add [1b80:d3af] Sveon STV27
Date: Thu,  3 Jul 2014 10:17:47 +0100
Message-Id: <1404379241-8590-25-git-send-email-luis.henriques@canonical.com>
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

commit 74a86272f05c3dae40f2d7b17ff09a0608cf3304 upstream.

Added support for Sveon STV27 device (rtl2832u + FC0013 tuner)

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 4cfb9624d69c..8bdfad471882 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -373,4 +373,5 @@
 #define USB_PID_CTVDIGDUAL_V2				0xe410
 #define USB_PID_PCTV_2002E                              0x025c
 #define USB_PID_PCTV_2002E_SE                           0x025d
+#define USB_PID_SVEON_STV27                             0xd3af
 #endif
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index fe8d9ec53be3..22c30ad72cab 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1394,6 +1394,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Peak DVB-T USB", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
 		&rtl2832u_props, "Sveon STV20", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV27,
+		&rtl2832u_props, "Sveon STV27", NULL) },
 
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
-- 
1.9.1

