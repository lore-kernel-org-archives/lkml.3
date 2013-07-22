Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3GVAQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:16:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51885 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753730Ab3GVAQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:16:26 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] MAINTAINERS: ARM: S3C2410: Update patterns
Date: Sun, 21 Jul 2013 17:15:31 -0700
Message-Id: <6741112003996cc2bb1f261ae902b6dd15a04405.1374451988.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 85fd6d63bf2 ("ARM: S3C2410: move mach-s3c2410/* into mach-s3c24xx/")
moved the files, update the patterns.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Kukjin Kim <kgene.kim@samsung.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 157e4ee..fbd5a67 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7446,9 +7446,9 @@ P:	Vincent Sanders <vince@simtec.co.uk>
 M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
-F:	arch/arm/mach-s3c2410/mach-bast.c
-F:	arch/arm/mach-s3c2410/bast-ide.c
-F:	arch/arm/mach-s3c2410/bast-irq.c
+F:	arch/arm/mach-s3c24xx/mach-bast.c
+F:	arch/arm/mach-s3c24xx/bast-ide.c
+F:	arch/arm/mach-s3c24xx/bast-irq.c
 
 TI DAVINCI MACHINE SUPPORT
 M:	Sekhar Nori <nsekhar@ti.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

