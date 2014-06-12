Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaFLXRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:17:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaFLXRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:17:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alessandro Miceli <angelofsky1980@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.15 10/12] [media] rtl28xxu: add [1b80:d3af] Sveon STV27
Date: Thu, 12 Jun 2014 16:21:12 -0700
Message-Id: <20140612232045.263265322@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232044.886466924@linuxfoundation.org>
References: <20140612232044.886466924@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Miceli <angelofsky1980@gmail.com>

commit 74a86272f05c3dae40f2d7b17ff09a0608cf3304 upstream.

Added support for Sveon STV27 device (rtl2832u + FC0013 tuner)

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-core/dvb-usb-ids.h    |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -376,4 +376,5 @@
 #define USB_PID_CTVDIGDUAL_V2				0xe410
 #define USB_PID_PCTV_2002E                              0x025c
 #define USB_PID_PCTV_2002E_SE                           0x025d
+#define USB_PID_SVEON_STV27                             0xd3af
 #endif
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1541,6 +1541,8 @@ static const struct usb_device_id rtl28x
 		&rtl2832u_props, "Peak DVB-T USB", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
 		&rtl2832u_props, "Sveon STV20", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV27,
+		&rtl2832u_props, "Sveon STV27", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,


