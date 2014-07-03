Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbaGCKTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:19:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656AbaGCJVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 019/198] [media] rtl28xxu: add 15f4:0131 Astrometa DVB-T2
Date: Thu,  3 Jul 2014 10:17:42 +0100
Message-Id: <1404379241-8590-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 8fdd33b1bcf32ed9cf21aa9e4a66fa68c6beaa1b upstream.

Components are RTL2832P + R828D + MN88472.
Currently support only DVB-T as there is no driver for MN88472 demod.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c0cd0848631b..b51991756b71 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1388,6 +1388,9 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
+
+	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
+		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.9.1

