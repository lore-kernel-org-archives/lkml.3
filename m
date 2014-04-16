Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbaDPMkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:40:45 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46542 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaDPMki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:40:38 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-ec-534e7a44b11f
Message-id: <534E7A3F.7050406@samsung.com>
Date: Wed, 16 Apr 2014 14:40:31 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>
Subject: [PATCH] arm: dts: exynos4: add missing pinctrls for I2C controllers
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xq7ouVX7BBr3TNCw2zljPajFp3QEm
	i/lHzrFa9L9ZyGpx7tVKRoveBVfZLM42vWG32PT4GqvF5V1z2CxmnN/HZHH7Mq/F0usXmSwm
	TF/LYtG69wi7xfoZr1kc+D3WzFvD6NHS3MPmcbmvl8nj76oXzB4rl39h89i0qpPNY/OSeo++
	LasYPT5vkgvgjOKySUnNySxLLdK3S+DKOH1zNmPBDp6KiwdPMjUwHuTsYuTkkBAwkWh9+ZQd
	whaTuHBvPVsXIxeHkMBSRondE95BOZ8ZJbb+P80MUsUroCWx8sUuJhCbRUBVouPJZLBuNqBJ
	x5Z8ZgSxRQUiJOZO3MwGUS8o8WPyPRYQWwSo5kFrL9hQZoFjLBJfm1eAFQkL+Ej8vn0crJlZ
	QF1i0rxFzBC2vMTmNW+ZJzDyzUIyaxaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vO
	z93ECImWLzsYFx+zOsQowMGoxMPrkOUbLMSaWFZcmXuIUYKDWUmEtzfLL1iINyWxsiq1KD++
	qDQntfgQIxMHp1QDoxk/x5YT23umKNUyCl62MhTkdFq7LkhkYdx9zZg+C8cPJkuOhSattok1
	7DQ7NG2We1d/8jm+6xLRJuHfHHgO63gmmIvounnUbJlou/7jGacVvydc174msCV0/tH1YU+f
	vNv1oU1rp8GBfKOD0jkTZjz+U3j0okhGo05J+p5rShMLXz9yn/LxkhJLcUaioRZzUXEiAJVh
	Gl90AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing pinctrls for I2C controllers 2-7.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 0401f4d..288aa81 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -357,6 +357,8 @@
 		interrupts = <0 60 0>;
 		clocks = <&clock CLK_I2C2>;
 		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c2_bus>;
 		status = "disabled";
 	};

@@ -368,6 +370,8 @@
 		interrupts = <0 61 0>;
 		clocks = <&clock CLK_I2C3>;
 		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c3_bus>;
 		status = "disabled";
 	};

@@ -379,6 +383,8 @@
 		interrupts = <0 62 0>;
 		clocks = <&clock CLK_I2C4>;
 		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c4_bus>;
 		status = "disabled";
 	};

@@ -390,6 +396,8 @@
 		interrupts = <0 63 0>;
 		clocks = <&clock CLK_I2C5>;
 		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c5_bus>;
 		status = "disabled";
 	};

@@ -401,6 +409,8 @@
 		interrupts = <0 64 0>;
 		clocks = <&clock CLK_I2C6>;
 		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c6_bus>;
 		status = "disabled";
 	};

@@ -412,6 +422,8 @@
 		interrupts = <0 65 0>;
 		clocks = <&clock CLK_I2C7>;
 		clock-names = "i2c";
+		pinctrl-names = "default";
+		pinctrl-0 = <&i2c7_bus>;
 		status = "disabled";
 	};

