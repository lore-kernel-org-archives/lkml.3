Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3GVAQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:16:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40340 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753054Ab3GVAP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:15:59 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] MAINTAINERS: EXYNOS - Remove board files
Date: Sun, 21 Jul 2013 17:15:28 -0700
Message-Id: <03c7d481b618386f577c64787f283c69956dd423.1374451988.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ommit ca9143501c30 ("ARM: EXYNOS: Remove unused board files")
removed the files, remove the patterns too.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Tomasz Figa <t.figa@samsung.com>
cc: Kyungmin Park <kyungmin.park@samsung.com>
cc: Kukjin Kim <kgene.kim@samsung.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..2124104 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1154,8 +1154,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-s5pv210/mach-aquila.c
 F:	arch/arm/mach-s5pv210/mach-goni.c
-F:	arch/arm/mach-exynos/mach-universal_c210.c
-F:	arch/arm/mach-exynos/mach-nuri.c
 
 ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

