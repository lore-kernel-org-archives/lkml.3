Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaAOWkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:40:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40714 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaAOVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 012/166] [media] af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual
Date: Wed, 15 Jan 2014 13:50:26 -0800
Message-Id: <1389822780-4729-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 0c413d10515feae02cee967b31bb8afea8aa0d29 upstream.

It is IT9135 dual design.
Thanks to Michael Piko for reporting that!

Reported-by: Michael Piko <michael@piko.com.au>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index cbe1373..3b41d7c 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1175,6 +1175,8 @@ static const struct usb_device_id af9035_id_table[] = {
 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a05,
+		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
1.8.3.2

