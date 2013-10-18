Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3JRNZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:25:33 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1398 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3JRNZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:25:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Oct 2013 06:25:31 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 01/15] ARM: tegra30: add missing CLK IDs
Date: Fri, 18 Oct 2013 16:25:05 +0300
Message-ID: <1382102719-5531-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra30 clock bindings lack few IDs for audio and clk_out muxes.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 include/dt-bindings/clock/tegra30-car.h |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/dt-bindings/clock/tegra30-car.h b/include/dt-bindings/clock/tegra30-car.h
index e40fae8..2244582 100644
--- a/include/dt-bindings/clock/tegra30-car.h
+++ b/include/dt-bindings/clock/tegra30-car.h
@@ -260,6 +260,14 @@
 /* 298 */
 /* 299 */
 #define TEGRA30_CLK_CLK_OUT_1_MUX 300
-#define TEGRA30_CLK_CLK_MAX 301
+#define TEGRA30_CLK_CLK_OUT_2_MUX 301
+#define TEGRA30_CLK_CLK_OUT_3_MUX 302
+#define TEGRA30_CLK_AUDIO0_MUX 303
+#define TEGRA30_CLK_AUDIO1_MUX 304
+#define TEGRA30_CLK_AUDIO2_MUX 305
+#define TEGRA30_CLK_AUDIO3_MUX 306
+#define TEGRA30_CLK_AUDIO4_MUX 307
+#define TEGRA30_CLK_SPDIF_MUX 308
+#define TEGRA30_CLK_CLK_MAX 309
 
 #endif	/* _DT_BINDINGS_CLOCK_TEGRA30_CAR_H */
-- 
1.7.7.rc0.72.g4b5ea.dirty

