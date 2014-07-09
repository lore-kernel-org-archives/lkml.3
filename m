Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaGIDAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:00:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16038 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaGIDA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:00:27 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-89-53bcb04af741
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux@arm.linux.org.uk, kgene.kim@samsung.com, t.figa@samsung.com
Cc: kyungmin.park@samsung.com, ideal.song@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2] ARM: dts: Add I2S dt node for Exynos3250
Date: Wed, 09 Jul 2014 12:00:19 +0900
Message-id: <1404874819-8257-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWyRsSkRNdrw55gg6u7ZS2uf3nOarHr731G
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8X6Ga9ZHDg9Wpp72Dw2L6n36NuyitHj
	8ya5AJYoLpuU1JzMstQifbsEroydmzayFrzmqpjxZxdLA+Nbji5GTg4JAROJafMusEHYYhIX
	7q0Hsrk4hASWMkos+PaFEaZoyYIjrBCJRYwS+xrXsUM4TUwSi37OYgapYhPQktj/4gbYKBEB
	V4llR1awgBQxCxxjlJj2uxksISxgLXGw6xJYA4uAqsSaayfBbF4BF4kf845C3SEn8WHPI7AN
	EgLN7BKrNyxlhWgQkPg2+RDQVA6ghKzEpgPMEPWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGp
	XnFibnFpXrpecn7uJkZgAJ/+92ziDsb7B6wPMSYDjZvILCWanA+MgLySeENjMyMLUxNTYyNz
	SzPShJXEedMfJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDzksZv5p8yRU4sv1AW8q07I
	nb1/b3TpwYN7y/eXXVc2/7wm5a5W+Ku4q6szDir+M7j/+qXR3oUaURlb3zxYJJV5bPkdSYm1
	j2IWmwjqGy9kj9uZy7r7heRimZx9Cwus3k16a7etPFnZs0pIf7/cj2ZpnyW/NI/EbeO3KPA7
	2PdmYVRqOcPZNZ+UWIozEg21mIuKEwFdW/yYdgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAV2vDXuCDe5eFLa4/uU5q8Wuv/cZ
	LXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3LvBbrZ7xmceD0aGnuYfPYvKTeo2/LKkaP
	z5vkAliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm7Ny0kbXgNVfFjD+7
	WBoY33J0MXJySAiYSCxZcIQVwhaTuHBvPVsXIxeHkMAiRol9jevYIZwmJolFP2cxg1SxCWhJ
	7H9xgw3EFhFwlVh2ZAULSBGzwDFGiWm/m8ESwgLWEge7LoE1sAioSqy5dhLM5hVwkfgx7ygb
	xDo5iQ97HrFPYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Pp5J72Bc1WBxiFGA
	g1GJh1eBZ0+wEGtiWXFl7iFGCQ5mJRHeb25AId6UxMqq1KL8+KLSnNTiQ4ymQNsnMkuJJucD
	YzevJN7Q2MTMyNLI3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVANjvGWY3/nXJyXt
	DPtCHW8/YOX4rN5wpUTpyFXv3XO1wnc3yeemBsZeWLbtz41Zvr8N3/EqnI1OfD9DyJY3dKWN
	m4VC5LqkaW/WJGv1dS8zNg6rbjvzU/Knbk6d+Kcp8ycpLp3DpvWee1PR+RP8Iuuc0299CpHe
	zhmZ8v6nC+e9r4FqNkm+l7YosRRnJBpqMRcVJwIAvJWQnaUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch add I2S (Inter-IC Sound) dt node which supports 1-port stereo
(1 channels) IIS-bus for audio interface with DMA-based operation.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Inha Song <ideal.song@samsung.com>
Tested-by: Inha Song <ideal.song@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes from v1:
- Fix wrong name of property (pinctrl-names)
- Change phanle name (i2s->i2s2)

 arch/arm/boot/dts/exynos3250.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 3e678fa..77a06df 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -425,6 +425,19 @@
 			status = "disabled";
 		};
 
+		i2s2: i2s@13970000 {
+			compatible = "samsung,s3c6410-i2s";
+			reg = <0x13970000 0x100>;
+			interrupts = <0 126 0>;
+			clocks = <&cmu CLK_I2S>, <&cmu CLK_SCLK_I2S>;
+			clock-names = "iis", "i2s_opclk0";
+			dmas = <&pdma0 14>, <&pdma0 13>;
+			dma-names = "tx", "rx";
+			pinctrl-0 = <&i2s2_bus>;
+			pinctrl-names = "default";
+			status = "disabled";
+		};
+
 		pwm: pwm@139D0000 {
 			compatible = "samsung,exynos4210-pwm";
 			reg = <0x139D0000 0x1000>;
-- 
1.8.0

