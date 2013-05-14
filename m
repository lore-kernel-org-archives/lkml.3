Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab3ENXtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 19:49:04 -0400
Received: from gmmr7.centrum.cz ([46.255.225.249]:38978 "EHLO gmmr7.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567Ab3ENXtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 19:49:02 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 May 2013 19:49:02 EDT
X-Original-From: sustmidown@centrum.cz
X-Original-IP: 88.101.84.63
From: =?UTF-8?q?Miroslav=20=C5=A0ustek?= <sustmidown@centrum.cz>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miroslav=20=C5=A0ustek?= <sustmidown@centrum.cz>
Subject: [PATCH] [media] rtl28xxu: Add USB ID for Leadtek WinFast DTV Dongle mini
Date: Wed, 15 May 2013 01:42:11 +0200
Message-Id: <1368574931-12146-1-git-send-email-sustmidown@centrum.cz>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB ID 0413:6a03 is Leadtek WinFast DTV Dongle mini.
Decoder Realtek RTL2832U and tuner Infineon TUA9001.

Signed-off-by: Miroslav Šustek <sustmidown@centrum.cz>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 22015fe..d220ccc 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1408,6 +1408,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
 		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a03,
+		&rtl2832u_props, "WinFast DTV Dongle mini", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.8.1.4

