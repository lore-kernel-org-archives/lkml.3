Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaBNPPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:15:11 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:59774 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBNPPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:15:10 -0500
From: Matt Porter <mporter@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2] MAINTAINERS: add additional ARM BCM281xx/BCM11xxx maintainer
Date: Fri, 14 Feb 2014 10:15:03 -0500
Message-Id: <1392390903-19826-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as an additional maintainer for the Broadcom mobile
SoCs.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
Since v1: put back my missing SOB

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..9d6fbfd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1860,6 +1860,7 @@ F:	drivers/net/ethernet/broadcom/bnx2x/
 
 BROADCOM BCM281XX/BCM11XXX ARM ARCHITECTURE
 M:	Christian Daudt <bcm@fixthebug.org>
+M:	Matt Porter <mporter@linaro.org>
 L:	bcm-kernel-feedback-list@broadcom.com
 T:	git git://git.github.com/broadcom/bcm11351
 S:	Maintained
-- 
1.8.4

