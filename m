Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbaGCKTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:19:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077AbaGCJVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Vcelak <jv@fcelda.cz>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 020/198] [media] rtl28xxu: add USB ID for Genius TVGo DVB-T03
Date: Thu,  3 Jul 2014 10:17:43 +0100
Message-Id: <1404379241-8590-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Vcelak <jv@fcelda.cz>

commit ac298ccdde4fe9b0a966e548a232ff4e8a6b8a31 upstream.

0458:707f KYE Systems Corp. (Mouse Systems) TVGo DVB-T03 [RTL2832]

The USB dongle uses RTL2832U demodulator and FC0012 tuner.

Signed-off-by: Jan Vcelak <jv@fcelda.cz>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index b51991756b71..3e9298bacdeb 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1388,6 +1388,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
+		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
-- 
1.9.1

