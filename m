Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3ITWd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 18:33:26 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4146 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab3ITWdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 18:33:24 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Christian Daudt" <csd@broadcom.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
        "Olof Johansson" <olof@lixom.net>, "Arnd Bergmann" <arnd@arndb.de>,
        "Stephen Warren" <swarren@wwwdotorg.org>
cc: "Christian Daudt" <csd@broadcom.com>, "arm@kernel.org" <arm@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Christian Daudt" <bcm@fixthebug.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Alex Elder" <alex.elder@linaro.org>
Subject: [PATCH] MAINTAINERS: Update mach-bcm related email address
Date: Fri, 20 Sep 2013 15:33:11 -0700
Message-ID: <1379716391-11263-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7E2214221R092995843-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update email address on mach-bcm + drivers for Broadcom
mobile SoCs.

Signed-off-by: Christian Daudt <csd@broadcom.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..b2f857c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1812,7 +1812,8 @@ S:	Supported
 F:	drivers/net/ethernet/broadcom/bnx2x/
 
 BROADCOM BCM281XX/BCM11XXX ARM ARCHITECTURE
-M:	Christian Daudt <csd@broadcom.com>
+M:	Christian Daudt <bcm@fixthebug.org>
+L:	bcm-kernel-feedback-list@broadcom.com
 T:	git git://git.github.com/broadcom/bcm11351
 S:	Maintained
 F:	arch/arm/mach-bcm/
-- 
1.7.10.4


