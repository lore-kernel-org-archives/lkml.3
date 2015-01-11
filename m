Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbbAKVXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:23:25 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:44746 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbAKVXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:23:24 -0500
From: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 4/4] Staging: octeon-usb: Fixed a typo
Date: Sun, 11 Jan 2015 15:23:06 -0600
Message-Id: <1421011386-30495-1-git-send-email-silvagustavosilva@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a typo in octeon-hcd.c file

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/octeon-usb/octeon-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index 6b8b108..1daeb31 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -2687,7 +2687,7 @@ static int __cvmx_usb_poll_channel(struct cvmx_usb_state *usb, int channel)
 
 	/*
 	 * Read the channel config info so we can figure out how much data
-	 * transfered
+	 * transferred
 	 */
 	usbc_hcchar.u32 = __cvmx_usb_read_csr32(usb,
 			CVMX_USBCX_HCCHARX(channel, usb->index));
-- 
1.9.1

