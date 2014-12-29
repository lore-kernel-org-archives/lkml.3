Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaL2AFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 19:05:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32506 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaL2AE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 19:04:28 -0500
X-AuditID: cbfee68e-f79b46d000002b74-95-54a09a87a7c5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv6 4/9] devfreq: event: Add documentation for exynos-ppmu
 devfreq-event driver
Date: Mon, 29 Dec 2014 09:04:08 +0900
Message-id: <1419811453-16160-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
References: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSoNs+a0GIwcUzvBaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6MtZOeMxX8lKlY+3M2ewNjj3gXIyeHhICJxLWFu9kgbDGJC/fWA9lcHEICSxkl
	vj89ydLFyAFWtOZXJkR8OqNE94O3LBBOE5NE4/n3jCDdbAJaEvtf3ACbJCIgI3F143awImaB
	RmaJL8v+M4EkhAXiJc4uPQtmswioSmy4/5INZAOvgKtEW5sixBUKEsuWz2QFsTkF3CT2nLjB
	DGILAZWc/3+QFWSmhMA9donjb26yQ8wRkPg2+RDUpbISmw4wQ8yRlDi44gbLBEbhBYwMqxhF
	UwuSC4qT0ouM9IoTc4tL89L1kvNzNzECo+f0v2d9OxhvHrA+xCjAwajEwzvh2PwQIdbEsuLK
	3EOMpkAbJjJLiSbnA2M0ryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGxvC+Uy/XxWudnWf/Z2v337qg7A0fpC+zJC+64/iBd+OGQB2FRUKfRc+qZup7
	Xmo+23Sh9l9c0Bw2h1/z/n5exyejcubelQkBq0oOsrD8YEpqlH6pFb3CYLLqxkzVTbNP9Bid
	yteO+7Jz0TelbRctpt3ac/f/8q0qZze8/d70L+auyBbTQ3z/djxUYinOSDTUYi4qTgQAan5i
	NJkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQd32WQtCDJ7eZ7F4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzFg76TlTwU+ZirU/Z7M3MPaIdzFycEgI
	mEis+ZXZxcgJZIpJXLi3nq2LkYtDSGA6o0T3g7csEE4Tk0Tj+feMIFVsAloS+1/cYAOxRQRk
	JK5u3A5WxCzQyCzxZdl/JpCEsEC8xNmlZ8FsFgFViQ33X7KBbOMVcJVoa1OE2KYgsWz5TFYQ
	m1PATWLPiRvMILYQUMn5/wdZJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHJvP
	pHcwrmqwOMQowMGoxMM74dj8ECHWxLLiytxDjBIczEoivEZlC0KEeFMSK6tSi/Lji0pzUosP
	MZoCHTWRWUo0OR+YNvJK4g2NTcyMLI3MDS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODil
	GhgzjkTtyxFt3m6vt0RLVbLx/MNE3vnT+rLmRaldin0rvr52msOa7ltmyw5umvHNZeLDpxn1
	TKsroyS7l/TWLAn6fJLThcty0ZuFMU2nmK/sDmfw4juVp964amrwce+r0gf+zrjFEvFdqj1z
	/nKVmiDZz4wVXHKu56c9f7BGdK1DacGdAydE/vUrsRRnJBpqMRcVJwIAuTnfV+MCAAA=
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

