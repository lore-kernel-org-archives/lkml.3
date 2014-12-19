Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaLSANz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:13:55 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61631 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaLSANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:13:53 -0500
From: Dmitry Torokhov <dtor@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, hl@rock-chips.com,
        kever.yang@rock-chips.com, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] CHROMIUM: clk: rockchip: add clock IDs for the PVTM clocks
Date: Thu, 18 Dec 2014 16:13:45 -0800
Message-Id: <1418948026-3463-1-git-send-email-dtor@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Lin <hl@rock-chips.com>

Process-Voltage-Temperature Monitor has two clocks, PVTM_CORE and
PVTM_GPU.

Signed-off-by: Huang Lin <hl@rock-chips.com>
Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---

Note that I left a hole at 122 for SCLK_USBPHY480M_SRC which is floating
around.

 include/dt-bindings/clock/rk3288-cru.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index f60ce72..ba4c194 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -81,6 +81,9 @@
 #define SCLK_SDIO1_SAMPLE	120
 #define SCLK_EMMC_SAMPLE	121
 
+#define SCLK_PVTM_CORE		123
+#define SCLK_PVTM_GPU		124
+
 #define DCLK_VOP0		190
 #define DCLK_VOP1		191
 
-- 
2.2.0.rc0.207.ga3a616c

