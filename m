Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3KDB4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 20:56:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12982 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3KDB4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 20:56:08 -0500
X-AuditID: cbfee691-b7f866d000001b8c-38-5276feb52b68
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 1/3] ARM: dts: exynos4212: Add PMU dt data for pmu-irq
Date: Mon, 04 Nov 2013 10:55:59 +0900
Message-id: <1383530161-24080-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1383530161-24080-1-git-send-email-cw00.choi@samsung.com>
References: <1383530161-24080-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkUHfrv7Igg117DSyuf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFFc
	NimpOZllqUX6dglcGUf+LWEquM5S8fbVGsYGxlfMXYwcHBICJhLbF9Z1MXICmWISF+6tZ+ti
	5OIQEljKKPH16H42iISJxOvlj5kgEtMZJVqvHmOGcBqZJNZdPQtWxSagJbH/xQ0wW0RAV2LK
	zDusIEXMAveZJH4cXwWWEBbwkFj9dxkTiM0ioCrx7cZzFhCbV8BV4tetXiaIdXISH/Y8Ygex
	OQXcJP6dPwBmCwHV3G2+xggyVELgHrvE3uk32SAGCUh8m3yIBeIfWYlNB5gh5khKHFxxg2UC
	o/ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGIFxdPrfs4k7GO8fsD7EmAw0biKzlGhy
	PjAO80riDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	MdY3Ym5TZ8t27qr1Wa9qHnoUaX/UYZuRMbd9jmF13va0t6sEnhR/Xfms/9SOP+v0lr58Z7FL
	M6s0RH5Gy9WizXadfTwb7oXxr57Gs3TR2StbC/7xLN2/YqPq0TCGORmSXw9OFHFk3t7x5fzM
	zdoWASeDDQU2TBZYqzfhAetRD+dfvst4me/ENSmxFGckGmoxFxUnAgDkaEybuQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xoO7Wf2VBBiuaNCyuf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDOO/FvCVHCdpeLtqzWMDYyvmLsY
	OTkkBEwkXi9/zARhi0lcuLeerYuRi0NIYDqjROvVY8wQTiOTxLqrZ9lAqtgEtCT2v7gBZosI
	6EpMmXmHFaSIWeA+k8SP46vAEsICHhKr/y4DG8sioCrx7cZzFhCbV8BV4tetXqh1chIf9jxi
	B7E5Bdwk/p0/AGYLAdXcbb7GOIGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Dh9
	Jr2DcVWDxSFGAQ5GJR5eictlQUKsiWXFlbmHGCU4mJVEeJ3PAYV4UxIrq1KL8uOLSnNSiw8x
	JgNdNZFZSjQ5H5hC8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmD
	U6qBcdkshv3VZ85fVDeIPrQysiKpzYk1KiX8zuRTpU9W3M74KNZjrfu/IN1enyNklbzpzwl+
	Dn/95fjjFN9l5k3JDv17+uH5k99cPwpumT/BnoPLVOZNZFj30fY9826+fhPUVvczn1vwN8N2
	vkX3WR7kHN5evpjzlFvggpQjKVm7nxQcXzUl880eYyWW4oxEQy3mouJEAJtTGeQXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4212.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 6f34d7f..3081bae 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
@@ -56,4 +56,10 @@
 					<0x5 0 &gic 1 12 0>;
 		};
 	};
+
+	pmu {
+		compatible = "arm,cortex-a9-pmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>, <3 2>;
+	};
 };
-- 
1.8.0

