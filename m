Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbbALMiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:38:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29238 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbbALMfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:35:06 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-3f-54b3bf75f472
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv8 4/9] devfreq: event: Add documentation for exynos-ppmu
 devfreq-event driver
Date: Mon, 12 Jan 2015 21:34:52 +0900
Message-id: <1421066097-26237-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
References: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSoFu6f3OIwYJbHBaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgylh0ewlLwXzZipud+5gbGNeLdzFycEgImEi87FbrYuQEMsUk
	Ltxbz9bFyMUhJLCUUeL9tR4miISJxPGfB5kgEosYJS7e/8wO4TQxSdzsvQhWxSagJbH/xQ02
	EFtEQE+i89gedhCbWeAPk0TTJhYQW1ggXuLeuVXMIDaLgKpE58wJYL28Aq4Si3Y+Z4HYpiCx
	bPlMVhCbU8BN4t3uNWwglwoB1dxYXw+yV0LgJbvEje61LBBzBCS+TT7EAvGNrMSmA8wQYyQl
	Dq64wTKBUXgBI8MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMB4Ov3v2YQdjPcOWB9iFOBg
	VOLhtZDaHCLEmlhWXJl7iNEUaMNEZinR5Hxg1OaVxBsamxlZmJqYGhuZW5opifO+lvoZLCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoHReOrPUBlRvW+LG91Mmrw/LuP/IxxwPl4vZ2ZDUlMU
	9x7/uFlrXkRH1ve63BaevfLXab6IIJNatj4NX7+Z7Uf1Zka2P96pMSnrT4qpc5PFRq61qxaF
	7l3xfl9iyxn5Q/XXrKPd7n14I+1YuzU3JPByoGsz915D71MmYh5C1x7flpKLfthsE6fEUpyR
	aKjFXFScCAACLHWXogIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAd2S/ZtDDGbNsLF4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMRbeXsBTMl6242bmP
	uYFxvXgXIyeHhICJxPGfB5kgbDGJC/fWs3UxcnEICSxilLh4/zM7hNPEJHGz9yJYFZuAlsT+
	FzfYQGwRAT2JzmN72EFsZoE/TBJNm1hAbGGBeIl751Yxg9gsAqoSnTMngPXyCrhKLNr5nAVi
	m4LEsuUzWUFsTgE3iXe71wDN5ABa5ipxY339BEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGC4/WZ1A7GlQ0WhxgFOBiVeHgtpDaHCLEmlhVX5h5ilOBgVhLhdS0DCvGmJFZWpRbl
	xxeV5qQWH2I0BTpqIrOUaHI+MJXklcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphak
	FsH0MXFwSjUwprk9E/s3/Vj3pv2nXr+yVz9YEpujFB4fuOtS8plts5Pmpq99/nHZXYcLRjF8
	wn4fHwux31A5tGV2vPi/tqdS2t4+fIZTlXwlHA+JKMpa+iSGKell/g59dvur7Pu1vQuMrSQY
	D3Qbvbsn9E+khedzj8nZhc8iJ/Lr3gmaNHmxg0rdy5gAswNtSizFGYmGWsxFxYkADAo1S+0C	AAA=
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

