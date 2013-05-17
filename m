Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3EQVS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:18:59 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:54650 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab3EQVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:18:55 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 4/4] MAINTAINERS: vt8500: Add clk-vt8500.c to MAINTAINERS file
Date: Sat, 18 May 2013 09:18:52 +1200
Message-Id: <1368825532-30917-5-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz>
References: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file has missed being added under ARM/VT8500 ARM ARCHITECTURE,
and is maintained along with the rest of the vt8500 arch code.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..5ab8ccb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1283,6 +1283,7 @@ M:	Tony Prisk <linux@prisktech.co.nz>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-vt8500/
+F:	drivers/clk/vt8500-vt8500.c
 F:	drivers/clocksource/vt8500_timer.c
 F:	drivers/gpio/gpio-vt8500.c
 F:	drivers/mmc/host/wmt-sdmmc.c
-- 
1.7.9.5

