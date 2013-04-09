Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762951Ab3DII5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:57:47 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56975 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3DII5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:57:44 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] mfd: ab8500-core: Add of_compatilbe property for ab8500-usb
Date: Tue,  9 Apr 2013 10:57:21 +0200
Message-Id: <1365497841-4640-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_comptabile string to the ab8500-usb cell to allow the driver to
grab properties from device-tree when available.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Hi Samuel,

this oneline allows the driver to grab regulators and other attributes
from device tree.

This is actually generated on top of -next, so it should apply cleanly on
your current mfd-next tree.  If it doesn't, I'll rebase on your updated
tree when available.

Thanks,
Fabio

 drivers/mfd/ab8500-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index f276352..4be1d0c 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1107,6 +1107,7 @@ static struct mfd_cell ab8500_devs[] = {
 	},
 	{
 		.name = "ab8500-usb",
+		.of_compatible = "stericsson,ab8500-usb",
 		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
 		.resources = ab8500_usb_resources,
 	},
-- 
1.8.1.3

