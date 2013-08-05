Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3HEQ3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:29:44 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63760 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab3HEQ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:29:41 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Anton Vorontsov <anton@enomsg.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] MAINTAINERS: drivers/power: add entry for SmartReflex AVS drivers
Date: Mon,  5 Aug 2013 09:29:37 -0700
Message-Id: <1375720177-20063-1-git-send-email-khilman@linaro.org>
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

