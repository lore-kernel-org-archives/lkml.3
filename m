Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaKLCkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:40:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965374AbaKLBpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:45:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adel Gadllah <adel.gadllah@gmail.com>
Subject: [PATCH 3.14 152/203] USB: quirks: enable device-qualifier quirk for another Elan touchscreen
Date: Wed, 12 Nov 2014 10:17:02 +0900
Message-Id: <20141112011549.673928219@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adel Gadllah <adel.gadllah@gmail.com>

commit 876af5d454548be40327ba9efea4bc92a8575019 upstream.

Currently this quirk is enabled for the model with the device id 0x0089, it
is needed for the 0x009b model, which is found on the Fujitsu Lifebook u904
as well.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -97,6 +97,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x04f3, 0x0089), .driver_info =
 			USB_QUIRK_DEVICE_QUALIFIER },
 
+	{ USB_DEVICE(0x04f3, 0x009b), .driver_info =
+			USB_QUIRK_DEVICE_QUALIFIER },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 


