Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbaKUMXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:23:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbaKUMX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:23:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: grant.likely@linaro.org
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <darren.hart@intel.com>
Subject: [PATCH 1/1] of: base, fix of_property_read_string_helper kernel-doc
Date: Fri, 21 Nov 2014 13:23:09 +0100
Message-Id: <1416572589-4953-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It referenced of_property_read_string_util whereas the function name
is of_property_read_string_helper.

Introduced in a87fa1d81a9fb5e9adca9820e16008c40ad09f33 (of: Fix
overflow bug in string property parsing functions). Found out when
reviewing the stable 3.12 queue.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Darren Hart <darren.hart@intel.com>
---
 drivers/of/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 37de43ef22fc..76d8307a1cd5 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1359,7 +1359,7 @@ int of_property_match_string(struct device_node *np, const char *propname,
 EXPORT_SYMBOL_GPL(of_property_match_string);
 
 /**
- * of_property_read_string_util() - Utility helper for parsing string properties
+ * of_property_read_string_helper() - Utility helper for parsing string properties
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
  * @out_strs:	output array of string pointers.
-- 
2.1.3

