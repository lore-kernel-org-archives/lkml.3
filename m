Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbaGOVyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:54:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54836 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618AbaGOViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Healy <healybrian@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 030/198] [media] rtl28xxu: add 1b80:d395 Peak DVB-T USB
Date: Tue, 15 Jul 2014 14:28:20 -0700
Message-Id: <1405459868-15089-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Healy <healybrian@gmail.com>

commit 9ca24ae4083665bda38da45f4b5dc9bbaf936bc0 upstream.

Add USB ID for Peak DVB-T USB.

[crope@iki.fi: fix Brian email address and indentation]
Signed-off-by: Brian Healy <healybrian@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 70dd3c8..1bb3030 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1429,6 +1429,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
+		&rtl2832u_props, "Peak DVB-T USB", NULL) },
 
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
-- 
1.9.1

