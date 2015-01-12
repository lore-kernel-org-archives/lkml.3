Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbbALMgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:36:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29238 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbALMfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:35:07 -0500
X-AuditID: cbfee68e-f79b46d000002b74-7b-54b3bf750ad6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv8 8/9] ARM: dts: exynos: Add PPMU node to Exynos3250-based
 Rinato/Monk board
Date: Mon, 12 Jan 2015 21:34:56 +0900
Message-id: <1421066097-26237-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
References: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSqFu6f3OIwY7lYhaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgypjQtYClYJ9QxanrZg2Mr/m6GDk5JARMJPZ/aWeBsMUkLtxb
	z9bFyMUhJLCUUaL/y3NGmKKVZ/azQiQWMUo0vm1igXCamCQeH5jMDlLFJqAlsf/FDTYQW0RA
	T6Lz2B6wOLPAHyaJpk1gK4QF4iSOLd0BVMPBwSKgKtF+hgMkzCvgKrFz0wtmiGUKEsuWz2QF
	sTkF3CTe7V4DVi4EVHNjfT3IWgmBR+wSn07vA6thERCQ+Db5EAtIjYSArMSmA1BjJCUOrrjB
	MoFReAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwGg6/e9Z3w7GmwesDzEKcDAq8fBa
	SG0OEWJNLCuuzD3EaAq0YSKzlGhyPjBm80riDY3NjCxMTUyNjcwtzZTEeROkfgYLCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYIzW8ni0SrB168d3l2d9VftmnPzork1ilNjjJuv9jKri58Si
	J8u+SSqqqKq+sJbVK33mpEobl2kquknadRtFzORZNqgunSrKPuFWuEC91auvty/zGHEVX7iz
	4aHK7uMSV6puKVkfmeNUd3dORx2jwsSPkXZyBw7b+ippX72lm3H329rbL7Zq3VViKc5INNRi
	LipOBAAtP6JooQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t9jAd3S/ZtDDNZ+5LV4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMCV0LWAr2CVWcum7W
	wPiar4uRk0NCwERi5Zn9rBC2mMSFe+vZuhi5OIQEFjFKNL5tYoFwmpgkHh+YzA5SxSagJbH/
	xQ02EFtEQE+i89gesDizwB8miaZNLCC2sECcxLGlO4BqODhYBFQl2s9wgIR5BVwldm56wQyx
	TEFi2fKZYIs5Bdwk3u1eA1YuBFRzY339BEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNz
	NzGCY/WZ9A7GVQ0WhxgFOBiVeHgtpDaHCLEmlhVX5h5ilOBgVhLhdS0DCvGmJFZWpRblxxeV
	5qQWH2I0BbppIrOUaHI+MI3klcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphakFsH0
	MXFwSjUwCuy8nHfPbYKRy8k2nu/ufwuXu1W/vz5lZ/HuuLAFDlaTpjyqVo1s3eJ55Yv5pzip
	hJVq7dz5PBGT3qxjL7FjqJMQub+MM6/vncXl1R6xKxgLlvYeZVlrpyOyaEHcpJ0XPLPXTCtN
	nLN/XeP5BWv+hJlrrup7J3JVY7FT5DQ3IalzT2wbnhz7pcRSnJFoqMVcVJwIAJulqRHrAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU dt node to Exynos3250-base Rinato/Monk board. The PPMU node
is used to get the utilization of DMC0/DMC1/LEFTBUS/RIGHTBUS Block.

Cc: Kukjin Kim <kgene@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts   | 40 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts | 40 +++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 24822aa..fcceb59 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -420,6 +420,46 @@
 	status = "okay";
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 7cc52b5..9dd1ce1 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -595,6 +595,46 @@
 	status = "okay";
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

