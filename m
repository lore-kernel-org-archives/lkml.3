Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaJOPyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:54:38 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:58986 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaJOPyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:54:36 -0400
X-IronPort-AV: E=Sophos;i="5.04,725,1406617200"; 
   d="scan'208";a="48505178"
From: Scott Branden <sbranden@broadcom.com>
To: Joe Perches <joe@perches.com>, Stephen Warren <swarren@wwwdotorg.org>
CC: Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-rpi-kernel@lists.infradead.org>,
        Scott Branden <sbranden@broadcom.com>
Subject: [PATCH 1/1] MAINTAINERS: corrected bcm2835 search
Date: Wed, 15 Oct 2014 08:54:27 -0700
Message-ID: <1413388467-3804-1-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Scott Branden <sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected bcm2835 maintainer info by using N: to specify any files with
bcm2835 in are directed to the proper maintainer.
Also corrected minor mispelling of ARCHITECTURE in 2 comment locations.

Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 MAINTAINERS |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0cf8c9..801beb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2056,17 +2056,14 @@ F:	arch/arm/configs/bcm_defconfig
 F:	drivers/mmc/host/sdhci-bcm-kona.c
 F:	drivers/clocksource/bcm_kona_timer.c
 
-BROADCOM BCM2835 ARM ARCHICTURE
+BROADCOM BCM2835 ARM ARCHITECTURE
 M:	Stephen Warren <swarren@wwwdotorg.org>
 L:	linux-rpi-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-rpi.git
 S:	Maintained
-F:	arch/arm/mach-bcm/board_bcm2835.c
-F:	arch/arm/boot/dts/bcm2835*
-F:	arch/arm/configs/bcm2835_defconfig
-F:	drivers/*/*bcm2835*
+N:	bcm2835
 
-BROADCOM BCM5301X ARM ARCHICTURE
+BROADCOM BCM5301X ARM ARCHITECTURE
 M:	Hauke Mehrtens <hauke@hauke-m.de>
 L:	linux-arm-kernel@lists.infradead.org
 S:	Maintained
-- 
1.7.9.5

