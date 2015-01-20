Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbbATHKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:10:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48775 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbATHKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:10:17 -0500
X-AuditID: cbfee68d-f79296d000004278-03-54bdff56fd2f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v9 3/7] devfreq: event: Add documentation for exynos-ppmu
 devfreq-event driver
Date: Tue, 20 Jan 2015 16:10:05 +0900
Message-id: <1421737809-4010-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
References: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkQDfs/94Qg03HZC0er1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlbHo9hKWgvmyFTc79zE3MK4X72Lk5JAQMJH4f2gTO4QtJnHh
	3nq2LkYuDiGBpYwSG9YdYYcpej91JVRiEaPE2Z2fWSGcJiaJAzPvsYFUsQloSex/cQPMFhHQ
	k+g8tgesm1ngD5NE0yYWEFtYIEHi6eJZjCA2i4CqxPFVL8HqeQVcJBasus0EsU1BYtnymawg
	NqeAq8T2LZfB6oWAapo/v4eqecku0XfDDWKOgMS3yYeA5nMAxWUlNh1ghiiRlDi44gbLBEbh
	BYwMqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECI+r0v2e9OxhvH7A+xCjAwajEw/ti1d4Q
	IdbEsuLK3EOMpkAbJjJLiSbnA+M2ryTe0NjMyMLUxNTYyNzSTEmcV1HqZ7CQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGxgktW37X/Mnj9PDuO/j15UbXhHupuxLPvJq0iP3NLlaPoNQax5my
	umu8M+4Jf/+9qOTqF7Pmc8s/fKt/evuNLIuMO5O4sNocsVl9D/h+Okk9u8Lh07K+3Xj3oeNy
	oj75P463nNdj6Q2oFbV0mLh1asqOa5ckK4WPSYQ8Wx4mtbBJ4tMsy1uuNkosxRmJhlrMRcWJ
	ALvMWnejAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd2w/3tDDNquilo8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGottLWArmy1bc7NzH
	3MC4XryLkZNDQsBE4v3UlWwQtpjEhXvrgWwuDiGBRYwSZ3d+ZoVwmpgkDsy8B1bFJqAlsf/F
	DTBbREBPovPYHnYQm1ngD5NE0yYWEFtYIEHi6eJZjCA2i4CqxPFVL8HqeQVcJBasus0EsU1B
	YtnymawgNqeAq8T2LZfB6oWAapo/v2eawMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwxD6T2sG4ssHiEKMAB6MSD6/D2r0hQqyJZcWVuYcYJTiYlUR4JzwFCvGmJFZWpRblxxeV
	5qQWH2I0BbpqIrOUaHI+MJnklcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphakFsH0
	MXFwSjUwLvKQ/b/0fewZjRC+Nzv3PO94qOJgnM5jaPV/ktMU+++lmf90prq99Vdx2D7luOit
	h1wGAgtLnG8u8clK5fn9wPHogVeZPR4LFp3YW9v0neOLk9xti+Xt294s41y+Tthe3TpuurXZ
	lEPKGxh3vwn1X7lY+f3pTy4cB13VL2ya/3LF65OuB6JOnFFiKc5INNRiLipOBAABWdWg7gIA	AA==
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

