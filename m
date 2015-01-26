Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbbAZERR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:17:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35520 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbbAZEQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:16:46 -0500
X-AuditID: cbfee691-f79b86d000004a5a-cd-54c5bfa59fb3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        sangbae90.lee@samsung.com, inki.dae@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v10 3/7] devfreq: event: Add documentation for exynos-ppmu
 devfreq-event driver
Date: Mon, 26 Jan 2015 13:16:29 +0900
Message-id: <1422245793-8552-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
References: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkWHfp/qMhBpdma1k8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtjn86yGKxatcfRgdBjzXz1jB67Jx1l91j8Z6XTB6bVnWyeWxeUu/R
	t2UVo8fnTXIB7FFcNimpOZllqUX6dglcGYtuL2EpmC9bcbNzH3MD43rxLkZODgkBE4m9XaeY
	IWwxiQv31rN1MXJxCAksZZT4297CDFO08sk0dojEdEaJnU+WQVU1MUm8fjiHEaSKTUBLYv+L
	G2wgtoiAnkTnsT1gHcwC05klJi+YyAqSEBZIlPh48B6YzSKgKtH3bD5YM6+Ai8SzFeug1ilI
	LFs+E6yGU8BVYmLDc6AaDqBtLhLfv3OBzJQQ+Mgucfncf3aIOQIS3yYfYgGpkRCQldh0AGqM
	pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRGF2n/z2buIPx/gHrQ4wC
	HIxKPLwajUdDhFgTy4orcw8xmgJtmMgsJZqcD4zhvJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGHfcqrbKZvhzLltucQL77smW+jr7dko48lkcmrsz
	5ZfzP8XWrF8admclfwdk5DgI8F9rZLt2R8hryZppOtf5zkZe418xIfPaMmuPWRlHVXaYNF28
	5MkUzNEQdDLkDGuC7M62x+IdMvd+/lnVmO3VxmihfJDtzYoTy16E+HPdK4yPNxDjbwq8o8RS
	nJFoqMVcVJwIACpCuCCpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQd2l+4+GGHw9qWDxeM1iJouNM9az
	Wlz/8pzVYtL9CSwWr18YWvQ/fs1scbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVr3HmG3OP7pIIvFql1/GB0EPdbMW8PosXPWXXaPxXteMnlsWtXJ5rF5Sb1H
	35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAH2gpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcxYdHsJS8F8
	2YqbnfuYGxjXi3cxcnJICJhIrHwyjR3CFpO4cG89WxcjF4eQwHRGiZ1PlkE5TUwSrx/OYQSp
	YhPQktj/4gYbiC0ioCfReWwPO0gRs8B0ZonJCyaygiSEBRIlPh68B2azCKhK9D2bD9bMK+Ai
	8WzFOmaIdQoSy5bPBKvhFHCVmNjwHKiGA2ibi8T371wTGHkXMDKsYhRNLUguKE5KzzXUK07M
	LS7NS9dLzs/dxAiO3WdSOxhXNlgcYhTgYFTi4W1oPhoixJpYVlyZe4hRgoNZSYS3fApQiDcl
	sbIqtSg/vqg0J7X4EKMp0FETmaVEk/OBaSWvJN7Q2MTMyNLI3NDCyNhcSZxXyb4tREggPbEk
	NTs1tSC1CKaPiYNTqoGxS6B15pGtx/VjHjBEvv+2WJPJm8ftpczCo69jGNXuRLZlXFrnsktS
	iOP4zZsmOTmRO8Oe690S+bczqWPblWeSUeL1V8LvH1v2M2z1se/Sa/vXHTy7+86z+TMrH219
	/GFrjYPJnRe5xxZPa7IIMPbOb819HD1Z3SomOebvo7mqJgJ++q7J1ba+SizFGYmGWsxFxYkA
	N18oivMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the documentation for Exynos PPMU (Platform Performance
Monitoring Unit) devfreq-event driver.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++++++++++++++++++
 1 file changed, 110 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt

diff --git a/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
new file mode 100644
index 0000000..b54bf3a
--- /dev/null
+++ b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
@@ -0,0 +1,110 @@
+
+* Samsung Exynos PPMU (Platform Performance Monitoring Unit) device
+
+The Samsung Exynos SoC has PPMU (Platform Performance Monitoring Unit) for
+each IP. PPMU provides the primitive values to get performance data. These
+PPMU events provide information of the SoC's behaviors so that you may
+use to analyze system performance, to make behaviors visible and to count
+usages of each IP (DMC, CPU, RIGHTBUS, LEFTBUS, CAM interface, LCD, G3D, MFC).
+The Exynos PPMU driver uses the devfreq-event class to provide event data
+to various devfreq devices. The devfreq devices would use the event data when
+derterming the current state of each IP.
+
+Required properties:
+- compatible: Should be "samsung,exynos-ppmu".
+- reg: physical base address of each PPMU and length of memory mapped region.
+
+Optional properties:
+- clock-names : the name of clock used by the PPMU, "ppmu"
+- clocks : phandles for clock specified in "clock-names" property
+- #clock-cells: should be 1.
+
+Example1 : PPMU nodes in exynos3250.dtsi are listed below.
+
+		ppmu_dmc0: ppmu_dmc0@106a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106a0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_dmc1: ppmu_dmc1@106b0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106b0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_cpu: ppmu_cpu@106c0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106c0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_rightbus: ppmu_rightbus@112a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x112a0000 0x2000>;
+			clocks = <&cmu CLK_PPMURIGHT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_leftbus: ppmu_leftbus0@116a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x116a0000 0x2000>;
+			clocks = <&cmu CLK_PPMULEFT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+Example2 : Events of each PPMU node in exynos3250-rinato.dts are listed below.
+
+	&ppmu_dmc0 {
+		status = "okay";
+
+		events {
+			ppmu_dmc0_3: ppmu-event3-dmc0 {
+				event-name = "ppmu-event3-dmc0";
+			};
+
+			ppmu_dmc0_2: ppmu-event2-dmc0 {
+				event-name = "ppmu-event2-dmc0";
+			};
+
+			ppmu_dmc0_1: ppmu-event1-dmc0 {
+				event-name = "ppmu-event1-dmc0";
+			};
+
+			ppmu_dmc0_0: ppmu-event0-dmc0 {
+				event-name = "ppmu-event0-dmc0";
+			};
+		};
+	};
+
+	&ppmu_dmc1 {
+		status = "okay";
+
+		events {
+			ppmu_dmc1_3: ppmu-event3-dmc1 {
+				event-name = "ppmu-event3-dmc1";
+			};
+		};
+	};
+
+	&ppmu_leftbus {
+		status = "okay";
+
+		events {
+			ppmu_leftbus_3: ppmu-event3-leftbus {
+				event-name = "ppmu-event3-leftbus";
+			};
+		};
+	};
+
+	&ppmu_rightbus {
+		status = "okay";
+
+		events {
+			ppmu_rightbus_3: ppmu-event3-rightbus {
+				event-name = "ppmu-event3-rightbus";
+			};
+		};
+	};
-- 
1.8.5.5

