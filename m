Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaFWIvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:51:05 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55551 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Till=20D=C3=B6rges?= <till@doerges.net>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 068/111] rtl28xxu: add ID [0ccd:00b4] TerraTec NOXON DAB Stick (rev 3)
Date: Mon, 23 Jun 2014 10:31:43 +0200
Message-Id: <8ff3e820444d1452991c623cdde32b4fa0d1d3c1.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Till Dörges <till@doerges.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a24bc323eb07e2a3a751e23c172b68d1b239db67 upstream.

I've got the following DAB USB stick that also works fine with the
DVB_USB_RTL28XXU driver after I added its USB ID:
	Bus 001 Device 009: ID 0ccd:00b4 TerraTec Electronic GmbH

[crope@iki.fi: apply patch partly manually]
Signed-off-by: Till Dörges <till@doerges.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 76e2e4c48e47..d861148516db 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -257,6 +257,7 @@
 #define USB_PID_TERRATEC_T5				0x10a1
 #define USB_PID_NOXON_DAB_STICK				0x00b3
 #define USB_PID_NOXON_DAB_STICK_REV2			0x00e0
+#define USB_PID_NOXON_DAB_STICK_REV3			0x00b4
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 9636d11e485a..bb8122c17721 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1362,6 +1362,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "TerraTec NOXON DAB Stick", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV2,
 		&rtl2832u_props, "TerraTec NOXON DAB Stick (rev 2)", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK_REV3,
+		&rtl2832u_props, "TerraTec NOXON DAB Stick (rev 3)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_TREKSTOR_TERRES_2_0,
 		&rtl2832u_props, "Trekstor DVB-T Stick Terres 2.0", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1101,
-- 
2.0.0

