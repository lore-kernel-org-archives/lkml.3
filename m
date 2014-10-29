Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaJ2Jox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:44:53 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42462 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbaJ2Jov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:44:51 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: arm@kernel.org
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] MAINTAINERS: drop list entry for davinci
Date: Wed, 29 Oct 2014 09:44:21 +0000
Message-Id: <1414575861-3906-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As davinci-linux-open-source@linux.davincidsp.com is now
shut and no more maintained by TI, drop this entry from
DAVINCI MACHINE SUPPORT and DAVINCI SERIES MEDIA DRIVER.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 Changes for v2:
 1: Restored link for patchwork.

 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dab92a7..ca86fd2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8479,7 +8479,6 @@ F:	arch/arm/mach-s3c24xx/bast-irq.c
 TI DAVINCI MACHINE SUPPORT
 M:	Sekhar Nori <nsekhar@ti.com>
 M:	Kevin Hilman <khilman@deeprootsystems.com>
-L:	davinci-linux-open-source@linux.davincidsp.com (moderated for non-subscribers)
 T:	git git://gitorious.org/linux-davinci/linux-davinci.git
 Q:	http://patchwork.kernel.org/project/linux-davinci/list/
 S:	Supported
@@ -8489,7 +8488,6 @@ F:	drivers/i2c/busses/i2c-davinci.c
 TI DAVINCI SERIES MEDIA DRIVER
 M:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
-L:	davinci-linux-open-source@linux.davincidsp.com (moderated for non-subscribers)
 W:	http://linuxtv.org/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
-- 
1.9.1

