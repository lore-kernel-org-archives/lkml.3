Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbbAGOIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:08:35 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10368 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbbAGOIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:08:31 -0500
X-AuditID: cbfee68f-f791c6d000004834-5a-54ad3dda8f84
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND v2 2/4] ARM: dts: Add hsotg node for exynos3250
Date: Wed, 07 Jan 2015 23:08:19 +0900
Message-id: <1420639701-1524-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
References: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWyRsSkWPeW7doQg7fT1S2uf3nOarGj4Qir
	Rf/j18wWl3fNYbOYcX4fkwOrx6ZVnWwefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXF4flbB
	B7aKZ6s6WBoY97B2MXJwSAiYSNx4XNbFyAlkiklcuLeerYuRi0NIYCmjxL7Xx1kgEiYSc3Y+
	h0pMZ5SY/eo+E4TTxiRx8MJ1ZpAqNgFtie/rF4NNFRFQlNi8QAGkhllgEqPEjXsrWEFqhAXc
	JBZOWwI2lUVAVWLh7mYmEJtXwF1i+c8WdoiLFCTmTLIBCXMKeEjs/XOUEcQWAir58+wWK8hM
	CYH/bBJX735ghpgjIPFt8iEWiF5ZiU0HmCGOlpQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPWK
	E3OLS/PS9ZLzczcxAkP39L9n/TsY7x6wPsQowMGoxMNb0LcmRIg1say4MvcQoynQhonMUqLJ
	+cAIySuJNzQ2M7IwNTE1NjK3NFMS510o9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+PR
	Kyebf9Tw3GnQ27joiWu30/Opdw7oaLvMu2fjwBre8IBnh6Hmlzkvfnlvnxq9hJPFftXTq2vf
	Oezdf+OV4boFCROiNrDMLXWqMAkQ5/9n57TX6tspR8tMx595POuu3E29m8WwvvarzjuN/zpl
	Gis2n1L5FzdPVdEzK/KO11JOv/oN6V0b4/KVWIozEg21mIuKEwGyWGAVWAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jQd1btmtDDC68lLe4/uU5q8WOhiOs
	Fv2PXzNbXN41h81ixvl9TA6sHptWdbJ59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWPG4flZBR/YKp6t6mBpYNzD2sXIySEhYCIxZ+dzNghbTOLCvfVA
	NheHkMB0RonZr+4zQThtTBIHL1xnBqliE9CW+L5+MVA3B4eIgKLE5gUKIDXMApMYJW7cWwE2
	VVjATWLhtCUsIDaLgKrEwt3NTCA2r4C7xPKfLewgvRICChJzJtmAhDkFPCT2/jnKCGILAZX8
	eXaLdQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwbHxTGoH48oGi0OMAhyMSjy8
	BX1rQoRYE8uKK3MPMUpwMCuJ8L75BRTiTUmsrEotyo8vKs1JLT7EaAp01ERmKdHkfGDc5pXE
	GxqbmBlZGpkbWhgZmyuJ8yrZt4UICaQnlqRmp6YWpBbB9DFxcEo1MPInHN6e35K0fh37ooq8
	SzNrFG1PnDnCcCHN4W6B7qxu98VsV7cHuU19cfSX4931x8VEjNw2yL29lHyVqV/k/Ur55mvu
	6vsUP4nld9o7bysoOXZLSnab5f3lu1/7Os3S3Lcy7+if3idak6fNPat6ruR4Wdm0oP2uP98v
	3LQ3cfmDDemBwn8f3JNUYinOSDTUYi4qTgQALzpoaaMCAAA=
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

