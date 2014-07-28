Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaG1Mog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:44:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38565 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaG1MoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:44:13 -0400
X-AuditID: cbfee691-b7f306d000003d81-27-53d64596beee
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, heiko@sntech.de, knaack.h@gmx.de,
        t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 3/3] dt-bindings: samsung: exynos_adc: Remove un-necessary
 white-sapce
Date: Mon, 28 Jul 2014 21:44:02 +0900
Message-id: <1406551442-15186-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1406551442-15186-1-git-send-email-cw00.choi@samsung.com>
References: <1406551442-15186-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkWHea67Vgg9WXtS3+TjrGbnH3+WFG
	i+tfnrNazD9yjtXi/6PXrBYPmlYxWfQuuMpmsev/G2aLs01v2C02Pb7GarGwbQmLxbwj71gs
	Lu+aw2Yx4/w+Jov1M16zOPB7/P41idHjw8c4j02rOtk8Ni+p9+jbsorRY/u1ecwenzfJBbBH
	cdmkpOZklqUW6dslcGXc/TKLpWAyR8Xd88vZGhg/sHUxcnJICJhInN7yjB3CFpO4cG89UJyL
	Q0hgKaPEtWf/GWGKDv3vY4ZILGKU+L2sB6xbSKCJSeLK8SIQm01AS2L/ixtgcREBEYl7pz+A
	NTML/GSS2PEUrEZYIEpi8qEprF2MHBwsAqoSnWsyQExeAVeJpdeNIVbJSXzY8wjsHk4BN4k1
	O7ayQ2xylfi0qJMd5AQJgXvsElNvtLCCJFgEBCS+TT7EAjJHQkBWYtMBZog5khIHV9xgmcAo
	vICRYRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYAyd/vds4g7G+wesDzEmA42byCwlmpwP
	jMG8knhDYzMjC1MTU2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBU
	OW/P03Pm2ZEI1j7fQ9t15r68vVPo9UfDGtbvhzIyFOefWxT991JeZkTntpOT18+7lnMqrHip
	icOL20EiB19sMswWrZho+Yr98omjNya4uHgvuHgqSbdmmqbPZJ89f3eKP7ViCTXq/5XeET9r
	Dc8pa6YFtn2MHF+sHCYe2xUdb/xm67yviyLnKLEUZyQaajEXFScCAC9aV+q3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAd1prteCDd7fU7H4O+kYu8Xd54cZ
	La5/ec5qMf/IOVaL/49es1o8aFrFZNG74Cqbxa7/b5gtzja9YbfY9Pgaq8XCtiUsFvOOvGOx
	uLxrDpvFjPP7mCzWz3jN4sDv8fvXJEaPDx/jPDat6mTz2Lyk3qNvyypGj+3X5jF7fN4kF8Ae
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0t5JC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4+6XWSwFkzkq7p5fztbA+IGt
	i5GTQ0LAROLQ/z5mCFtM4sK99UBxLg4hgUWMEr+X9YAVCQk0MUlcOV4EYrMJaEnsf3EDLC4i
	ICJx7/QHRhCbWeAnk8SOp2A1wgJREpMPTWHtYuTgYBFQlehckwFi8gq4Siy9bgyxSk7iw55H
	7CA2p4CbxJodW9khNrlKfFrUyT6BkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOAI
	fSa1g3Flg8UhRgEORiUeXovgq8FCrIllxZW5hxglOJiVRHitna4FC/GmJFZWpRblxxeV5qQW
	H2I0BbppIrOUaHI+MHnklcQbGpuYGVkamRtaGBmbK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+Lg
	lGpg3Pp/Q1pLpUiieYabq6/pbQsvJ5feXH7BKimWxgcrtZxjdnUeKg3+NGfNWZYfd8VEIvql
	1qS9uLHw8696n+h6p/KlT/9vLPu15+XSnZ9vtCn88lDnzuQ0j8n2Uaqb/dm/fXFGrq6r7zMz
	Ma3wVUVSrmciNu5krmR9KTdjTvK87+FTd2q/+LRWiaU4I9FQi7moOBEA/SD2EOYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove un-necessary white-sapce to code clean.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index 709efaa..5ee0266 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -30,7 +30,7 @@ Required properties:
 			- The base address and range of ADC register
 			- The base address and range of ADC_PHY register (every
 			  SoC except for s3c24xx/s3c64xx ADC)
-- interrupts: 		Contains the interrupt information for the timer. The
+- interrupts:		Contains the interrupt information for the timer. The
 			format is being dependent on which interrupt controller
 			the Samsung device uses.
 - #io-channel-cells = <1>; As ADC has multiple outputs
-- 
1.8.0

