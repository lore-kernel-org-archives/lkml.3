Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3JJFqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:46:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61112 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3JJFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:45:54 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-5d-52563f100226
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv2 2/3] ARM: dts: exynos4212: Add missing clock for multi core
 timer
Date: Thu, 10 Oct 2013 14:45:35 +0900
Message-id: <1381383936-2627-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1381383936-2627-1-git-send-email-cw00.choi@samsung.com>
References: <1381383936-2627-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkWFfAPizI4MprM4v5R86xWpx7tZLR
	onfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma7H2yF12i6XXLzJZTJi+lsXi8IoDTBav
	DraxWKyf8ZrFgc9jzbw1jB4tzT1sHgs+X2H3WLn8C5vH5iX1Hn1bVjF6fN4k57FxbmgARxSX
	TUpqTmZZapG+XQJXxsn355kLPrJW3Jma1sD4lKWLkZNDQsBE4sn500wQtpjEhXvr2boYuTiE
	BJYySry4cI4Rpuj8+QssEInpjBLn5lxghXAamSQudNxnA6liE9CS2P/iBli7iEA7o8Tq1gVg
	LcwCPUwSj19vAlsiLBAqsX71FDCbRUBVYtWTmWCH8Aq4SEz9dxZqn5zEhz2P2EFsTgFXiQ9T
	FjCD2EJANct/tDCDDJUQuMcusfjYcxaIQQIS3yYfArI5gBKyEpsOMEPMkZQ4uOIGywRG4QWM
	DKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAiPp9L9n/TsY7x6wPsSYDDRuIrOUaHI+MBLz
	SuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAoniRu
	WfTYa/pTBu1osc3Lwi+muexvNZnlHCUrmcx/7N1a/4LsrA9hi107PLne2P5Py9m4on5O1rTJ
	W7o+ziz3O/pCdG55Usmih043HL9ufFL5PKaBSfb+1O2MfEKyN3yWJ9yUPnp0+qR7t5MuXPgq
	u7o1MbZpw+kPOdVpX9fZ7zi2rzEtTe66EktxRqKhFnNRcSIAicFfQroCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xoK6AfViQwYt7uhbzj5xjtTj3aiWj
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12LtkbvsFkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjqgG
	RpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLOVFMoS
	c0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBkn359nLvjIWnFnaloD41OWLkZO
	DgkBE4nz5y9A2WISF+6tZ+ti5OIQEpjOKHFuzgVWCKeRSeJCx302kCo2AS2J/S9ugFWJCLQz
	SqxuXcAC4jAL9DBJPH69iQmkSlggVGL96ilgNouAqsSqJzPBdvAKuEhM/XeWEWKfnMSHPY/Y
	QWxOAVeJD1MWMIPYQkA1y3+0ME9g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhO
	n0nvYFzVYHGIUYCDUYmHt6IsNEiINbGsuDL3EKMEB7OSCO/0k0Ah3pTEyqrUovz4otKc1OJD
	jMlAV01klhJNzgemkLySeENjEzMjSyNzQwsjY3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi
	4JRqYKy8dJ3Dp+d+fOGaG6uN/piwsjSpc72rW7hFJ4ttbe5x+fsJTV/CvwpHabCtc+Or7C6V
	lb7uIKMn+2Cp0dqD4XPTnzmp1ljkHZw8e+bV1p1JX27OW+kV4K/Qnj45Q6Q/ddOsILFjHsfl
	F+yU+BaeNDWb4zGz9YPmaGXt1E+dn3a4shyK6v3qrsRSnJFoqMVcVJwIAIJqFpkXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
- No change

 arch/arm/boot/dts/exynos4212.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 3081bae..d7a3fbc 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
@@ -43,6 +43,8 @@
 		interrupt-parent = <&mct_map>;
 		interrupts = <0 0>, <1 0>, <2 0>, <3 0>,
 			     <4 0>, <5 0>;
+		clocks = <&clock 3>, <&clock 344>;
+		clock-names = "fin_pll", "mct";
 
 		mct_map: mct-map {
 			#interrupt-cells = <2>;
-- 
1.8.0

