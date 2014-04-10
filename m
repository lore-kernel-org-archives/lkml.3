Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965AbaDJKOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:14:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53304 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965770AbaDJKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:56 -0400
X-AuditID: cbfee690-b7f266d00000287c-d1-53466d26c8d6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 24/27] ARM: dts: exynos3250: Add pwm dt node to support PWM
 Timer
Date: Thu, 10 Apr 2014 19:06:14 +0900
Message-id: <1397124377-16969-16-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkQFct1y3Y4PJhdovrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mro2X2BreA+e8XRvbMZGxhnsnUxcnJICJhIPGp4
	ygxhi0lcuLceLC4ksJRR4vRuSZiaF7e3ANVwAcUXMUpM6FwEVdTEJLH0pgqIzSagJbH/xQ2w
	uIhAgMSP4+/AbGaBm4wSx96HgdjCAsESK04/YwexWQRUJdpnfmIBsXkF3CR2z5/BDrFMTuLD
	nkdgNidQfOaik1C7XCV6Hl0EO0JCYBm7xK/D3YwQgwQkvk0+BDSIAyghK7HpANQzkhIHV9xg
	mcAovICRYRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYNif/vdswg7GewesDzEmA42byCwl
	mpwPjJu8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amDM9Zy4cs2e801i2zRy9d9nMAW6Osb+d/o9tTQwjH9axF6zV8yhGjtT/64I8PRV2Fyacqf+
	3LWgVVbVfWFPJv5Ly9u6yFAv556d06ZpkxdYROyI1baQ+HIt4I/pntenL+l6XJKcajHfUnp7
	nPsztQ03WPvmpF2vivpwTqD3iGeymsSjFXeVMt4rsRRnJBpqMRcVJwIAmgFRcpECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV3VXLdggxPPbSyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jRs/uC2wF
	99krju6dzdjAOJOti5GTQ0LAROLF7S3MELaYxIV764HiXBxCAosYJSZ0LgIrEhJoYpJYelMF
	xGYT0JLY/+IGWFxEIEDix/F3YDazwE1GiWPvw0BsYYFgiRWnn7GD2CwCqhLtMz+xgNi8Am4S
	u+fPYIdYJifxYc8jMJsTKD5z0UmoXa4SPY8uMk9g5F3AyLCKUTS1ILmgOCk911CvODG3uDQv
	XS85P3cTIziunkntYFzZYHGIUYCDUYmH98Ay12Ah1sSy4srcQ4wSHMxKIry7M92ChXhTEiur
	Uovy44tKc1KLDzEmA101kVlKNDkfGPN5JfGGxiZmRpZG5oYWRsbmpAkrifMeaLUOFBJITyxJ
	zU5NLUgtgtnCxMEp1cCY+UgkI48vx05wjutqiy3PPPdwmnZNeKBeLHZ5tvLhY+Y7PTZPj//n
	xBm/S3Xufn72ba8mr/OSm3/hzgGTxbcu7Z0v1vVnR9XWSQ0ukYk2G1I+3L8Z5VS7sXqB6xxB
	nvlWUlrLLi2d/7+Qu/hx+DXvYIUgu95Njt8SZ00o3viAJSPsDOuq6LRFSizFGYmGWsxFxYkA
	Mb+Rru8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch add pwm dt node to support PWM (Pulse Width Modulation) timer.
Exynos uses same IP of Exynos4210 and has five 32-bit PWM timers.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 03e7931..c8bd33cf 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -345,6 +345,15 @@
 		status = "disabled";
 	};
 
+	pwm: pwm@139D0000 {
+		compatible = "samsung,exynos4210-pwm";
+		reg = <0x139D0000 0x1000>;
+		interrupts = <0 104 0>, <0 105 0>, <0 106 0>,
+			     <0 107 0>, <0 108 0>;
+		#pwm-cells = <3>;
+		status = "disabled";
+	};
+
 	pmu {
 		compatible = "arm,cortex-a7-pmu";
 		interrupts = <0 18 0>, <0 19 0>, <0 20 0>, <0 21 0>;
-- 
1.8.0

