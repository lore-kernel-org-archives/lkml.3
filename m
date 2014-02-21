Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbaBUMtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaBUMta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 014/121] [media] af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2
Date: Fri, 21 Feb 2014 12:47:18 +0000
Message-Id: <1392986945-9693-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit f2e4c5e004691dfe37d0e4b363296f28abdb9bc7 upstream.

Add USB ID [2040:f900] for Hauppauge WinTV-MiniStick 2.
Device is build upon IT9135 chipset.

Tested-by: Stefan Becker <schtefan@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 8f9b2cea..8ede8ea 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1539,6 +1539,8 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a05,
 		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_HAUPPAUGE, 0xf900,
+		&af9035_props, "Hauppauge WinTV-MiniStick 2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
1.9.0

