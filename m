Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3JJFqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:46:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61112 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3JJFpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:45:55 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-63-52563f11d81b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 3/3] ARM: dts: exynos4x12: Add maudio/gps_alive power domain
 for exynos4x12
Date: Thu, 10 Oct 2013 14:45:36 +0900
Message-id: <1381383936-2627-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1381383936-2627-1-git-send-email-cw00.choi@samsung.com>
References: <1381383936-2627-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkWFfQPizIoLNX2eL6l+esFvOPnGO1
	OPdqJaNF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7K4fZnXYun1i0wWE6avZbE4vOIAk8Wr
	g20sFutnvGZx4PNYM28No0dLcw+bx4LPV9g9Vi7/wuaxeUm9R9+WVYwenzfJeWycGxrAEcVl
	k5Kak1mWWqRvl8CV8XzqMfaCy+wV3dMaWBoYN7N1MXJySAiYSFzqesIMYYtJXLi3HijOxSEk
	sJRRouvGRmaYoteHXrFDJKYzShzb+wgsISTQyCTR+sAbxGYT0JLY/+IGWLeIQDujxOrWBSwg
	DrNAK5PE1S27wDqEBeIlrtx8wARiswioSiz+eJcFxOYVcJHY2jiJHWKdnMSHPY/AbE4BV4kP
	UxZAbXORWP6jBeqke+wS/1+zQcwRkPg2+RDQHA6guKzEpgNQJZISB1fcYJnAKLyAkWEVo2hq
	QXJBcVJ6kbFecWJucWleul5yfu4mRmAcnf73rH8H490D1ocYk4HGTWSWEk3OB8ZhXkm8obGZ
	kYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYM2su2TPkeDxx
	mcFz7FjF90fyPus872q9YuLfL3mMyW7jrHdFN5k2pgWovtl/8mz08eAfO+16bldw806pEOp6
	vMtmS0uBusBSA6ubT3uWHDqrccds7/Jzu5qN6qMCw1k2mFW7WXCeTokWFBeafN7gQbw/p9bz
	+Hy3Gwsam5Zs0N+m8e+ex4tvSizFGYmGWsxFxYkAxnKv4LkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xoK6gfViQwcNWGYvrX56zWsw/co7V
	4tyrlYwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei6XXLzJZTJi+lsXi8IoDTBav
	DraxWKyf8ZrFgc9jzbw1jB4tzT1sHgs+X2H3WLn8C5vH5iX1Hn1bVjF6fN4k57FxbmgAR1QD
	o01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0NlKCmWJ
	OaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoznU4+xF1xmr+ie1sDSwLiZrYuR
	k0NCwETi9aFX7BC2mMSFe+uB4lwcQgLTGSWO7X3EDJIQEmhkkmh94A1iswloSex/cQOsSESg
	nVFidesCFhCHWaCVSeLqll1gHcIC8RJXbj5gArFZBFQlFn+8ywJi8wq4SGxtnAS1Tk7iw55H
	YDangKvEhykLoLa5SCz/0cI8gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgOH0m
	vYNxVYPFIUYBDkYlHt6KstAgIdbEsuLK3EOMEhzMSiK8008ChXhTEiurUovy44tKc1KLDzEm
	A101kVlKNDkfmELySuINjU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNT
	qoFRtYUvbto0thdzE8Qe2SdV3f8Vs2HKlX1Hlcv8jHq2LBR2CTf0rIoSPdg9QWSbmcXLM/dP
	HFFme3HiqcE87zxvsaZ3c4rkz6aYPlQW/Tgvq/ti4voPC9LWpHFoBy92LztT4Rd6eirLyfkz
	non93HLpiv/M/mNXhLOLM1j37P8cnt8kwSkuLGCsxFKckWioxVxUnAgADumoUBcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch maudio/gps_alive power domain to exynos4x12.dtsi.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
- Fix GPS_ALIVE power domain's register address

 arch/arm/boot/dts/exynos4x12.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index ad531fe..d265047 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -35,6 +35,16 @@
 		reg = <0x10023CA0 0x20>;
 	};
 
+	pd_maudio: maudio-power-domain@10023CC0 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023CC0 0x20>;
+	};
+
+	pd_gps_alive: gps-alive-power-domain@10023D00 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023D00 0x20>;
+	};
+
 	clock: clock-controller@10030000 {
 		compatible = "samsung,exynos4412-clock";
 		reg = <0x10030000 0x20000>;
-- 
1.8.0

