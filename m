Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030533AbaGCJY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030468AbaGCJYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Till=20D=C3=B6rges?= <till@doerges.net>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 164/198] [media] rtl28xxu: add ID [0ccd:00b4] TerraTec NOXON DAB Stick (rev 3)
Date: Thu,  3 Jul 2014 10:20:07 +0100
Message-Id: <1404379241-8590-165-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Till=20D=C3=B6rges?= <till@doerges.net>

commit a24bc323eb07e2a3a751e23c172b68d1b239db67 upstream.

I've got the following DAB USB stick that also works fine with the
DVB_USB_RTL28XXU driver after I added its USB ID:
	Bus 001 Device 009: ID 0ccd:00b4 TerraTec Electronic GmbH

[crope@iki.fi: apply patch partly manually]
Signed-off-by: Till Dörges <till@doerges.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 17a17ea0f36c..d58fad38a13b 100644
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
index 4b8271dbe40c..1bcc77bf3989 100644
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
1.9.1

