Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaK0Bax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:30:53 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:46010 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbaK0Bat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:30:49 -0500
From: Alexandru M Stan <amstan@chromium.org>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>,
        addy ke <addy.ke@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Kever Yang <kever.yang@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Alexandru M Stan <amstan@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mark.yao@rock-chips.com, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] clk: rockchip: add bindings for the mmc clocks
Date: Wed, 26 Nov 2014 17:30:26 -0800
Message-Id: <1417051827-12564-2-git-send-email-amstan@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1417051827-12564-1-git-send-email-amstan@chromium.org>
References: <1417051827-12564-1-git-send-email-amstan@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These clocks represent the physical clocks (including phases) and they will
later be used for clock phase tuning.

Suggested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Alexandru M Stan <amstan@chromium.org>
---
Changes in v4: None
Changes in v3: None
Changes in v2: None

 include/dt-bindings/clock/rk3288-cru.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index 100a08c..b4e9142 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -72,6 +72,16 @@
 #define SCLK_HEVC_CABAC		111
 #define SCLK_HEVC_CORE		112
 
+#define SCLK_SDMMC_DRV		113
+#define SCLK_SDIO0_DRV		114
+#define SCLK_SDIO1_DRV		115
+#define SCLK_EMMC_DRV		116
+
+#define SCLK_SDMMC_SAMPLE	117
+#define SCLK_SDIO0_SAMPLE	118
+#define SCLK_SDIO1_SAMPLE	119
+#define SCLK_EMMC_SAMPLE	120
+
 #define DCLK_VOP0		190
 #define DCLK_VOP1		191
 
-- 
2.2.0.rc0.207.ga3a616c

