Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaFWIzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55519 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brian Healy <healybrian@gmail.com>,
        Antti Palosaari <crope@iki.fi>, Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.12 071/111] rtl28xxu: add 1b80:d395 Peak DVB-T USB
Date: Mon, 23 Jun 2014 10:31:46 +0200
Message-Id: <0b7106f039378ab4f7dfabfc41c92ae124775513.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Healy <healybrian@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9ca24ae4083665bda38da45f4b5dc9bbaf936bc0 upstream.

Add USB ID for Peak DVB-T USB.

[crope@iki.fi: fix Brian email address and indentation]
Signed-off-by: Brian Healy <healybrian@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index ad85db6c87a5..a1dfadd6e788 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1396,6 +1396,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
+		&rtl2832u_props, "Peak DVB-T USB", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
-- 
2.0.0

