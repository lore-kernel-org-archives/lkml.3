Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3CWM6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 08:58:33 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41138 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3CWM6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:58:31 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Soeren Moch <smoch@web.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Stefan Peter <s.peter@mpl.ch>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: kirkwood: add MACH_GURUPLUG_DT to defconfig
Date: Sat, 23 Mar 2013 13:58:22 +0100
Message-Id: <1364043502-17716-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just adds the missing MACH_GURUPLUG_DT to kirkwood_defconfig.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Reported-by: Soeren Moch <smoch@web.de>
---
Cc: Soeren Moch <smoch@web.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Stefan Peter <s.peter@mpl.ch>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/configs/kirkwood_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/kirkwood_defconfig b/arch/arm/configs/kirkwood_defconfig
index 13482ea..5e40f96 100644
--- a/arch/arm/configs/kirkwood_defconfig
+++ b/arch/arm/configs/kirkwood_defconfig
@@ -24,6 +24,7 @@ CONFIG_MACH_IB62X0_DT=y
 CONFIG_MACH_TS219_DT=y
 CONFIG_MACH_DOCKSTAR_DT=y
 CONFIG_MACH_GOFLEXNET_DT=y
+CONFIG_MACH_GURUPLUG_DT=y
 CONFIG_MACH_LSXL_DT=y
 CONFIG_MACH_IOMEGA_IX2_200_DT=y
 CONFIG_MACH_KM_KIRKWOOD_DT=y
-- 
1.7.10.4

