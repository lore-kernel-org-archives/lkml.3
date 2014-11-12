Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaKLBaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:30:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbaKLBaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:30:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Williams <dcbw@redhat.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.17 206/319] USB: option: add Haier CE81B CDMA modem
Date: Wed, 12 Nov 2014 10:15:44 +0900
Message-Id: <20141112011026.950177112@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 012eee1522318b5ccd64d277d50ac32f7e9974fe upstream.

Port layout:

0: QCDM/DIAG
1: NMEA
2: AT
3: AT/PPP

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -362,6 +362,7 @@ static void option_instat_callback(struc
 
 /* Haier products */
 #define HAIER_VENDOR_ID				0x201e
+#define HAIER_PRODUCT_CE81B			0x10f8
 #define HAIER_PRODUCT_CE100			0x2009
 
 /* Cinterion (formerly Siemens) products */
@@ -1620,6 +1621,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HAIER_VENDOR_ID, HAIER_PRODUCT_CE81B, 0xff, 0xff, 0xff) },
 	/* Pirelli  */
 	{ USB_DEVICE_INTERFACE_CLASS(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_1, 0xff) },
 	{ USB_DEVICE_INTERFACE_CLASS(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_2, 0xff) },


