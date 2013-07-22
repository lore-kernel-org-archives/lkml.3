Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3GVARu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:17:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43228 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754199Ab3GVARs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:17:48 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Barry Song <21cnbao@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] MAINTAINERS: Update sirf patterns
Date: Sun, 21 Jul 2013 17:15:40 -0700
Message-Id: <62bf3fa5c57dd9155443dedb9116c18e2ac0689e.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3370dc916c ("pinctrl:sirf:re-arch and add support for
new SiRFatlas6 SoC") moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Barry Song <21cnbao@gmail.com>
cc: Linus Walleij <linus.walleij@linaro.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7622b04..6b24f82 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -813,7 +813,7 @@ F:	arch/arm/mach-prima2/
 F:	drivers/dma/sirf-dma.c
 F:	drivers/i2c/busses/i2c-sirf.c
 F:	drivers/mmc/host/sdhci-sirf.c
-F:	drivers/pinctrl/pinctrl-sirf.c
+F:	drivers/pinctrl/sirf/
 F:	drivers/spi/spi-sirf.c
 
 ARM/EBSA110 MACHINE SUPPORT
-- 
1.8.1.2.459.gbcd45b4.dirty

