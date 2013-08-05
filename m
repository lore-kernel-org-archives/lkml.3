Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3HEQ3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:29:39 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63091 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3HEQ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:29:23 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Anton Vorontsov <anton@enomsg.org>, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] MAINTAINERS: drivers/power: add entry for SmartReflex AVS drivers
Date: Mon,  5 Aug 2013 09:29:19 -0700
Message-Id: <1375720159-13684-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SmartReflex AVS driver evolved out of the OMAP kernel and now
lives under drivers/power/avs.

I've historically been maintainer of this but Nishanth Menon is doing
most of the heavy lifting now.  Add us both as co-maintainers.

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index defc053..466ca61 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6450,6 +6450,14 @@ S:	Maintained
 F:	include/linux/power_supply.h
 F:	drivers/power/
 
+SMARTREFLEX DRIVERS FOR ADAPTIVE VOLTAGE SCALING (AVS)
+M:	Kevin Hilman <khilman@kernel.org>
+M:	Nishanth Menon <nm@ti.com>
+S:	Maintained
+F:	drivers/power/avs/smartreflex.c
+F:      include/linux/power/smartreflex.h
+L:	linux-pm@vger.kernel.org
+
 PNP SUPPORT
 M:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 M:	Bjorn Helgaas <bhelgaas@google.com>
-- 
1.8.3

