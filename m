Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223AbaDJKHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:07:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53305 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965756AbaDJKGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:54 -0400
X-AuditID: cbfee68f-b7f156d00000276c-76-53466d227123
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 20/27] ARM: dts: exynos3250: Move definitions of external
 clocks to SoC dtsi
Date: Thu, 10 Apr 2014 19:06:10 +0900
Message-id: <1397124377-16969-12-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSoquU6xZssOG6lcX1L89ZLT5/aGG3
	mHR/AotF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7KYMfklm8X6Ga9ZLPbunMzowO2xeUm9
	R9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGV8Pv6eveAod8Wat59YGhhnc3YxcnJICJhIvP8x
	kwnCFpO4cG89WxcjF4eQwFJGif6+2UwwRRMmnmWESCxilPj46AszhNPEJLFuwyNmkCo2AS2J
	/S9usIHYIgIBEj+OvwOzmQVuMkocex8GYgsLxElsuXmLHcRmEVCVeHL9AAuIzSvgJjGho5MF
	YpucxIc9j8BqOIHiMxedBJsjJOAq0fPoIthiCYF17BIt124wQQwSkPg2+RBQMwdQQlZi0wFm
	iDmSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZg6J/+96x/B+PdA9aH
	GJOBxk1klhJNzgfGTl5JvKGxmZGFqYmpsZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5Xm
	pBYfYmTi4JRqYNx25978vZVnVib0c0kyNKmkn7DmPbNVeB2Dqekz26Ka4/nrma63T6u/6e8x
	U//NZoG5Ha5lDhrCLA+61n0xurr0huS77ecVLv1yevD/WOU1zjQ1n987jQwK+yZJ3tAK+nqs
	m0215ePRd1+/PWLP6yudH17Q+7REaMWmi2xqURq8AjwMU8sTvymxFGckGmoxFxUnAgDLKjK9
	kwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAV2lXLdgg7YPhhbXvzxntfj8oYXd
	YtL9CSwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8lixuSXbBbrZ7xmsdi7czKjA7fH5iX1
	Hn1bVjF6fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4/Px9+wF
	R7kr1rz9xNLAOJuzi5GTQ0LARGLCxLOMELaYxIV769m6GLk4hAQWMUp8fPSFGcJpYpJYt+ER
	M0gVm4CWxP4XN9hAbBGBAIkfx9+B2cwCNxkljr0PA7GFBeIktty8xQ5iswioSjy5foAFxOYV
	cJOY0NHJArFNTuLDnkdgNZxA8ZmLToLNERJwleh5dJF5AiPvAkaGVYyiqQXJBcVJ6bmGesWJ
	ucWleel6yfm5mxjBkfVMagfjygaLQ4wCHIxKPLwHlrkGC7EmlhVX5h5ilOBgVhLh3Z3pFizE
	m5JYWZValB9fVJqTWnyIMRnoqonMUqLJ+cCozyuJNzQ2MTOyNDI3tDAyNidNWEmc90CrdaCQ
	QHpiSWp2ampBahHMFiYOTqkGxk3V/EGVV/IW/BLwXvVSp/oZ67OteVtsHHrvbXA2vdr59ZLu
	4/z1U6Qe7/ssbbIlevMvn3CxhPVnK+WK921vkTl2U+fvlkobGb4D3gtnqdU015wSvX1q2hRZ
	5szeSTMPPu/s07Z+8SHyE3Ps+eU2my7xTnDI+cFt903Edeb5bbNna/TMcNC7NVeJpTgj0VCL
	uag4EQBrJhZ18AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This allows proper ordering of clock registration and is still correct,
because list of external clocks is SoC-specific, just their frequencies
and availability are board-specific.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 587a124..ceed761 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -40,6 +40,36 @@
 		i2c7 = &i2c_7;
 	};
 
+	fixed-rate-clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		xusbxti: clock@0 {
+			compatible = "fixed-clock";
+			reg = <0>;
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+			clock-output-names = "xusbxti";
+		};
+
+		xxti: clock@1 {
+			compatible = "fixed-clock";
+			reg = <1>;
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+			clock-output-names = "xxti";
+		};
+
+		xtcxo: clock@2 {
+			compatible = "fixed-clock";
+			reg = <2>;
+			clock-frequency = <0>;
+			#clock-cells = <0>;
+			clock-output-names = "xtcxo";
+		};
+	};
+
 	chipid@10000000 {
 		compatible = "samsung,exynos4210-chipid";
 		reg = <0x10000000 0x100>;
-- 
1.8.0

