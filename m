Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3GVAQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:16:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33701 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753183Ab3GVAQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:16:08 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Walmsley <paul@pwsan.com>, Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] MAINTAINERS: ARM: OMAP2/3: Remove unused clockdomain files
Date: Sun, 21 Jul 2013 17:15:29 -0700
Message-Id: <0de56f7acdc9ed7aced4a78000c0ec7e0f70c011.1374451988.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4bd5259e53a ("ARM: OMAP2/3: clockdomain/PRM/CM: move the
low-level clockdomain functions into PRM/CM") deleted the files,
update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Paul Walmsley <paul@pwsan.com>
cc: Rajendra Nayak <rnayak@ti.com>
cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2124104..521de95 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5909,8 +5909,6 @@ L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mach-omap2/powerdomain2xxx_3xxx.c
 F:	arch/arm/mach-omap2/powerdomain44xx.c
-F:	arch/arm/mach-omap2/clockdomain2xxx_3xxx.c
-F:	arch/arm/mach-omap2/clockdomain44xx.c
 
 OMAP AUDIO SUPPORT
 M:	Peter Ujfalusi <peter.ujfalusi@ti.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

