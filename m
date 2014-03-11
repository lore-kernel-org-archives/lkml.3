Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaCKH4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:56:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45819 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaCKHzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:55:05 -0400
X-AuditID: cbfee68e-b7f566d000002344-c8-531ec156704a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/5] ARM: dts: exynos4x12: Add PMU dt data to support
 PMU(Perforamnce Monitoring Unit)
Date: Tue, 11 Mar 2014 16:54:51 +0900
Message-id: <1394524494-30641-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkUDfsoFywwc8nMhbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjigu
	m5TUnMyy1CJ9uwSujDcv37EVLOOsuH7rK2MD4xH2LkYODgkBE4nXEzO6GDmBTDGJC/fWs3Ux
	cnEICSxllPj1fQYzTM3ppwkQ8UWMEpP+PIQqamSSuN62mQmkm01AS2L/ixtsILaIgK7ElJl3
	WEGKmAXuM0n8OL4KLCEskCGxZ+J2ZhCbRUBV4tLfF2A2r4CrxJWDK5ggzpCT+LDnETuIzSng
	JvH09nJWEFsIqObLk5tMIEMlBB6xS/TO/cgEMUhA4tvkQywQp8pKbDrADDFHUuLgihssExiF
	FzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIjKLT/5717WC8ecD6EGMy0LiJzFKiyfnA
	KMwriTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxZ
	mguNG3R6790ylZx1JGPjtd12WyIbZwpdmttXe95VkX2d9LkpWx8rvfTV+qW2vrxs1fHF+r5z
	d6tf+iPIE833b1bL006xSTOmTdI6Zbu73vuM9NvM4veO+voGj5/M3GgUFv/+YK7eQk/tJxX9
	zb3Rm8z3/HrEc6+uz/bOubcyvmofJ+rFJmxQYinOSDTUYi4qTgQAlvFm2LgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgG7YQblgg10vRSyuf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDPevHzHVrCMs+L6ra+MDYxH2LsY
	OTgkBEwkTj9N6GLkBDLFJC7cW8/WxcjFISSwiFFi0p+HUE4jk8T1ts1MIFVsAloS+1/cYAOx
	RQR0JabMvMMKUsQscJ9J4sfxVWAJYYEMiT0TtzOD2CwCqhKX/r4As3kFXCWuHFzBBLFOTuLD
	nkfsIDangJvE09vLWUFsIaCaL09uMk1g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cT
	IzhKn0ntYFzZYHGIUYCDUYmHN8BXLliINbGsuDL3EKMEB7OSCK/TWqAQb0piZVVqUX58UWlO
	avEhxmSgqyYyS4km5wMTSF5JvKGxiZmRpZG5oYWRsTlpwkrivAdarQOFBNITS1KzU1MLUotg
	tjBxcEo1MF7i218p9XDjGuuX7I7XrFk5yt9mOCjfrPgk7WS/UNHJfe4uj+wT9YdjppWVL7Nd
	uN7N/ZNgVEBpSWLV+uPLJk5KLeZJDs8qDriyjjfsw1rmCTZipsf+Gcq9Zp36qa17plX8r4XL
	2r8GhXxYWV3Z46zRv+i4+I+DKsaLjzrW816ocdO7xnJohhJLcUaioRZzUXEiANMqRLoWAwAA
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
---
 arch/arm/boot/dts/exynos4x12.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 5a3e551..1ec77f6 100644
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

