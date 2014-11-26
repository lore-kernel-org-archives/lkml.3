Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaKZMNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:13:17 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39681 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaKZMNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:13:16 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v2] MAINTAINERS: ARM Versatile Express platform
Date: Wed, 26 Nov 2014 12:13:05 +0000
Message-Id: <1417003985-21564-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416939455-1814-2-git-send-email-pawel.moll@arm.com>
References: <1416939455-1814-2-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a separate section for the ARM
Versatile Express platform maintainers, listing
all different bits and bobs used by it.

Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Acked-by: Michael Turquette <mturquette@linaro.org>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ff630d..924454f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1503,6 +1503,18 @@ S:	Maintained
 F:	drivers/clk/ux500/
 F:	include/linux/platform_data/clk-ux500.h
 
+ARM/VERSATILE EXPRESS PLATFORM
+M:	Liviu Dudau <liviu.dudau@arm.com>
+M:	Sudeep Holla <sudeep.holla@arm.com>
+M:	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/boot/dts/vexpress*
+F:	arch/arm/mach-vexpress/
+F:	*/*/vexpress*
+F:	drivers/clk/versatile/clk-vexpress-osc.c
+F:	drivers/clocksource/versatile.c
+
 ARM/VFP SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
2.1.0

