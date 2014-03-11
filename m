Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaCKH4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:56:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32152 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaCKHzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:55:07 -0400
X-AuditID: cbfee68e-b7f566d000002344-ed-531ec159b894
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5/5] ARM: dts: exynos4412-trats2: Add ADC's dt data to get
 temperature of SoC/battery
Date: Tue, 11 Mar 2014 16:54:54 +0900
Message-id: <1394524494-30641-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkWDfyoFywweu1lhbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjigu
	m5TUnMyy1CJ9uwSujN7vlgULuSsebJzK3sD4k6OLkYNDQsBEouVEbBcjJ5ApJnHh3nq2LkYu
	DiGBpYwSVzpmsEIkTCTWnn3EApFYBJTYM5cRwmlkkvh4q5UJpIpNQEti/4sbbCC2iICuxJSZ
	d1hBipgF7jNJ/Di+CiwhLJAu8X3NUzCbRUBV4tXm/ewgNq+Aq8TBJQ+ZIdbJSXzY8wgszing
	JvH09nKwM4SAar48uckEMlRC4B67xL7HP5khBglIfJt8iAXiH1mJTQeg5khKHFxxg2UCo/AC
	RoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIFRdPrfs74djDcPWB9iTAYaN5FZSjQ5HxiF
	eSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUdv3
	618uTU+Gf01qeitMmmeseL7Z0bzdUJbttKfCkjUv3W/7PFadO4P/QF5BivH1ptXBd55W6Ket
	ZEx+Gplk51L56Nn6cMlJ8jzbFAKla7eePd40/c6FxnORCs9mNrdP5N3d88dbklF0vv2rqfcW
	zapYn9l06c8M1aXp4a1ZWZIclb3PfPfZKrEUZyQaajEXFScCAGD8hMC4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgG7kQblgg+1X9C2uf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDN6v1sWLOSueLBxKnsD40+OLkZO
	DgkBE4m1Zx+xQNhiEhfurWfrYuTiEBJYxChxZc9cRginkUni461WJpAqNgEtif0vbrCB2CIC
	uhJTZt5hBSliFrjPJPHj+CqwhLBAusT3NU/BbBYBVYlXm/ezg9i8Aq4SB5c8ZIZYJyfxYc8j
	sDingJvE09vLWUFsIaCaL09uMk1g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhK
	n0nvYFzVYHGIUYCDUYmHd4W/XLAQa2JZcWXuIUYJDmYlEV6ntUAh3pTEyqrUovz4otKc1OJD
	jMlAV01klhJNzgcmkLySeENjEzMjSyNzQwsjY3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi
	4JRqYGxy0GpQDp0g6P173leOmFbt2hrnt+Y390c3CP31PyzqH6/3J3KO73fl7ttLt1qlP9de
	wT71wen7flZnLnhtvbcpoNSO4ZJzbenyOrMwkx1SS4UiZ8xfNnd2pLpm7Df/C4LPpqcu/d+4
	sEyMvcj3kltU9aSZJRUM1qp/L8ibvT18J7NCJJixUImlOCPRUIu5qDgRAE4amZUWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use ADC to get the temperature of SoC/battery by using NTC thermistor
driver in hwmon. NTC thermistor driver covnvert ADC's raw data to temperature
by using following variables:

- pullup-uv    : Voltage
- pullup-ohm   : Pull-up resistance
- pulldown-ohm : Pull-down resistance
- io-channels  : It means ADC channel.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 4f851cc..fc517c3 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -106,6 +106,27 @@
 		};
 	};
 
+	adc: adc@126C0000 {
+		vdd-supply = <&ldo3_reg>;
+		status = "okay";
+
+		ncp15wb473@0 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
+			pullup-ohm = <100000>;	 /* 100K */
+			pulldown-ohm = <100000>; /* 100K */
+			io-channels = <&adc 1>;  /* AP temperature */
+		};
+
+		ncp15wb473@1 {
+			compatible = "ntc,ncp15wb473";
+			pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
+			pullup-ohm = <100000>;	 /* 100K */
+			pulldown-ohm = <100000>; /* 100K */
+			io-channels = <&adc 2>;  /* Battery temperature */
+		};
+	};
+
 	i2c@13890000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-slave-addr = <0x10>;
-- 
1.8.0

