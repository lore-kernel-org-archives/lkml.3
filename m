Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaCLGT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:19:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49505 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaCLGTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:19:22 -0400
X-AuditID: cbfee68e-b7f566d000002344-be-531ffc699687
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 2/5] ARM: dts: exynos4x12: Add PMU dt data to support
 PMU(Perforamnce Monitoring Unit)
Date: Wed, 12 Mar 2014 15:19:13 +0900
Message-id: <1394605156-7768-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkWDfzj3ywwdN1khbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvFq4NtLBbr
	Z7xmceD1WDNvDaNHS3MPm8fK5V/YPDYvqffo27KK0ePzJjmPjXNDA9ijuGxSUnMyy1KL9O0S
	uDLmXlrEWHCVs2JF2zuWBsZ37F2MnBwSAiYSb77NZoWwxSQu3FvP1sXIxSEksJRRYtrX6Sww
	RXu2L2aCSExnlJi7dxk7hNPIJHFg4Q82kCo2AS2J/S9ugNkiAroSU2beARvLLHCMSeLEVAcQ
	W1ggS+LRqwNgcRYBVYlL/78ydjFycPAKuEicfRQJsUxO4sOeR+wgYU4BV4kN85JBwkJAFcc/
	HoW65xK7xK3jChBTBCS+TT7EAlIuISArsekAM0SJpMTBFTdYJjAKL2BkWMUomlqQXFCclF5k
	pFecmFtcmpeul5yfu4kRGC2n/z3r28F484D1IcZkoHETmaVEk/OB0ZZXEm9obGZkYWpiamxk
	bmlGmrCSOO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgnGbtx6MwMO5SYIP/eaYKn
	5BFH7Qk3+RZdkJ6mv6inbUftpGMn2hMffXtYMXFuh6DojeMnmHsdnR4/bXzoe0VL0eXvAXPm
	1KDchkv2p8qUpb+0dsX7bJkdsGDSnKPvF5VYv9x24pDy0qmHcx7WXbGvMHJ98tz00ecT1wqM
	z/n96ZC33F/3vkpBiaU4I9FQi7moOBEAGslbBKwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jQd3MP/LBBn2HBCyuf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLVwfbWCzW
	z3jN4sDrsWbeGkaPluYeNo+Vy7+weWxeUu/Rt2UVo8fnTXIeG+eGBrBHNTDaZKQmpqQWKaTm
	JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
	wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMmHtpEWPBVc6KFW3vWBoY37F3MXJySAiYSOzZvpgJ
	whaTuHBvPVsXIxeHkMB0Rom5e5exQziNTBIHFv5gA6liE9CS2P/iBpgtIqArMWXmHVYQm1ng
	GJPEiakOILawQJbEo1cHwOIsAqoSl/5/Zexi5ODgFXCROPsoEmKZnMSHPY/YQcKcAq4SG+Yl
	g4SFgCqOfzzKMoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Gh8Jr2DcVWDxSFG
	AQ5GJR7ehZrywUKsiWXFlbmHGCU4mJVEeD+ChHhTEiurUovy44tKc1KLDzEmA900kVlKNDkf
	mCjySuINjU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGRx9VDim9/
	/GrPxsAwvqcvW2vL3sTlMVd4JYqKyLUqfDiRf+SrMePpR32zbd6tULq5SNLIfeLlbKck66Xe
	iZoLOAs2ZWtoNCs3slifVen09zDMDuM1r5q6+mqM/pF1VVtnHZTQPX2z7c9Mg/j184P3KX3b
	anHE/s8MuRVzXzSsPKrdayWpz6nEUpyRaKjFXFScCACgp3dtCgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM CPU has its own performance profiling unit(PMU, Perforamnce Monitoring Unit).
This patch add PMU dt data to support PMU which count cache hit and miss events.

PMU interrput list of Exynos4212
- <2 2> : INTG2[2] - PMUIRQ[0] for CPU0
- <3 2> : INTG3[2] - PMUIRQ[1] for CPU1

PMU interrput list of Exynos4412
- <2 2> : INTG2[2], PMUIRQ[0] for CPU0
- <3 2> : INTG3[2], PMUIRQ[1] for CPU1
- <18 2> : INTG18[2], PMUIRQ[2] : CPU2
- <19 2> : INTG19[2], PMUIRQ[3] : CPU3

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index eec1e30..a1e76ec 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -31,6 +31,12 @@
 		mshc0 = &mshc_0;
 	};
 
+	pmu {
+		compatible = "arm,cortex-a9-pmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>, <3 2>, <18 2>, <19 2>;
+	};
+
 	pd_isp: isp-power-domain@10023CA0 {
 		compatible = "samsung,exynos4210-pd";
 		reg = <0x10023CA0 0x20>;
-- 
1.8.0

