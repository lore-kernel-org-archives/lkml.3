Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaK0Xot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:44:49 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:57079 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaK0Xop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:44:45 -0500
X-IronPort-AV: E=Sophos;i="5.07,472,1413270000"; 
   d="scan'208";a="51976521"
From: Ray Jui <rjui@broadcom.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Scott Branden <sbranden@broadcom.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH 3/4] ARM: mach-bcm: enable pinctrl support for Cygnus
Date: Thu, 27 Nov 2014 15:46:29 -0800
Message-ID: <1417131990-17954-4-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417131990-17954-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1417131990-17954-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the pinctrl driver for Broadcom Cygnus SoC

Signed-off-by: Ray Jui <rjui@broadcom.com>
---
 arch/arm/mach-bcm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index aaeec78..b4efff2 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -29,6 +29,7 @@ config ARCH_BCM_IPROC
 config ARCH_BCM_CYGNUS
 	bool "Broadcom Cygnus Support" if ARCH_MULTI_V7
 	select ARCH_BCM_IPROC
+	select PINCTRL_BCM_CYGNUS
 	help
 	  Enable support for the Cygnus family,
 	  which includes the following variants:
-- 
1.7.9.5

