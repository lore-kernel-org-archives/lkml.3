Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbaKPAVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 19:21:21 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:43015 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaKPATv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 19:19:51 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 20/22] MAINTAINERS: Add entry for bcm63xx/bcm33xx UDC gadget driver
Date: Sat, 15 Nov 2014 16:17:44 -0800
Message-Id: <1416097066-20452-21-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This hardware shows up on the newly-supported BCM3384 cable chip, as well
as several old BCM63xx DSL chips.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e5e8a55..6ab20b4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2094,6 +2094,12 @@ S:	Maintained
 F:	arch/arm/mach-bcm/bcm63xx.c
 F:	arch/arm/include/debug/bcm63xx.S
 
+BROADCOM BCM63XX/BCM33XX UDC DRIVER
+M:	Kevin Cernekee <cernekee@gmail.com>
+L:	linux-usb@vger.kernel.org
+S:	Maintained
+F:	drivers/usb/gadget/udc/bcm63xx_udc.*
+
 BROADCOM BCM7XXX ARM ARCHITECTURE
 M:	Marc Carino <marc.ceeeee@gmail.com>
 M:	Brian Norris <computersforpeace@gmail.com>
-- 
2.1.1

