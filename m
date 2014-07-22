Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaGVCFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:05:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13979 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaGVCFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:05:04 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-e1-53cdc6cd6609
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv8 4/4] ARM: dts: Fix wrong compatible string for Exynos3250 ADC
Date: Tue, 22 Jul 2014 11:04:56 +0900
Message-id: <1405994696-3117-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com>
References: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWyRsSkQPfssbPBBp+/2Vj8nXSM3eLu88OM
	Fte/PGe1mH/kHKvFg6ZVTBa9C66yWZxtesNusenxNVaLhW1LWCzmHXnHYnF51xw2ixnn9zFZ
	rJ/xmsWB1+P3r0mMHptWdbJ5bF5S79G3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZv1qusRR0
	cFUce/ORtYFxJUcXIyeHhICJRGvXM2YIW0ziwr31bF2MXBxCAksZJY7/2MkOU7Tm4xZmiMQi
	RokZDReZIJwmJok1t/+CVbEJaEnsf3GDDcQWERCRuHf6AyNIEbPAVSaJ7TvWgxUJC/hLPN01
	gQXEZhFQlbi9dD0riM0r4CKx9vQxNoh1chIf9jwCq+cUcJXYvfoMWL0QUM3Xu+fANksIHGKX
	2DjpMjPEIAGJb5MPARVxACVkJTYdgPpHUuLgihssExiFFzAyrGIUTS1ILihOSi8y1CtOzC0u
	zUvXS87P3cQIjJLT/5717mC8fcD6EGMy0LiJzFKiyfnAKMsriTc0NjOyMDUxNTYytzQjTVhJ
	nDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZC8zf3NvfeWzCNN//UUeOHe7KfbJsi
	MEd/xefjVZoZE4tqnqfvyteOsTaLYvu2kyeN7+7EVMMP57gsNhwpyJuxPd9YXqhM9PGt7MfV
	5RtXXtPhcp2oNk1PcvebysbdLGH/b8kLXNiv2z5Fr+fFscmif18vddZ9l3QmKYZbxP+DegB/
	U/Kj2GVKLMUZiYZazEXFiQB8SKhFqAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t9jAd2zx84GG3xpNrP4O+kYu8Xd54cZ
	La5/ec5qMf/IOVaLB02rmCx6F1xlszjb9IbdYtPja6wWC9uWsFjMO/KOxeLyrjlsFjPO72Oy
	WD/jNYsDr8fvX5MYPTat6mTz2Lyk3qNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZvxqucZS0MFVcezNR9YGxpUcXYycHBICJhJrPm5hhrDFJC7cW8/W
	xcjFISSwiFFiRsNFJginiUlize2/7CBVbAJaEvtf3GADsUUERCTunf7ACFLELHCVSWL7jvVg
	RcIC/hJPd01gAbFZBFQlbi9dzwpi8wq4SKw9fYwNYp2cxIc9j8DqOQVcJXavPgNWLwRU8/Xu
	OaYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH4DPpHYyrGiwOMQpwMCrx8E5Q
	PBssxJpYVlyZe4hRgoNZSYS3fQ9QiDclsbIqtSg/vqg0J7X4EKMp0FUTmaVEk/OB6SGvJN7Q
	2MTMyNLI3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVAOj0QXb9tL3Xs6G6kKzzxxd
	elA5IGq7ge0OHovM0u1vqhXyTySnWfdkCThwrXXQtnx7JS7gYWtXqX2KnN9XuWylnRHHX/2Z
	JLCVaelM0f5QHueInadUe6s0PfvO3WxNnJfQa8D5ppuvfmqqg8A6v5aUTaaV/60q9vTXTHF2
	sOrYGn7i0Ja7/5VYijMSDbWYi4oTAWgPYYLXAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix wrong compatible string for Exynos3250 ADC. Exynos3250 SoC
need to control only special clock for ADC. Exynos SoC except for Exynos3250
has not included special clock for ADC. The exynos ADC driver can control
special clock if compatible string is 'exynos3250-adc-v2'.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/exynos3250.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 15c9c87..767189a 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -407,10 +407,11 @@
 		};
 
 		adc: adc@126C0000 {
-			compatible = "samsung,exynos-adc-v3";
+			compatible = "samsung,exynos3250-adc",
+				     "samsung,exynos-adc-v2";
 			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
 			interrupts = <0 137 0>;
-			clock-names = "adc", "sclk_tsadc";
+			clock-names = "adc", "sclk";
 			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
 			#io-channel-cells = <1>;
 			io-channel-ranges;
-- 
1.8.0

