Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3CAUCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:02:17 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46220 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751586Ab3CAUCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 15:02:14 -0500
Message-ID: <1362168132.2116.17.camel@joe-AO722>
Subject: [PATCH V2] MAINTAINERS: Update SIMTEC file patterns, remove Vincent
 Sanders
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Ben Dooks <ben-linux@fluff.org>
Date: Fri, 01 Mar 2013 12:02:12 -0800
In-Reply-To: <1362166088.2116.10.camel@joe-AO722>
References: <1362166088.2116.10.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 85fd6d6 ("ARM: S3C2410: move mach-s3c2410/* into mach-s3c24xx/")
moved the files, update the F: patterns.

Remove Vincent Sanders email addresses as those are bouncing.
Add him to CREDITS.

Signed-off-by: Joe Perches <joe@perches.com>
---
 CREDITS     | 3 +++
 MAINTAINERS | 8 +++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/CREDITS b/CREDITS
index 948e0fb..d3a3188 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3129,6 +3129,9 @@ N: Robert Sanders
 E: gt8134b@prism.gatech.edu
 D: Dosemu
 
+N: Vincent Sanders
+D: EB110ATX (Chalice CATS) and EB2410ITX (BAST)
+
 N: Duncan Sands
 E: duncan.sands@free.fr
 W: http://topo.math.u-psud.fr/~sands
diff --git a/MAINTAINERS b/MAINTAINERS
index 6db1c6b..2465fae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7127,20 +7127,18 @@ F:	include/linux/sfi*.h
 
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
-P:	Vincent Sanders <vince@simtec.co.uk>
 M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
-P:	Vincent Sanders <vince@simtec.co.uk>
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


