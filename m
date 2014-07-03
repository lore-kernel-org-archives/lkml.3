Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaGCHw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:52:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58436 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaGCHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:52:25 -0400
X-AuditID: cbfee690-b7fb56d000003439-49-53b50bb656cd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux@arm.linux.org.uk, kgene.kim@samsung.com, t.figa@samsung.com
Cc: kyungmin.park@samsung.com, ideal.song@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] ARM: dts: Add I2S dt node for Exynos3250
Date: Thu, 03 Jul 2014 16:52:19 +0900
Message-id: <1404373939-10510-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkWHc799Zgg3c3mCyuf3nOarHr731G
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8X6Ga9ZHDg9Wpp72Dw2L6n36NuyitHj
	8ya5AJYoLpuU1JzMstQifbsErozz81ewF7RyVfy4sZytgXE2RxcjJ4eEgInEohvb2CFsMYkL
	99azdTFycQgJLGWUePF9HhNcUdd8ZojEdEaJ28+boZwmJonWydMZQarYBLQk9r+4wQZiiwi4
	Siw7soIFpIhZ4BijxLTfzWAJYQFLiSMfdwF1c3CwCKhK3P/uCxLmBarvfDOfEWKbnMSHPY+g
	Tmpml3jzG6yGRUBA4tvkQywgrRICshKbDjBDlEhKHFxxg2UCo+ACRoZVjKKpBckFxUnpRSZ6
	xYm5xaV56XrJ+bmbGIHBe/rfswk7GO8dsD7EmAw0biKzlGhyPjD480riDY3NjCxMTUyNjcwt
	zUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMWHqp13HL+26Ilt/emZegk0h
	x/uY+M53PuxNpzZvehKzcMHKkN73Rq0WnJfO5VZLXJ6gb9247uSZvT0soYu27F28631vtmpo
	es1br34PdzHflPmNcyLl9vhUfXrHrpWwSOj6xIhXGteNl7TN2rxng5htzL+2HUddA2Jfnkoz
	eLn2vPi8e8cm2ymxFGckGmoxFxUnAgDaGEQEdAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jQd1t3FuDDbrmmlpc//Kc1WLX3/uM
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZlXov1M16zOHB6tDT3sHlsXlLv0bdlFaPH
	501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUCnKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzzs9fwV7QylXx48Zy
	tgbG2RxdjJwcEgImEou65jND2GISF+6tZ+ti5OIQEpjOKHH7eTMzhNPEJNE6eTojSBWbgJbE
	/hc32EBsEQFXiWVHVrCAFDELHGOUmPa7GSwhLGApceTjLqBuDg4WAVWJ+999QcK8QPWdb+Yz
	QmyTk/iw5xH7BEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo+OZ9A7GVQ0WhxgF
	OBiVeHgd7LcEC7EmlhVX5h5ilOBgVhLhnb4ZKMSbklhZlVqUH19UmpNafIjRFGj5RGYp0eR8
	YOTmlcQbGpuYGVkamRtaGBmbK4nzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpgVC9x+y57e+2M
	lrtLFv7urZZoY4q6pyGolK24lTGjsDxwUol7EjNT/oed+k7TQtP4iydmGcgY/jvzkWWC24eY
	qdabOnqLT3a9mfg8N3jdAwnfcOGPW28ouR+yWtKycbt0UaBkxbslZcu3vFVmkzzephfsbZXw
	aNtxsXMSF7SOlp07PsfH69IjJZbijERDLeai4kQAhDN+BqQCAAA=
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
 arch/arm/boot/dts/exynos3250.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 1f8384f..e9017ef 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -644,6 +644,19 @@
 			status = "disabled";
 		};
 
+		i2s: i2s@13970000 {
+			compatible = "samsung,s3c6410-i2s";
+			reg = <0x13970000 0x100>;
+			interrupts = <0 126 0>;
+			clocks = <&cmu CLK_I2S>, <&cmu CLK_SCLK_I2S>;
+			clock-names = "iis", "i2s_opclk0";
+			dmas = <&pdma0 14>, <&pdma0 13>;
+			dma-names = "tx", "rx";
+			pinctrl-0 = <&i2s2_bus>;
+			pinctrl-name = "default";
+			status = "disabled";
+		};
+
 		pwm: pwm@139D0000 {
 			compatible = "samsung,exynos4210-pwm";
 			reg = <0x139D0000 0x1000>;
-- 
1.8.0

