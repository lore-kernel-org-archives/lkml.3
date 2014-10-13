Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaJMC1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:27:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaJMC1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:27:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Bomholtz <andreas@seluxit.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.14 34/37] USB: cp210x: add support for Seluxit USB dongle
Date: Mon, 13 Oct 2014 04:24:31 +0200
Message-Id: <20141013022401.701409644@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Bomholtz <andreas@seluxit.com>

commit dee80ad12d2b1b304286a707fde7ab05d1fc7bab upstream.

Added the Seluxit ApS USB Serial Dongle to cp210x driver.

Signed-off-by: Andreas Bomholtz <andreas@seluxit.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -156,6 +156,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
+	{ USB_DEVICE(0x1D6F, 0x0010) }, /* Seluxit ApS RF Dongle */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
 	{ USB_DEVICE(0x1FB9, 0x0100) }, /* Lake Shore Model 121 Current Source */


