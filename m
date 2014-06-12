Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaFLXar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:30:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaFLXR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:17:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Healy <healybrian@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.15 08/12] [media] rtl28xxu: add 1b80:d395 Peak DVB-T USB
Date: Thu, 12 Jun 2014 16:21:10 -0700
Message-Id: <20140612232045.205205827@linuxfoundation.org>
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

From: Brian Healy <healybrian@gmail.com>

commit 9ca24ae4083665bda38da45f4b5dc9bbaf936bc0 upstream.

Add USB ID for Peak DVB-T USB.

[crope@iki.fi: fix Brian email address and indentation]
Signed-off-by: Brian Healy <healybrian@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1537,6 +1537,8 @@ static const struct usb_device_id rtl28x
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
+		&rtl2832u_props, "Peak DVB-T USB", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,


