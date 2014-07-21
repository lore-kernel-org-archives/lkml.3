Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaGUCSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:18:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41198 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaGUCSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:18:01 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-ef-53cc785594b0
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com
Cc: arnd@arndb.de, kgene.kim@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv7 4/4] ARM: dts: Fix wrong compatible string for Exynos3250 ADC
Date: Mon, 21 Jul 2014 11:17:48 +0900
Message-id: <1405909068-22539-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
References: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsWyRsSkSDe04kywwfolQhZ/Jx1jt7j7/DCj
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLR40rWKy6F1wlc3ibNMbdotNj6+xWixsW8JiMe/IOxaL
	y7vmsFnMOL+PyWLp9YtMFhOmr2WxeHtnOotF694j7BbrZ7xmcRD2WDNvDaPH71+TGD0u9/Uy
	eaxc/oXNY/MKLY9NqzqBjCX1Hn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJWxctYHloJdnBWP
	z85ibWB8zd7FyMkhIWAisWzRJBYIW0ziwr31bF2MXBxCAksZJR7vO8ACU9Q98QZUYhGjRP/n
	78wQThOTxJFPS8BGsQloSex/AVLFySEioC0xYWEHWAezwBlmid62lWBFwgL+EgvnXGQGsVkE
	VCX2P1/ACGLzCrhKfNh6hw1inZzEhz2PwOo5Bdwk2h+3sYLYQkA1/ybdYQQZKiHQyiGx9/YU
	VohBAhLfJh8CupUDKCErsekAM8QcSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IUK84Mbe4NC9d
	Lzk/dxMjMA5P/3vWu4Px9gHrQ4zJQOMmMkuJJucD4zivJN7Q2MzIwtTE1NjI3NKMNGElcd6k
	h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhi1c27dYH4hbP313peHJjWGG+vN+jmqFOcI
	TDufdZDrLVeA75zmL/f3PeHbKhO07/LhXcF+OfPk//f9k12cX6PVxW3rz2B360DOEyW/yxk3
	RHqevsl8y+h850+1ry9LrndpwWojdvVVd3evmVPOe/y33ZlbytcEPoc8FJ3y9lrZQec1wv8P
	9IcqsRRnJBpqMRcVJwIAW1gPW9kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd3QijPBBtuaOC3+TjrGbnH3+WFG
	i+tfnrNazD9yjtWi/81CVotzr1YyWjxoWsVk0bvgKpvF2aY37BabHl9jtVjYtoTFYt6RdywW
	l3fNYbOYcX4fk8XS6xeZLCZMX8ti8fbOdBaL1r1H2C3Wz3jN4iDssWbeGkaP378mMXpc7utl
	8li5/Aubx+YVWh6bVnUCGUvqPfq2rGL0+LxJLoAzqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoKyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6
	viFBcD1GBmggYQ1jxspZH1gKdnFWPD47i7WB8TV7FyMnh4SAiUT3xBtsELaYxIV764FsLg4h
	gUWMEv2fvzNDOE1MEkc+LQHrYBPQktj/AqJDREBbYsLCDrAOZoEzzBK9bSvBioQF/CUWzrnI
	DGKzCKhK7H++gBHE5hVwlfiw9Q7UOjmJD3segdVzCrhJtD9uYwWxhYBq/k26wziBkXcBI8Mq
	RtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAofya9g3FVg8UhRgEORiUeXg/GM8FCrIllxZW5
	hxglOJiVRHhPZACFeFMSK6tSi/Lji0pzUosPMZoCXTWRWUo0OR+YgPJK4g2NTcyMLI3MDS2M
	jM2VxHkPtloHCgmkJ5akZqemFqQWwfQxcXBKNTDWPjEvmbiI1fjXJCG9SbM2yH1MPek8/6t/
	u7jpY7eyF5qH5nrzznlSMNfn4cMZqsek5vN9OBcmGs9q+SxwMsMvPY3rs0T9E+cumJMoM73V
	pCaDrff2rCmzDvFVtiZN9X2R9NDbhztLw3NGrWa44VZdnnntj96VtgfdKbyVWfqm5InsOaFX
	WolKLMUZiYZazEXFiQBKTq2+CAMAAA==
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
---
 arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 15c9c87..8ab1289 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -407,10 +407,10 @@
 		};
 
 		adc: adc@126C0000 {
-			compatible = "samsung,exynos-adc-v3";
+			compatible = "samsung,exynos3250-adc";
 			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
 			interrupts = <0 137 0>;
-			clock-names = "adc", "sclk_tsadc";
+			clock-names = "adc", "sclk";
 			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
 			#io-channel-cells = <1>;
 			io-channel-ranges;
-- 
1.8.0

