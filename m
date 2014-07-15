Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030242AbaGOXZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:25:00 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54375 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030213AbaGOXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:24:52 -0400
Subject: [PATCH] power/reset: Fix GPL v2 license string typo
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Date: Tue, 15 Jul 2014 17:24:50 -0600
Message-ID: <20140715232450.24076.25543.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per license_is_gpl_compatible(), the MODULE_LICENSE() string for GPL v2 is
"GPL v2", not "GPLv2".  Use "GPL v2" so this module doesn't taint the
kernel.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/power/reset/restart-poweroff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/reset/restart-poweroff.c b/drivers/power/reset/restart-poweroff.c
index 5758033e0c16..3e51f8d29bfe 100644
--- a/drivers/power/reset/restart-poweroff.c
+++ b/drivers/power/reset/restart-poweroff.c
@@ -62,5 +62,5 @@ module_platform_driver(restart_poweroff_driver);
 
 MODULE_AUTHOR("Andrew Lunn <andrew@lunn.ch");
 MODULE_DESCRIPTION("restart poweroff driver");
-MODULE_LICENSE("GPLv2");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:poweroff-restart");

