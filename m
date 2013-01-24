Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3AXD3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:29:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44212 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3AXD3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Thomas Hartmann <hartmann@ict.tuwien.ac.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 23/74] staging: r8712u: Add new device ID
Date: Thu, 24 Jan 2013 01:26:35 -0200
Message-Id: <1358998046-613-24-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit da849a92d3bafaf24d770e971c2c9e5c3f60b5d1 upstream.

The ISY IWL 1000 USB WLAN stick with USB ID 050d:11f1 is a clone of
the Belkin F7D1101 V1 device.

Reported-by: Thomas Hartmann <hartmann@ict.tuwien.ac.at>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Thomas Hartmann <hartmann@ict.tuwien.ac.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/rtl8712/usb_intf.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 69f616c..1bc8097 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -66,6 +66,8 @@ static struct usb_device_id rtl871x_usb_id_tbl[] = {
 	{USB_DEVICE(0x0B05, 0x1791)}, /* 11n mode disable */
 	/* Belkin */
 	{USB_DEVICE(0x050D, 0x945A)},
+	/* ISY IWL - Belkin clone */
+	{USB_DEVICE(0x050D, 0x11F1)},
 	/* Corega */
 	{USB_DEVICE(0x07AA, 0x0047)},
 	/* D-Link */
-- 
1.7.9.5

