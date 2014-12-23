Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaLWDSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:18:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63943 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaLWDSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:18:22 -0500
X-AuditID: cbfee68e-f79b46d000002b74-53-5498defb5292
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv5 4/9] devfreq: event: Add documentation for exynos-ppmu
 devfreq-event driver
Date: Tue, 23 Dec 2014 12:18:12 +0900
Message-id: <1419304697-14789-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSqPv73owQg/PXDS0er1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZayc9Zyr4KVOx9uds9gbGHvEuRk4OCQETiT+357JC2GISF+6tZ+ti5OIQEljK
	KHGyr5UNpujl5DOMEIlFjBLf1i5mgXCamCT+HvrKBFLFJqAlsf/FDbAOEQEZiasbt4MVMQs0
	Mkt8WfYfrEhYIF5i38PpLCA2i4CqxNZnC5lBbF4BV4lVk2cyQaxTkFi2fCbYTZwCbhJ/5j0F
	s4WAaiZ2XGcCGSohcItd4nofxFAWAQGJb5MPAQ3lAErISmw6wAwxR1Li4IobLBMYhRcwMqxi
	FE0tSC4oTkovMtIrTswtLs1L10vOz93ECIyg0/+e9e1gvHnA+hCjAAejEg/vz3MzQoRYE8uK
	K3MPMZoCbZjILCWanA+M07ySeENjMyMLUxNTYyNzSzMlcd4EqZ/BQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhilzv4v3rVQap3tFKVQvWMHPbdMc4ku2cXC4jy/f5munGyGxhnZDjZGiZy+
	petfaVueszTL3/HA95bBY7sAd/Pu5z/c/7bKBc3p9rFzNHkseVeGv+ThxrV9v3+cyxZ0m7Qt
	lONccnfkxD8CIq96PwZYh61eMz1496FPdxPL1uo1sFrcnPHdiFuJpTgj0VCLuag4EQDwHzQI
	mwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd3f92aEGGy/p2HxeM1iJovrX56z
	Wsw/co7VYtL9CSwWr18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVbt+sPowO+xZt4aRo+ds+6yeyze85LJY/OSeo++LasYPT5vkgtgi2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOllJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLF20nOmgp8yFWt/zmZvYOwR72Lk5JAQ
	MJF4OfkMI4QtJnHh3nq2LkYuDiGBRYwS39YuZoFwmpgk/h76ygRSxSagJbH/xQ02EFtEQEbi
	6sbtYEXMAo3MEl+W/QcrEhaIl9j3cDoLiM0ioCqx9dlCZhCbV8BVYtXkmUwQ6xQkli2fyQpi
	cwq4SfyZ9xTMFgKqmdhxnWkCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHx+Ux6
	B+OqBotDjAIcjEo8vAvOzAgRYk0sK67MPcQowcGsJMKr3goU4k1JrKxKLcqPLyrNSS0+xGgK
	dNVEZinR5Hxg6sgriTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCUamAs
	/nj1Tc4D91lrjLl+pB744caza2+Po0mjjvj3zp1bFrK8r3J9OynyJtuxGeHWnU8v3lbkebJZ
	MclGWHLDtHkz+L9cWSrsNknA41KG3r7Ft2yP2a8+eC6d55hO7qfmDzUPzV033HWPk5G7ULmt
	Q8vu4sdLehdeXD/r+6Aw5+nCW8z/1q1urltyXomlOCPRUIu5qDgRAEszLuDlAgAA
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

