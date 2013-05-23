Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab3EWGBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:01:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48253 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3EWGBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:01:35 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v1 1/9] usb: musb: dsps: enable dual instance support for am33xx platform
Date: Thu, 23 May 2013 11:31:20 +0530
Message-ID: <1369288888-8614-2-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dsps am33xx platform has two instances of musb controller,
enable the support for dual musb instances

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_dsps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 3a18e44..590dd0b 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -746,7 +746,7 @@ static const struct dsps_musb_wrapper ti81xx_driver_data = {
 	.rxep_bitmap		= (0xfffe << 16),
 	.musb_core_offset	= 0x400,
 	.poll_seconds		= 2,
-	.instances		= 1,
+	.instances		= 2,
 };
 
 static const struct platform_device_id musb_dsps_id_table[] = {
-- 
1.7.0.4

