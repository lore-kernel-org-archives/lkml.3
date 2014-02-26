Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaBZSeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:34:16 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:59346 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaBZSeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:34:15 -0500
From: Jan Vcelak <jv@fcelda.cz>
To: crope@iki.fi, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03
Date: Wed, 26 Feb 2014 19:33:39 +0100
Message-Id: <1393439620-7993-1-git-send-email-jv@fcelda.cz>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <530DB488.9030901@iki.fi>
References: <530DB488.9030901@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0458:707f KYE Systems Corp. (Mouse Systems) TVGo DVB-T03 [RTL2832]

The USB dongle uses RTL2832U demodulator and FC0012 tuner.

Signed-off-by: Jan Vcelak <jv@fcelda.cz>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index fda5c64..b9eb662 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1429,6 +1429,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
+		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
-- 
1.8.5.3

