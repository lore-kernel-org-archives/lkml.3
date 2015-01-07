Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbbAGXwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:52:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14015 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbbAGXv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:51:26 -0500
X-AuditID: cbfee68e-f79b46d000002b74-b8-54adc67807b4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv7 05/10] devfreq: event: Add documentation for exynos-ppmu
 devfreq-event driver
Date: Thu, 08 Jan 2015 08:51:12 +0900
Message-id: <1420674677-3077-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
References: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWyRsSkSLfi2NoQgzMP2S0er1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlbF20nOmgp8yFWt/zmZvYOwR72Lk5JAQMJF49nseG4QtJnHh
	3nogm4tDSGApo8S/KT/YYYrmrX/OApFYxChx8sBldginiUli6uIZYFVsAloS+1/cABslIqAn
	0XlsD1icWeAPk0TTJhYQW1ggUWJJ90awOIuAqsSCxklgNq+Ai8Tek2+YIbYpSCxbPpMVxOYU
	cJVYunkhWFwIqOZlzy9GkMUSAo/YJX4fnw01SEDi2+RDQAs4gBKyEpsOQM2RlDi44gbLBEbh
	BYwMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECY+r0v2d9OxhvHrA+xCjAwajEw1vYtyZE
	iDWxrLgy9xCjKdCGicxSosn5wMjNK4k3NDYzsjA1MTU2Mrc0UxLnTZD6GSwkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBUdX2W4bwklx9TYGoz2+i57zvu7m5Lffm9QNtPBMfilyxXMHvE/1x
	Xg9XPM+zSX8k1isdesqVe1iGX//CvUmVE9ndUxcfmXFbqlXk5j7WRblzLaQPaDe0bzQ68/rr
	1rOcwb0pMw23xaq9Pliq/1lLRSyzYuFHl+CYy4uXan8tVPUJVyhXP8wfqMRSnJFoqMVcVJwI
	ACSDQF6kAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd3yY2tDDJ5ut7Z4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMtZOeMxX8lKlY+3M2
	ewNjj3gXIyeHhICJxLz1z1kgbDGJC/fWs3UxcnEICSxilDh54DI7hNPEJDF18Qx2kCo2AS2J
	/S9usIHYIgJ6Ep3H9oDFmQX+MEk0bQKbJCyQKLGkeyNYnEVAVWJB4yQwm1fARWLvyTfMENsU
	JJYtn8kKYnMKuEos3bwQLC4EVPOy5xfjBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNz
	NzGCI/aZ9A7GVQ0WhxgFOBiVeHgL+taECLEmlhVX5h5ilOBgVhLhXdu2NkSINyWxsiq1KD++
	qDQntfgQoynQVROZpUST84HJJK8k3tDYxMzI0sjc0MLI2FxJnFfJvi1ESCA9sSQ1OzW1ILUI
	po+Jg1OqgZG7qEQz1/PNcousmxWd82Ml1xm8V95kfq1pz8mexU/mdEzP3ZbhoMTkcse0ZdWT
	6SmLz/3+y2FXYuOVvf6EVFiZt9wdE5vsS88deksF5s/vlTpyb7GdklmOzGShdvWvsYfzJ7mf
	clc09lHzqqz5t9P0c3Ri+C7nX0+ncGfYiDNMO6ZfeCdHQomlOCPRUIu5qDgRAAa5ma3uAgAA
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
---
 .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++++++++++++++++++
 1 file changed, 110 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt

diff --git a/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
new file mode 100644
index 0000000..e665d30
--- /dev/null
+++ b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
@@ -0,0 +1,110 @@
+
+* Samsung Exynos PPMU (Performance Profiling Monitoring Unit) device
+
+The Samsung Exynos SoC have PPMU (Performance Profiling Monitoring Unit) for
+each IPs. PPMU provides the primitive values to get performance data. These
+events provide useful information about the behavior of the SoC that you can
+use when analyzing system performance, and made visible and can be counted
+using login in each IP (DMC, CPU, RIGHTBUS, LEFTBUS, CAM interface, LCD, G3D,
+MFC). The Exynos PPMU driver use the devfreq-event class to provide event data
+to various devfreq device. The devfreq device would use the event data when
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

