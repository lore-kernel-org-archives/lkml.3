Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3LDX3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:29:38 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60689 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab3LDX3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:29:34 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-mtd@lists.infradead.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] MAINTAINERS: mtd: add PXA3xx NAND driver to MAINTAINERS
Date: Wed,  4 Dec 2013 15:28:46 -0800
Message-Id: <1386199726-28074-3-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1386199726-28074-1-git-send-email-computersforpeace@gmail.com>
References: <1386199726-28074-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Add the pxa3xx-nand driver which supports PXA3xx and Armada 370/XP SoC
family to MAINTAINERS to ensure I get proper Cc on patches.

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
v1 -> v2: (Brian) placed into semi-alphabetical order; MMP SUPPORT is
                  out-of-place...

 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a7f53bee1cf..99870552637a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6825,6 +6825,12 @@ F:	include/sound/pxa2xx-lib.h
 F:	sound/arm/pxa*
 F:	sound/soc/pxa/
 
+PXA3xx NAND FLASH DRIVER
+M:	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
+L:	linux-mtd@lists.infradead.org
+S:	Maintained
+F:	drivers/mtd/nand/pxa3xx-nand.c
+
 MMP SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Haojian Zhuang <haojian.zhuang@gmail.com>
-- 
1.8.5

