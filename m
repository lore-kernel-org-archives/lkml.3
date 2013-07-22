Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3GVAQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:16:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58969 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753885Ab3GVAQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:16:53 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/18] MAINTAINERS: ARM: S3C24XX: Remove plat-s3c24xx
Date: Sun, 21 Jul 2013 17:15:34 -0700
Message-Id: <a1c5036f883b433e8c807d1ce6928860a5059131.1374451988.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 09ec1d7ea6 ("ARM: S3C24XX: Remove plat-s3c24xx directory in
arch/arm/") moved the files, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab9a5c4..e94aecb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1130,7 +1130,6 @@ L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-samsung/
-F:	arch/arm/plat-s3c24xx/
 F:	arch/arm/mach-s3c24*/
 F:	arch/arm/mach-s3c64xx/
 F:	drivers/*/*s3c2410*
-- 
1.8.1.2.459.gbcd45b4.dirty

