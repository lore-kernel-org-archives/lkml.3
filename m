Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3GVAQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:16:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50248 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753660Ab3GVAQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:16:17 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Walmsley <paul@pwsan.com>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] MAINTAINERS: OMAP POWERDOMAIN, update patterns
Date: Sun, 21 Jul 2013 17:15:30 -0700
Message-Id: <8c1406e78f8536ff46ad9000b5634487243d5854.1374451988.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 498153995b9 ("ARM: OMAP2+: powerdomain/PRM: move the
low-level powerdomain") renamed the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Paul Walmsley <paul@pwsan.com>
cc: Rajendra Nayak <rnayak@ti.com>
cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 MAINTAINERS | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 521de95..157e4ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5902,13 +5902,12 @@ S:	Maintained
 F:	arch/arm/*omap*/*pm*
 F:	drivers/cpufreq/omap-cpufreq.c
 
-OMAP POWERDOMAIN/CLOCKDOMAIN SOC ADAPTATION LAYER SUPPORT
+OMAP POWERDOMAIN SOC ADAPTATION LAYER SUPPORT
 M:	Rajendra Nayak <rnayak@ti.com>
 M:	Paul Walmsley <paul@pwsan.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
-F:	arch/arm/mach-omap2/powerdomain2xxx_3xxx.c
-F:	arch/arm/mach-omap2/powerdomain44xx.c
+F:	arch/arm/mach-omap2/prm*
 
 OMAP AUDIO SUPPORT
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

