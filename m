Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbaLJU6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:58:44 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38571 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217AbaLJU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:58:31 -0500
From: Doug Anderson <dianders@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>, Mark Brown <broonie@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: Alexandru Stan <amstan@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARK: dts: Specify VMMC and VQMMC on rk3288-evb
Date: Wed, 10 Dec 2014 12:58:05 -0800
Message-Id: <1418245085-9754-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1418245085-9754-1-git-send-email-dianders@chromium.org>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifying these rails should eventually let us do UHS.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/rk3288-evb.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 6194d67..1956a23 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -114,6 +114,8 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc_clk &sdmmc_cmd &sdmmc_cd &sdmmc_bus4>;
 	status = "okay";
+	vmmc-supply = <&vcc_io>;
+	vqmmc-supply = <&vccio_sd>;
 };
 
 &i2c0 {
-- 
2.2.0.rc0.207.ga3a616c

