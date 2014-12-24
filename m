Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaLXFpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:45:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63636 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaLXFpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:45:42 -0500
X-AuditID: cbfee68d-f79296d000004278-c8-549a5300667a
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 2/4] ARM: dts: Add hsotg node for exynos3250
Date: Wed, 24 Dec 2014 14:45:31 +0900
Message-id: <1419399933-3707-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419399933-3707-1-git-send-email-jaewon02.kim@samsung.com>
References: <1419399933-3707-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWyRsSkWJcheFaIwbx2c4vrX56zWuxoOMJq
	0f/4NbPF5V1z2CxmnN/HZLFoWSuzxdojd9kd2D02repk8+jbsorR4/MmuQDmKC6blNSczLLU
	In27BK6Mw/OzCj6wVTxb1cHSwLiHtYuRk0NCwERi2a/LbBC2mMSFe+uBbC4OIYGljBKzfz9l
	72LkACta9NkFIr6IUeJV6xdGkAYhgTYmiWUzvUFsNgFtie/rF7OC1IsI+Ekse6kLUs8ssJ5R
	YseGW2ALhAXsJQ7eXQ82k0VAVWLaITOQMK+Au8Tbs9uYIFYpSMyZZAMS5hTwkHi69SDUJneJ
	n2sfsIKMlBDoZpd4fbEfbCSLgIDEt8mHWCB6ZSU2HWCGeEVS4uCKGywTGIUXMDKsYhRNLUgu
	KE5KLzLUK07MLS7NS9dLzs/dxAgM5dP/nvXuYLx9wPoQowAHoxIP74IzM0KEWBPLiitzDzGa
	Am2YyCwlmpwPjJi8knhDYzMjC1MTU2Mjc0szJXFeRamfwUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYg75Pj7lz+SjrjNR8w64299+KC6ymZfz2zpY9nlQZ3bpm3q6lqea9Ra1rpdQltVS7
	TB5NiDmp+3K6NseuEzbrIuZv3+rE1bu7KvRMq+KGSdfPcW4KEbQVVzHbJbjxQH2bUvrLRSrl
	c7nvzN5UcmaNycKbpTMcz/2MOZN0N+iE87xnWsu4/Iu0lFiKMxINtZiLihMBSolOjGACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jAV2G4FkhBt1TDSyuf3nOarGj4Qir
	Rf/j18wWl3fNYbOYcX4fk8WiZa3MFmuP3GV3YPfYtKqTzaNvyypGj8+b5AKYoxoYbTJSE1NS
	ixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAtisplCXmlAKFAhKL
	i5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMw7Pzyr4wFbxbFUHSwPjHtYuRg4OCQETiUWf
	XboYOYFMMYkL99azdTFycQgJLGKUeNX6hREkISTQxiSxbKY3iM0moC3xff1isF4RAT+JZS91
	QeqZBdYzSuzYcIsNpEZYwF7i4N317CA1LAKqEtMOmYGEeQXcJd6e3cYEsVZBYs4kG5Awp4CH
	xNOtB6E2uUv8XPuAdQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwZHyTHoH46oG
	i0OMAhyMSjy8C87MCBFiTSwrrsw9xCjBwawkwqtzY2aIEG9KYmVValF+fFFpTmrxIUZToJsm
	MkuJJucDozivJN7Q2MTMyNLI3NDCyNhcSZxXyb4tREggPbEkNTs1tSC1CKaPiYNTqoGxIvrR
	hz05HWEdXk4nmRTDz1m6rPzIs6qtKvWK74nXh0sYdvMZtz45/3id4Hr7w5/95p17I2p7Y5dj
	+Uz7GfnvNr3MmM5qp/y/KZ3/Zeiuee8Mzu1z6VRcElXadnVCLGex8a/3lgYTkwP2vUuc9u5o
	ZK1p3IH2k6s/ifrJ3TDeOSXW2YXPSItfiaU4I9FQi7moOBEATdJucaoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree node for hsotg to control USB 2.0 Device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 27d385f..204a84b 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -255,6 +255,17 @@
 			status = "disabled";
 		};
 
+		hsotg: hsotg@12480000 {
+			compatible = "snps,dwc2";
+			reg = <0x12480000 0x20000>;
+			interrupts = <0 141 0>;
+			clocks = <&cmu CLK_USBOTG>;
+			clock-names = "otg";
+			phys = <&exynos_usbphy 0>;
+			phy-names = "usb2-phy";
+			status = "disabled";
+		};
+
 		mshc_0: mshc@12510000 {
 			compatible = "samsung,exynos5250-dw-mshc";
 			reg = <0x12510000 0x1000>;
-- 
1.7.9.5

