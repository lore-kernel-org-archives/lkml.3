Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaGKRsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:48:36 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56757 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaGKRse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:48:34 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org, chris@printf.net, ulf.hansson@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH 3/3] mmc: sdhci-msm: Get COMPILE_TEST support
Date: Fri, 11 Jul 2014 20:48:13 +0300
Message-Id: <1405100893-32107-4-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405100893-32107-1-git-send-email-gdjakov@mm-sol.com>
References: <1405100893-32107-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the build testing coverage.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/mmc/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index a565254..1325cae 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -343,7 +343,7 @@ config MMC_ATMELMCI
 
 config MMC_SDHCI_MSM
 	tristate "Qualcomm SDHCI Controller Support"
-	depends on ARCH_QCOM
+	depends on ARCH_QCOM || (ARM && COMPILE_TEST)
 	depends on MMC_SDHCI_PLTFM
 	help
 	  This selects the Secure Digital Host Controller Interface (SDHCI)
-- 
1.7.9.5

