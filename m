Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3BQW7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:59:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45791 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756322Ab3BQWzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:43 -0500
Message-Id: <20130217225004.910967134@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        =?UTF-8?q?Jaume=20Delcl=C3=B2s?= <jaume@delclos.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 28/66] Wireless: rt2x00: Add device id for Sweex LW323 to rt2800usb.c
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaume Delclòs <jaume@delclos.com>

commit 36f318bb124b231c01db6965a009f46d5731f012 upstream.

This patch adds detection for the Sweex LW323 USB wireless network card
in the rt2x00 driver (just one line in rt2800usb.c).
It applies to linux-3.7-rc3.

Signed-off-by: Jaume Delclòs <jaume@delclos.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3b8fb5a..0230812 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1096,6 +1096,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x177f, 0x0153) },
 	{ USB_DEVICE(0x177f, 0x0302) },
 	{ USB_DEVICE(0x177f, 0x0313) },
+	{ USB_DEVICE(0x177f, 0x0323) },
 	/* U-Media */
 	{ USB_DEVICE(0x157e, 0x300e) },
 	{ USB_DEVICE(0x157e, 0x3013) },


