Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbaLLI3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:29:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38563 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759850AbaLLI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:27:52 -0500
X-AuditID: cbfee691-f79b86d000004a5a-5b-548aa6f6d013
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: kgene.kim@samsung.com, rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv3 4/7] devfreq: event: Add documentation for exynos-ppmu
 devfreq-event driver
Date: Fri, 12 Dec 2014 17:27:29 +0900
Message-id: <1418372852-12454-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
References: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkUPfbsq4Qg8uTBS0er1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZWz4
	+5GxYLpoxfvJ19kaGDcLdjFyckgImEhsWPGdFcIWk7hwbz1bFyMXh5DAUkaJlVPbmbsYOcCK
	lu71gYgvYpS43XofqqiJSeLcrP3MIN1sAloS+1/cYAOxRQTMJXYt/QlWxCxwiUli+8weJpCE
	sECyxJQDjYwgNouAqsT7o1PYQWxeAVeJ/Q/vM0KcoSCxbPlMsJM4BdwkXlzdwAhyhRBQzc8l
	dSAzJQTOsUssuTqFFWKOgMS3yYdYIC6Vldh0gBlijKTEwRU3WCYwCi9gZFjFKJpakFxQnJRe
	ZKpXnJhbXJqXrpecn7uJERgpp/89m7iD8f4B60OMAhyMSjy8L1K7QoRYE8uKK3MPMZoCbZjI
	LCWanA+Mx7ySeENjMyMLUxNTYyNzSzMlcV4d6Z/BQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhgP3ZnksXWd4iT2qXGlJ1PtfC+t0/sRm9WTZObVdap5tre/pq32j+MF50TNuxitpjxoCK39
	LxKTmd22cQ/vVb09yqK2PRc+TNN6tMP+1ruJj7krFiXb528U6mOZFjfJ78zZx39WxCf47zS+
	FX7mFUvFSYsHRV7HlCUTmJxd3/971+522Xpl/WQlluKMREMt5qLiRADl+9ujjwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t9jAd1vy7pCDJ7+4LB4vGYxk8XGGetZ
	La5/ec5qMf/IOVaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWtxtXsFk8
	XvGW3WLVrj+MDnweO2fdZfdYvOclk8fmJfUefVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SokkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjFjw9+PjAXTRSveT77O1sC4WbCLkYNDQsBEYuleny5GTiBT
	TOLCvfVsXYxcHEICixglbrfeh3KamCTOzdrPDFLFJqAlsf/FDTYQW0TAXGLX0p9gRcwCl5gk
	ts/sYQJJCAskS0w50MgIYrMIqEq8PzqFHcTmFXCV2P/wPiPEOgWJZctnsoLYnAJuEi+ubmAE
	uUgIqObnkroJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH4TOpHYwrGywOMQpw
	MCrx8L5I7QoRYk0sK67MPcQowcGsJML7NwooxJuSWFmVWpQfX1Sak1p8iNEU6KiJzFKiyfnA
	FJFXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cAo2s7wg1OvYJX2
	k8eHmx8fVr1lzyirUFpYo5zMlhp7OunR05P2tw+dv7heSiZ9Y/Du1OolegoxejseO5//U/B+
	gaXz8zeBuS/v9lmZqudYNM01j2da/OT3h8qrzrNFP3EHuLho6qpvtmN+plz3qSVpysoJ/B4W
	pWFFPuesC2r4D+tM+bhwW6YSS3FGoqEWc1FxIgAeZDvJ2QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the documentation for Exynos PPMU (Performance Profiling
Monitoring Unit) devfreq-event driver.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 .../bindings/devfreq/event/exynos-ppmu.txt         | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt

diff --git a/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
new file mode 100644
index 0000000..f7e50e5
--- /dev/null
+++ b/Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
@@ -0,0 +1,56 @@
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
+Example : Examples of PPMU nodes are listed below.
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
-- 
1.8.5.5

