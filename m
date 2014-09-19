Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbaISSRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:17:34 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41707 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbaISSRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:17:30 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, olof@lixom.net, arm@kernel.org, mporter@linaro.org,
        bcm@fixthebug.org, jonathar@broadcom.com, sbranden@broadcom.com,
        rjui@broadcom.com, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, hauke@hauke-m.de,
        swarren@wwwdotorg.org, computersforpeace@gmail.com,
        marc.ceeeee@gmail.com, cernekee@gmail.com, gregory.0xf0@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] MAINTAINERS: add a third maintainer to mach-bcm
Date: Fri, 19 Sep 2014 11:17:12 -0700
Message-Id: <1411150632-25695-2-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411150632-25695-1-git-send-email-f.fainelli@gmail.com>
References: <1411150632-25695-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as a third maintainer to the mach-bcm code to increase the
chances the redundancy in the merging/reviewing process.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 809ecd680d88..e0762fea2d02 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2004,6 +2004,7 @@ F:	drivers/net/ethernet/broadcom/bnx2x/
 BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITECTURE
 M:	Christian Daudt <bcm@fixthebug.org>
 M:	Matt Porter <mporter@linaro.org>
+M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	bcm-kernel-feedback-list@broadcom.com
 T:	git git://github.com/broadcom/mach-bcm
 S:	Maintained
-- 
1.9.1

