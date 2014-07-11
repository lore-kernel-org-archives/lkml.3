Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaGKOTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:19:09 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18413 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaGKOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:19:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Jul 2014 07:11:59 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>, <mturquette@linaro.org>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 2/8] ARM: tegra: Remove TEGRA124_CLK_EMC from tegra124-car.h
Date: Fri, 11 Jul 2014 17:18:27 +0300
Message-ID: <1405088313-20048-3-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the TEGRA124_CLK_EMC cell value define for tegra124-car
from the binding headers. This clock has never been able to do
anything and is being replaced with a separate EMC driver with
its own device tree node. Removing the define ensures that any
user will not mistakenly refer to <&tegra_car TEGRA124_CLK_EMC>
instead of <&emc> or similar.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 include/dt-bindings/clock/tegra124-car.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
index 8a4c589..4faabce 100644
--- a/include/dt-bindings/clock/tegra124-car.h
+++ b/include/dt-bindings/clock/tegra124-car.h
@@ -73,7 +73,7 @@
 #define TEGRA124_CLK_I2C2 54
 #define TEGRA124_CLK_UARTC 55
 #define TEGRA124_CLK_MIPI_CAL 56
-#define TEGRA124_CLK_EMC 57
+/* 57 */
 #define TEGRA124_CLK_USB2 58
 #define TEGRA124_CLK_USB3 59
 /* 60 */
-- 
1.8.1.5

