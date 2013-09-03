Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab3ICNH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:07:27 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10166 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3ICNH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:07:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Sep 2013 06:04:39 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: tegra114: add missing clocks to binding
Date: Tue, 3 Sep 2013 16:07:13 +0300
Message-ID: <1378213637-9948-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 992bb598f690542a2f539fd12a42b960b7692025 forgot to move dfll_soc and
dfll_ref to include/dt-bindings/clock/tegra114-car.h. Add them again in this
patch as TEGRA114_CLK_DFLL_SOC and TEGRA114_CLK_DFLL_REF.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 include/dt-bindings/clock/tegra114-car.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/dt-bindings/clock/tegra114-car.h b/include/dt-bindings/clock/tegra114-car.h
index 614aec4..5d4b90a 100644
--- a/include/dt-bindings/clock/tegra114-car.h
+++ b/include/dt-bindings/clock/tegra114-car.h
@@ -289,8 +289,8 @@
 #define TEGRA114_CLK_PCLK 261
 #define TEGRA114_CLK_CCLK_G 262
 #define TEGRA114_CLK_CCLK_LP 263
-/* 264 */
-/* 265 */
+#define TEGRA114_CLK_DFLL_REF 264
+#define TEGRA114_CLK_DFLL_SOC 265
 /* 266 */
 /* 267 */
 /* 268 */
-- 
1.7.7.rc0.72.g4b5ea.dirty

