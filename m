Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaCLGT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:19:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49496 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaCLGTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:19:22 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-46-531ffc6821ea
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/5] ARM: dts: exynos4x12: Add ADC's dt data to read raw data
Date: Wed, 12 Mar 2014 15:19:12 +0900
Message-id: <1394605156-7768-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkRDfjj3ywwcUfOhbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvFq4NtLBbr
	Z7xmceD1WDNvDaNHS3MPm8fK5V/YPDYvqffo27KK0ePzJjmPjXNDA9ijuGxSUnMyy1KL9O0S
	uDJWX1nFVjCNo2LzxilsDYy32boYOTkkBEwkXjb3s0DYYhIX7q0HinNxCAksZZSYdP0/I0zR
	//VnWCAS0xkl2g+/YIZwGpkk5t17ww5SxSagJbH/xQ2wsSICuhJTZt5hBbGZBY4xSZyY6tDF
	yMEhLOAvseiYD0iYRUBV4umrI2CbeQVcJO5/mcUMsUxO4sOeR+wg5ZwCrhIb5iWDhIWASo5/
	PAp2g4TAJXaJ5stX2CDmCEh8m3yIBaReQkBWYtMBqDGSEgdX3GCZwCi8gJFhFaNoakFyQXFS
	epGpXnFibnFpXrpecn7uJkZgvJz+92ziDsb7B6wPMSYDjZvILCWanA+Mt7ySeENjMyMLUxNT
	YyNzSzPShJXEedMfJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYBRmvnX1yzPv1tcb8tKP
	7Zi1O2J25GlD82O+ThoT6qTE/uzWEcl8fHDmw2XTArgsPgVdfOB56E3C34Zr2S9vOQv6//28
	QvaMG/e+/x+CPdhS9DpPVlxnq69aVdD7Pcuv1SmwoeOAX2qpyZapM5Mv//jQ6rS2ov97kZwE
	b7vqIfljczk4TwQKH1RiKc5INNRiLipOBACq7W02rQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jQd2MP/LBBo1X1S2uf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLVwfbWCzW
	z3jN4sDrsWbeGkaPluYeNo+Vy7+weWxeUu/Rt2UVo8fnTXIeG+eGBrBHNTDaZKQmpqQWKaTm
	JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
	wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWH1lFVvBNI6KzRunsDUw3mbrYuTkkBAwkfi//gwL
	hC0mceHeeqA4F4eQwHRGifbDL5ghnEYmiXn33rCDVLEJaEnsf3EDrFtEQFdiysw7rCA2s8Ax
	JokTUx26GDk4hAX8JRYd8wEJswioSjx9dQRsAa+Ai8T9L7OYIZbJSXzY84gdpJxTwFViw7xk
	kLAQUMnxj0dZJjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHI3PpHYwrmywOMQo
	wMGoxMO7QFM+WIg1say4MvcQowQHs5II70eQEG9KYmVValF+fFFpTmrxIcZkoKMmMkuJJucD
	E0VeSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAWt2S8uuI8
	4/ckjV2HEjPyFqs/6nvqHZ0VEvpr2apNv+2mz028+To+zvxl/MRgdYVFvaZXfb9cebW99c6z
	z/+P2zbwiVcXPN66QfigymY/5RM212NkWIp0LS1Ct19vyHmkwlB2Tsyl8EVZ2Oob7K7JBWV8
	G9oCXvR/tVLXnrYu4oo/u8efaBclluKMREMt5qLiRAAB08EECgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add ADC(Analog to Digital Converter)'s dt data to get raw data
with IIO subsystem. Usually, ADC is used to check temperature, jack type
and so on.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index e0eb6bb..eec1e30 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -80,6 +80,18 @@
 		};
 	};
 
+	adc: adc@126C0000 {
+		compatible = "samsung,exynos-adc-v1";
+		reg = <0x126C0000 0x100>, <0x10020718 0x4>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 3>;
+		clocks = <&clock CLK_TSADC>;
+		clock-names = "adc";
+		#io-channel-cells = <1>;
+		io-channel-ranges;
+		status = "disabled";
+	};
+
 	pinctrl_2: pinctrl@03860000 {
 		compatible = "samsung,exynos4x12-pinctrl";
 		reg = <0x03860000 0x1000>;
-- 
1.8.0

