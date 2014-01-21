Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbaAUVep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:34:45 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50757 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbaAUVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:26 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: [PATCH 38/73] blackfin: delete non-required instances of <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:41 -0500
Message-ID: <1390339396-3479-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/blackfin/mach-common/cache-c.c     | 1 -
 arch/blackfin/mach-common/clocks-init.c | 1 -
 arch/blackfin/mach-common/scb-init.c    | 1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/blackfin/mach-common/cache-c.c b/arch/blackfin/mach-common/cache-c.c
index 0e1e451..1a5a288 100644
--- a/arch/blackfin/mach-common/cache-c.c
+++ b/arch/blackfin/mach-common/cache-c.c
@@ -6,7 +6,6 @@
  * Licensed under the GPL-2 or later.
  */
 
-#include <linux/init.h>
 #include <asm/blackfin.h>
 #include <asm/cplbinit.h>
 
diff --git a/arch/blackfin/mach-common/clocks-init.c b/arch/blackfin/mach-common/clocks-init.c
index 2308ce5..d436bd9 100644
--- a/arch/blackfin/mach-common/clocks-init.c
+++ b/arch/blackfin/mach-common/clocks-init.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/linkage.h>
-#include <linux/init.h>
 #include <asm/blackfin.h>
 
 #include <asm/dma.h>
diff --git a/arch/blackfin/mach-common/scb-init.c b/arch/blackfin/mach-common/scb-init.c
index 2cbfb0b..8923398 100644
--- a/arch/blackfin/mach-common/scb-init.c
+++ b/arch/blackfin/mach-common/scb-init.c
@@ -6,7 +6,6 @@
  * Licensed under the GPL-2 or later.
  */
 
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <asm/scb.h>
-- 
1.8.4.1

