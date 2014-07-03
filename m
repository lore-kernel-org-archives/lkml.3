Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030500AbaGCJYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52475 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030454AbaGCJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 163/198] [media] Add USB IDs for Winfast DTV Dongle Mini-D
Date: Thu,  3 Jul 2014 10:20:06 +0100
Message-Id: <1404379241-8590-164-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Backhaus <robbak@robbak.com>

commit d22d32e117c19efa1761d871d9dab5e294b7b77d upstream.

GIT_AUTHOR_DATE=1386943312
    Add USB IDs for the WinFast DTV Dongle Mini.
    Device is tested and works fine under MythTV

    Signed-off-by: Robert Backhaus <robbak@robbak.com>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 8bdfad471882..17a17ea0f36c 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -318,6 +318,7 @@
 #define USB_PID_WINFAST_DTV_DONGLE_H			0x60f6
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2		0x6f01
 #define USB_PID_WINFAST_DTV_DONGLE_GOLD			0x6029
+#define USB_PID_WINFAST_DTV_DONGLE_MINID		0x6f0f
 #define USB_PID_GENPIX_8PSK_REV_1_COLD			0x0200
 #define USB_PID_GENPIX_8PSK_REV_1_WARM			0x0201
 #define USB_PID_GENPIX_8PSK_REV_2			0x0202
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 22c30ad72cab..4b8271dbe40c 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1368,6 +1368,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Dexatek DK DVB-T Dongle", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6680,
 		&rtl2832u_props, "DigitalNow Quad DVB-T Receiver", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, USB_PID_WINFAST_DTV_DONGLE_MINID,
+		&rtl2832u_props, "Leadtek Winfast DTV Dongle Mini D", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d3,
 		&rtl2832u_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1102,
-- 
1.9.1

