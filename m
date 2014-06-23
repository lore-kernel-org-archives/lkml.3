Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaFWIz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55495 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Robert Backhaus <robbak@robbak.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 061/111] [media] Add USB IDs for Winfast DTV Dongle Mini-D
Date: Mon, 23 Jun 2014 10:31:36 +0200
Message-Id: <21af26cb47416f782c39b4055eb7de21476838a5.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Backhaus <robbak@robbak.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d22d32e117c19efa1761d871d9dab5e294b7b77d upstream.

GIT_AUTHOR_DATE=1386943312
    Add USB IDs for the WinFast DTV Dongle Mini.
    Device is tested and works fine under MythTV

    Signed-off-by: Robert Backhaus <robbak@robbak.com>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 7e0f61930a12..76e2e4c48e47 100644
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
index b51991756b71..9636d11e485a 100644
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
2.0.0

