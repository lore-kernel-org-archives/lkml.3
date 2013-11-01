Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3KAVoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:44:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab3KAVoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:44:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Diego=20Elio=20Petten=C3=B2?= <flameeyes@flameeyes.eu>
Subject: [ 30/32] USB: serial: ti_usb_3410_5052: add Abbott strip port ID to combined table as well.
Date: Fri,  1 Nov 2013 14:43:41 -0700
Message-Id: <20131101214320.962389925@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101214313.735463599@linuxfoundation.org>
References: <20131101214313.735463599@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Elio Pettenò <flameeyes@flameeyes.eu>

commit c9d09dc7ad106492c17c587b6eeb99fe3f43e522 upstream.

Without this change, the USB cable for Freestyle Option and compatible
glucometers will not be detected by the driver.

Signed-off-by: Diego Elio Pettenò <flameeyes@flameeyes.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ti_usb_3410_5052.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -210,6 +210,7 @@ static struct usb_device_id ti_id_table_
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 	{ }
 };


