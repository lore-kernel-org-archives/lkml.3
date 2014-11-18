Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaKROmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:42:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbaKROKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 147/206] USB: cdc-acm: add device id for GW Instek AFG-2225
Date: Tue, 18 Nov 2014 15:08:22 +0100
Message-Id: <4a776e6ac881c8bcbe48ba4e5b26c78384bd7ee6.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cf84a691a61606a2e7269907d3727e2d9fa148ee upstream.

Add device-id entry for GW Instek AFG-2225, which has a byte swapped
bInterfaceSubClass (0x20).

Reported-by: Karl Palsson <karlp@tweak.net.au>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 669836ae53e0..742acebd0ed5 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1580,6 +1580,7 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x2184, 0x001c) },	/* GW Instek AFG-2225 */
 	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
 	},
 	/* Motorola H24 HSPA module: */
-- 
2.1.3

