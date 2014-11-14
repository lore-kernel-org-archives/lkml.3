Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422762AbaKNWxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:53:15 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:55014 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422723AbaKNWxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:53:11 -0500
From: Alexandru M Stan <amstan@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Doug Anderson <dianders@chromium.org>,
        addy ke <addy.ke@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Kever Yang <kever.yang@rock-chips.com>,
        Alexandru M Stan <amstan@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mturquette@linaro.org, mark.yao@rock-chips.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] clk: rockchip: add bindings for the mmc clock phases
Date: Fri, 14 Nov 2014 14:52:53 -0800
Message-Id: <1416005574-7756-2-git-send-email-amstan@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1416005574-7756-1-git-send-email-amstan@chromium.org>
References: <1416005574-7756-1-git-send-email-amstan@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used in a later patch for clock phase tuning.

Suggested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Alexandru M Stan <amstan@chromium.org>
---
 include/dt-bindings/clock/rk3288-cru.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index 100a08c..465d0f6 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -72,6 +72,16 @@
 #define SCLK_HEVC_CABAC		111
 #define SCLK_HEVC_CORE		112
 
+#define SCLK_SDMMC_DRV_PHASE	113
+#define SCLK_SDIO0_DRV_PHASE	114
+#define SCLK_SDIO1_DRV_PHASE	115
+#define SCLK_EMMC_DRV_PHASE	116
+
+#define SCLK_SDMMC_SAMPLE_PHASE	117
+#define SCLK_SDIO0_SAMPLE_PHASE	118
+#define SCLK_SDIO1_SAMPLE_PHASE	119
+#define SCLK_EMMC_SAMPLE_PHASE	120
+
 #define DCLK_VOP0		190
 #define DCLK_VOP1		191
 
-- 
2.1.0.rc2.206.gedb03e5

