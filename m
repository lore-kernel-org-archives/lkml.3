Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab3JOOFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:05:08 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:34537 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332Ab3JOOFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:05:03 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Archana kumari <archanakumari959@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] staging: media: Fix build for iMON LIRC driver
Date: Tue, 15 Oct 2013 16:02:43 +0200
Message-Id: <1381845763-10487-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381845763-10487-1-git-send-email-treding@nvidia.com>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing , between parameters in a call to dev_info().

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/staging/media/lirc/lirc_imon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 8180187..91c3e2d 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -925,7 +925,7 @@ static int imon_probe(struct usb_interface *interface,
 		if (usb_register_dev(interface, &imon_class)) {
 			/* Not a fatal error, so ignore */
 			dev_info(dev,
-			       "%s: could not get a minor number for display\n"
+			       "%s: could not get a minor number for display\n",
 						__func__);
 		}
 	}
-- 
1.8.4

