Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaIOR7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:59:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54171 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbaIOR7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:59:33 -0400
From: Nishanth Menon <nm@ti.com>
To: Jim Davis <jim.epost@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Input: palmas-pwrbutton: Fix typo in License
Date: Mon, 15 Sep 2014 12:58:57 -0500
Message-ID: <1410803937-27022-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the license string convention indicated in include/linux/module.h
(don't capitalize v).

This fixes following randconfig warning:
FATAL: modpost: GPL-incompatible module palmas-pwrbutton.ko uses GPL-only symbol 'platform_driver_unregister'

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Reported thread http://marc.info/?l=linux-input&m=141080223209150&w=2

 drivers/input/misc/palmas-pwrbutton.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/palmas-pwrbutton.c b/drivers/input/misc/palmas-pwrbutton.c
index 3f90211..4ed6f78 100644
--- a/drivers/input/misc/palmas-pwrbutton.c
+++ b/drivers/input/misc/palmas-pwrbutton.c
@@ -326,5 +326,5 @@ module_platform_driver(palmas_pwron_driver);
 
 MODULE_ALIAS("platform:palmas-pwrbutton");
 MODULE_DESCRIPTION("Palmas Power Button");
-MODULE_LICENSE("GPL V2");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Texas Instruments Inc.");
-- 
1.7.9.5

