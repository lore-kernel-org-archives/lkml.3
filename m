Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaFLX3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:29:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaFLXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Vcelak <jv@fcelda.cz>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 14/19] [media] rtl28xxu: add chipset version comments into device list
Date: Thu, 12 Jun 2014 16:21:51 -0700
Message-Id: <20140612232139.160261928@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232138.561318739@linuxfoundation.org>
References: <20140612232138.561318739@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Vcelak <jv@fcelda.cz>

commit 60aa4c6fa5723af72cff154a5cd33ac4995d1e0a upstream.

Signed-off-by: Jan Vcelak <jv@fcelda.cz>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1382,6 +1382,7 @@ static const struct dvb_usb_device_prope
 };
 
 static const struct usb_device_id rtl28xxu_id_table[] = {
+	/* RTL2831U devices: */
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, USB_PID_REALTEK_RTL2831U,
 		&rtl2831u_props, "Realtek RTL2831U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT,
@@ -1389,6 +1390,7 @@ static const struct usb_device_id rtl28x
 	{ DVB_USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2,
 		&rtl2831u_props, "Freecom USB2.0 DVB-T", NULL) },
 
+	/* RTL2832U devices: */
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2832,
 		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
@@ -1434,6 +1436,7 @@ static const struct usb_device_id rtl28x
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 
+	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
 	{ }


