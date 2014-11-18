Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbaKROeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:34:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbaKROKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adel Gadllah <adel.gadllah@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 161/206] USB: quirks: enable device-qualifier quirk for another Elan touchscreen
Date: Tue, 18 Nov 2014 15:08:36 +0100
Message-Id: <21748d8c32e22ed04b5fc2ad48a1029b81216ef9.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adel Gadllah <adel.gadllah@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 876af5d454548be40327ba9efea4bc92a8575019 upstream.

Currently this quirk is enabled for the model with the device id 0x0089, it
is needed for the 0x009b model, which is found on the Fujitsu Lifebook u904
as well.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 83355b3de7b4..7898fa55cfe5 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -96,6 +96,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04f3, 0x0089), .driver_info =
 			USB_QUIRK_DEVICE_QUALIFIER },
 
+	{ USB_DEVICE(0x04f3, 0x009b), .driver_info =
+			USB_QUIRK_DEVICE_QUALIFIER },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
2.1.3

