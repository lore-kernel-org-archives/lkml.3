Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875AbbAUF64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:58:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38027 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbbAUF6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:58:52 -0500
X-AuditID: cbfee691-f79b86d000004a5a-f1-54bf401acc24
From: Inha Song <ideal.song@samsung.com>
To: kgene@kernel.org, linux-samsung-soc@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Inha Song <ideal.song@samsung.com>
Subject: [PATCH] ARM: dts: exynos5422-odroidxu3: add sound nodes
Date: Wed, 21 Jan 2015 14:58:43 +0900
Message-id: <1421819923-27575-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWyRsSkUFfKYX+IweFtUhbzj5xjteh/s5DV
	Ytff+4wW516tZLTof/ya2WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYtF694j7A48
	HmvmrWH0aGnuYfO43NfL5LFy+Rc2j02rOtk8Ni+p9+jbsorR4/MmuQCOKC6blNSczLLUIn27
	BK6MYzub2AvOc1f0/rnG2MC4l7OLkZNDQsBE4smRs+wQtpjEhXvr2UBsIYGljBLTV8fD1Gz7
	8oWpi5ELKD6dUeLH+ReMEM4cJoneKQuZQarYBDQkvn/eDGaLCJhLdDXNZQYpYhaYziTR3/Ec
	LCEs4CAx4fARJhCbRUBV4ujab0DrODh4BdwkFj1JhNimLbGvYSYbSK+EwDZ2iZUnb7BA1AtI
	fJt8iAWkXkJAVmLTAWaIekmJgytusExgFFzAyLCKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cT
	IzAGTv97NnEH4/0D1ocYBTgYlXh4XyjuDxFiTSwrrsw9xGgKtGEis5Rocj4w0vJK4g2NzYws
	TE1MjY3MLc2UxHl1pH8GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCcc+yS0JdDxjkZgTNF
	Jtaz6gUV8K56cXcVb4lH0d5ZOScdVrw9XPnZVcF7077asEs/H02qyAs5tLo42IF9X7HQSQWz
	w1z8FVluH9Z/mjFLxCrg62qebifrVT1vA+zZ+1byq5fNfbzGufvTRoUre+c9Y/C2+VXN0akZ
	GOsewvju12wG6ar1rvOVWIozEg21mIuKEwFztKT6fAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQV0ph/0hBg96RSzmHznHatH/ZiGr
	xa6/9xktzr1ayWjR//g1s8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaL1r1H2B14
	PNbMW8Po0dLcw+Zxua+XyWPl8i9sHptWdbJ5bF5S79G3ZRWjx+dNcgEcUQ2MNhmpiSmpRQqp
	ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA1yoplCXmlAKFAhKLi5X0
	7TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM47tbGIvOM9d0fvnGmMD417OLkZODgkBE4ltX74w
	QdhiEhfurWfrYuTiEBKYzijx4/wLRghnDpNE75SFzCBVbAIaEt8/bwazRQTMJbqa5jKDFDEL
	TGeS6O94DpYQFnCQmHD4CNhYFgFViaNrvwGN5eDgFXCTWPQkEWKbtsS+hplsExi5FzAyrGIU
	TS1ILihOSs810itOzC0uzUvXS87P3cQIjrFn0jsYVzVYHGIU4GBU4uF9obg/RIg1say4MvcQ
	owQHs5IIr6IEUIg3JbGyKrUoP76oNCe1+BCjKdDyicxSosn5wPjPK4k3NDYxM7I0Mje0MDI2
	VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpgXMafnHxZ9M3RhZLKDz85BK/y5Hob8PrGXCPe
	4EoGjk2qruzn1n68+/66eF9otZ6Y1zQH3qVTXzYq/DI/fUPq1Tr2vdJv3z5J+BZt5/glI2Bj
	/qXF89U7Vz0xTF517vIV5mXbdyuZOTxrl+p4Vnb6gb6Q1O1z039GtFSWTBOfZ9npr1Fae/zR
	ZyWW4oxEQy3mouJEAFAD5w3HAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAX98090 audio codec, I2S interface and the sound nodes to support
audio on Odroid-XU3 board.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 arch/arm/boot/dts/exynos5422-odroidxu3.dts | 34 ++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3.dts b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
index 7874da2..79493d1 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
@@ -310,6 +310,40 @@
 	rtc@101E0000 {
 		status = "okay";
 	};
+
+	sound: sound {
+		compatible = "samsung,odroidu3-audio";
+		samsung,model = "Odroid-XU3";
+		samsung,i2s-controller = <&i2s0>;
+		samsung,audio-codec = <&max98090>;
+		assigned-clocks = <&clock_audss EXYNOS_MOUT_AUDSS>,
+				  <&clock_audss EXYNOS_MOUT_I2S>;
+		assigned-clock-parents = <&clock CLK_FIN_PLL>,
+				<&clock_audss EXYNOS_MOUT_AUDSS>;
+		samsung,audio-routing =
+			"Headphone Jack", "HPL",
+			"Headphone Jack", "HPR",
+			"Headphone Jack", "MICBIAS",
+			"IN1", "Headphone Jack",
+			"Speakers", "SPKL",
+			"Speakers", "SPKR";
+	};
+};
+
+&hsi2c_5 {
+	status = "okay";
+	max98090: max98090@10 {
+		compatible = "maxim,max98090";
+		reg = <0x10>;
+		interrupt-parent = <&gpx3>;
+		interrupts = <2 0>;
+		clocks = <&clock_audss EXYNOS_DOUT_AUD_BUS>;
+		clock-names = "mclk";
+	};
+};
+
+&i2s0 {
+	status = "okay";
 };
 
 &hdmi {
-- 
2.0.0.390.gcb682f8

