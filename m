Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab3AOWfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:35:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:43387 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604Ab3AOWfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andreas Fleig <andreasfleig@gmail.com>
Subject: [ 171/221] USB: Add device quirk for Microsoft VX700 webcam
Date: Tue, 15 Jan 2013 10:51:38 -0800
Message-Id: <20130115185010.389815466@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Fleig <andreasfleig@gmail.com>

commit bc009eca8d539162f7271c2daf0ab5e9e3bb90a0 upstream.

Add device quirk for Microsoft Lifecam VX700 v2.0 webcams.
Fixes squeaking noise of the microphone.

Signed-off-by: Andreas Fleig <andreasfleig@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -43,6 +43,9 @@ static const struct usb_device_id usb_qu
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Microsoft LifeCam-VX700 v2.0 */
+	{ USB_DEVICE(0x045e, 0x0770), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Logitech Quickcam Fusion */
 	{ USB_DEVICE(0x046d, 0x08c1), .driver_info = USB_QUIRK_RESET_RESUME },
 


