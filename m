Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaG2Uds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:33:48 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:34190 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaG2UdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:33:11 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: dts: Enable DDR50 mode on the eMMC
Date: Tue, 29 Jul 2014 13:31:54 -0700
Message-Id: <1406665916-23396-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1406665916-23396-1-git-send-email-dianders@chromium.org>
References: <1406665916-23396-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DDR50 mode now works on the rockchip driver, so enable it.

NOTE: if Addy spins (mmc: dw_mmc: add support for RK3288) before it
lands then we could squash this into my (ARM: dts: Enable emmc and
sdmmc on the rk3288-evb boards).

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/rk3288-evb.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index e44e34f..ec580fa 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -41,6 +41,7 @@
 	broken-cd;
 	bus-width = <8>;
 	cap-mmc-highspeed;
+	mmc-ddr-1_8v;
 	non-removable;
 	num-slots = <1>;
 	pinctrl-names = "default";
-- 
2.0.0.526.g5318336

