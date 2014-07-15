Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbaGOVhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:37:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933878AbaGOVhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alessandro Miceli <angelofsky1980@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 032/198] [media] rtl28xxu: add [1b80:d3af] Sveon STV27
Date: Tue, 15 Jul 2014 14:28:22 -0700
Message-Id: <1405459868-15089-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Miceli <angelofsky1980@gmail.com>

commit 74a86272f05c3dae40f2d7b17ff09a0608cf3304 upstream.

Added support for Sveon STV27 device (rtl2832u + FC0013 tuner)

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 4cfb962..8bdfad4 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -373,4 +373,5 @@
 #define USB_PID_CTVDIGDUAL_V2				0xe410
 #define USB_PID_PCTV_2002E                              0x025c
 #define USB_PID_PCTV_2002E_SE                           0x025d
+#define USB_PID_SVEON_STV27                             0xd3af
 #endif
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 42e91ea..4043165 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1433,6 +1433,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Peak DVB-T USB", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
 		&rtl2832u_props, "Sveon STV20", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV27,
+		&rtl2832u_props, "Sveon STV27", NULL) },
 
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
-- 
1.9.1

