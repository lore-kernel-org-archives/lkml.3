Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaAOWmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:42:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40677 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaAOVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 010/166] [media] af9035: add ID [0ccd:00aa] TerraTec Cinergy T Stick (rev. 2)
Date: Wed, 15 Jan 2014 13:50:24 -0800
Message-Id: <1389822780-4729-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>

commit d9b7595bed61930987308be946563ce084148c14 upstream.

This patch adds USB ID for alternative "Terratec Cinergy T Stick".
Tested by a friend: works similarly to 0ccd:0093 version (af9035+tua9001)

Signed-off-by: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>
Acked-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 61ae7f9..c3cd6be 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1133,6 +1133,8 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "AVerMedia Twinstar (A825)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_ASUS, USB_PID_ASUS_U3100MINI_PLUS,
 		&af9035_props, "Asus U3100Mini Plus", NULL) },
+        { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
+		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
1.8.3.2

