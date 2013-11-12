Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3KLJwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:52:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:57686 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab3KLJwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:52:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433770352"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] gpio/lynxpoint: add new ACPI ID
Date: Tue, 12 Nov 2013 11:52:32 +0200
Message-Id: <1384249952-10085-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Intel PCHs have the same GPIO controller than Haswell but the ACPI ID
is different. Add this ID to the driver supported IDs list.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpio-lynxpoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 41b5913ddabe..c3d9999bcdb3 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -437,6 +437,7 @@ static const struct dev_pm_ops lp_gpio_pm_ops = {
 
 static const struct acpi_device_id lynxpoint_gpio_acpi_match[] = {
 	{ "INT33C7", 0 },
+	{ "INT3437", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, lynxpoint_gpio_acpi_match);
-- 
1.8.4.2

