Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaFWIra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:47:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55539 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Vcelak <jv@fcelda.cz>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 069/111] rtl28xxu: add USB ID for Genius TVGo DVB-T03
Date: Mon, 23 Jun 2014 10:31:44 +0200
Message-Id: <a049936ef3a7a18d0721da7c27835e8bd5577c10.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Vcelak <jv@fcelda.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ac298ccdde4fe9b0a966e548a232ff4e8a6b8a31 upstream.

0458:707f KYE Systems Corp. (Mouse Systems) TVGo DVB-T03 [RTL2832]

The USB dongle uses RTL2832U demodulator and FC0012 tuner.

Signed-off-by: Jan Vcelak <jv@fcelda.cz>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index bb8122c17721..62cb601eed3f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1392,6 +1392,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
+		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
-- 
2.0.0

