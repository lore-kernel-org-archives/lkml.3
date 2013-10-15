Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab3JOOzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:55:12 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11588 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3JOOzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:55:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 15 Oct 2013 07:50:44 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH v3 01/19] ARM: tegra30: add missing CLK IDs
Date: Tue, 15 Oct 2013 17:52:46 +0300
Message-ID: <1381848794-11761-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
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

