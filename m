Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3GVARN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:17:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60815 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753502Ab3GVARL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:17:11 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] MAINTAINERS: gpio: vt8500: Remove file pattern
Date: Sun, 21 Jul 2013 17:15:36 -0700
Message-Id: <557b4d322a0f5cd1c148a8cc2e2c3a034212582f.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit dc1010860b ("gpio: vt8500: Remove arch-vt8500 gpio driver")
removed the file, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Tony Prisk <linux@prisktech.co.nz>
cc: Linus Walleij <linus.walleij@linaro.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c224cf..b206920 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1292,7 +1292,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-vt8500/
 F:	drivers/clocksource/vt8500_timer.c
-F:	drivers/gpio/gpio-vt8500.c
 F:	drivers/i2c/busses/i2c-wmt.c
 F:	drivers/mmc/host/wmt-sdmmc.c
 F:	drivers/pwm/pwm-vt8500.c
-- 
1.8.1.2.459.gbcd45b4.dirty

