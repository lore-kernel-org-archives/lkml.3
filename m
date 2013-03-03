Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3CCByT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:54:19 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:54918 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3CCByP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:15 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 03/14] MAINTAINERS: remove arch/arm/plat-s3c24xx/
Date: Sat,  2 Mar 2013 22:53:41 -0300
Message-Id: <1362275632-20242-4-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This directory was removed by commit 09ec1d7 (ARM: S3C24XX: Remove
plat-s3c24xx directory in arch/arm/).

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c074d5..5af82f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1119,7 +1119,6 @@ L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-samsung/
-F:	arch/arm/plat-s3c24xx/
 F:	arch/arm/mach-s3c24*/
 F:	arch/arm/mach-s3c64xx/
 F:	drivers/*/*s3c2410*
-- 
1.7.11.7

