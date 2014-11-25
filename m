Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaKYMCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:02:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaKYKka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adel Gadllah <adel.gadllah@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 024/254] USB: quirks: enable device-qualifier quirk for yet another Elan touchscreen
Date: Tue, 25 Nov 2014 10:36:14 +0000
Message-Id: <1416912004-5928-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adel Gadllah <adel.gadllah@gmail.com>

commit d749947561af5996ccc076b2ffcc5f48b1be5d74 upstream.

Yet another device affected by this.

Tested-by: Kevin Fenzi <kevin@scrye.com>
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 16b8e285ce75..c85459338991 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -100,6 +100,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04f3, 0x009b), .driver_info =
 			USB_QUIRK_DEVICE_QUALIFIER },
 
+	{ USB_DEVICE(0x04f3, 0x016f), .driver_info =
+			USB_QUIRK_DEVICE_QUALIFIER },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
2.1.0

