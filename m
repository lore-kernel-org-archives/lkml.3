Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaCKHzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:55:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45819 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaCKHzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:55:04 -0400
X-AuditID: cbfee690-b7f266d00000287c-21-531ec154307b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/5] ARM: dts: exynos: Add missing dt data to bring kernel of
 Exynos4x12
Date: Tue, 11 Mar 2014 16:54:49 +0900
Message-id: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSoBtyUC7YYPchGYvrX56zWsw/co7V
	4tyrlYwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei6XXLzJZTJi+lsXi8IoDTBav
	DraxWKyf8ZrFgc9jzbw1jB4tzT1sHgs+X2H3WLn8C5vH5iX1Hn1bVjF6fN4k57FxbmgARxSX
	TUpqTmZZapG+XQJXRteq98wFqzgrjv+Ib2A8y97FyMkhIWAicXPSW1YIW0ziwr31bF2MXBxC
	AksZJZat/sUIU/Ts3ntmiMQiRokbi2axQziNTBLzO86xgFSxCWhJ7H9xgw3EFhHQlZgy8w4r
	SBGzwH0miR/HV4ElhAWiJN6/ec4EYrMIqEq8PNsFdgevgKvEnauLoW6Sk/iw5xGUfYxd4tcr
	P4h6AYlvkw8BLeMAistKbDrADFEiKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6BUn5haX5qXr
	JefnbmIERsXpf88m7GC8d8D6EGMy0LiJzFKiyfnAqMoriTc0NjOyMDUxNTYytzQjTVhJnFft
	UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsY5QnnmTzOFt/kWyJ1/1Lt//j3laVunb7jD
	lhOQy1cXdqb/icGeFqb+bY9/hZrfufuzSTftV2WZoJH2i/Umx2c0aDWaBFjuFkm+YcP507Vl
	x4dlM+o92o8er216nmH5pnFV/cJJ8jJ89gtiVzEy/Gdp3xZod8Q5VZnf59qUz+Gf9G12ZW99
	ma/EUpyRaKjFXFScCAD6R/nMoAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd2Qg3LBBtt+C1lc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWh1ccYLJ4
	dbCNxWL9jNcsDnwea+atYfRoae5h81jw+Qq7x8rlX9g8Ni+p9+jbsorR4/MmOY+Nc0MDOKIa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZ0rXrPXLCKs+L4j/gGxrPsXYyc
	HBICJhLP7r1nhrDFJC7cW8/WxcjFISSwiFHixqJZ7BBOI5PE/I5zLCBVbAJaEvtf3GADsUUE
	dCWmzLzDClLELHCfSeLH8VVgCWGBKIn3b54zgdgsAqoSL892ga3jFXCVuHN1MdRqOYkPex6x
	T2DkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOOqeSe9gXNVgcYhRgINRiYd3hb9c
	sBBrYllxZe4hRgkOZiURXqe1QCHelMTKqtSi/Pii0pzU4kOMyUDbJzJLiSbnAxNCXkm8obGJ
	mZGlkbmhhZGxOWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUw2ropCe+JZV9XIG25pqlc
	tXzXk32Vi739r+1m2HRQNTaOOdMn88jupgP+rDY/Hme+nu2k9GhG/BodDkPRN1GzLlc3/wu4
	bKK4e6NlhbG55nL/5hPaGrWSV0Nb96/QEtnzxH3Vvgsv9GYc+Varv3q6+ESf9IiD/xpSP734
	2RHRxP18qpr0vmdMSizFGYmGWsxFxYkAuAwhlP4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add missing dt data of Exynos4x12 to bring up kernel feature and
code clean.

exynos4x12/exynos4412/exynos4212.dtsi
- Add ADC (Analog and Digital Converter) to get raw data
- Add PMU (Performance Monitoring Unit) for perf event
- Add gps_alive power domain to remove power leakage when gps-alive isn't used
- Remove duplicate dt data of interrput combiner controller

exynos4412-trats.dts
- Add ADC dt data with ntc thermistor child to read temperature

Chanwoo Choi (5):
  ARM: dts: exynos4x12: Add ADC's dt data to read raw data
  ARM: dts: exynos4x12: Add PMU dt data to support PMU(Perforamnce Monitoring Unit)
  ARM: dts: exynos4x12: Add GPS_ALIVE power domain
  ARM: dts: exynos: Move common dt data for interrupt combiner controller
  ARM: dts: exynos4412-trats2: Add ADC's dt data to get temperature of SoC/battery

 arch/arm/boot/dts/exynos4212.dtsi       | 13 ++++---------
 arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
 arch/arm/boot/dts/exynos4412.dtsi       | 14 ++++----------
 arch/arm/boot/dts/exynos4x12.dtsi       | 31 +++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 19 deletions(-)

-- 
1.8.0

