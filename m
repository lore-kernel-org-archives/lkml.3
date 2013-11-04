Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3KDB4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 20:56:39 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12982 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3KDB4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 20:56:08 -0500
X-AuditID: cbfee691-b7f866d000001b8c-48-5276feb6e74b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv3 2/3] ARM: dts: exynos4212: Add missing clock for multi core
 timer
Date: Mon, 04 Nov 2013 10:56:00 +0900
Message-id: <1383530161-24080-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1383530161-24080-1-git-send-email-cw00.choi@samsung.com>
References: <1383530161-24080-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkUHfbv7Igg/9tRhbzj5xjtTj3aiWj
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12LtkbvsFkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjigu
	m5TUnMyy1CJ9uwSujEe/TrMUnGet2Lv/DXsD41mWLkZODgkBE4ktL1ZA2WISF+6tZ+ti5OIQ
	EljKKDGro50Zpujq3O+sEInpjBK/Z89jgXAamSQWn57FClLFJqAlsf/FDTYQW0RAV2LKzDtg
	HcwCz5gkVnw6zwiSEBYIleiYtoMJxGYRUJXYdvcvexcjBwevgKvEjgsZENvkJD7secQOYnMK
	uEn8O38AzBYCKrnbfI0RZKaEwEt2iR3f5zFDzBGQ+Db5EAvIHAkBWYlNB6CulpQ4uOIGywRG
	4QWMDKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxAuPo9L9nE3cw3j9gfYgxGWjcRGYp0eR8
	YBzmlcQbGpsZWZiamBobmVuakSasJM6b/igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj
	TTzvUvb2QL8917fwLvyeN4PTytZi5rRP51xY2Q5MUwlP2vFfKl+67NXRT9PmLJwdrZFjfMOt
	djPLlEPTzHTereu0lbfxm3XhYsnNPRffr70YlyR8zMtULPuSSxVfJN+Xpm3Fu9j9GcU5p92x
	v7fn6dw/my2PpC0L3Wif1st2LHin8B+vzUf7lFiKMxINtZiLihMBsOz5oLkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoO62f2VBBv9nalrMP3KO1eLcq5WM
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZlXou1R+6yWyy9fpHJYsL0tSwWh1ccYLJ4
	dbCNxWL9jNcsDnwea+atYfRoae5h81jw+Qq7x8rlX9g8Ni+p9+jbsorR4/MmOY+Nc0MDOKIa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGY8+nWapeA8a8Xe/W/YGxjPsnQx
	cnJICJhIXJ37nRXCFpO4cG89WxcjF4eQwHRGid+z57FAOI1MEotPzwKrYhPQktj/4gYbiC0i
	oCsxZeYdVpAiZoFnTBIrPp1nBEkIC4RKdEzbwQRiswioSmy7+5e9i5GDg1fAVWLHhQyIbXIS
	H/Y8YgexOQXcJP6dPwBmCwGV3G2+xjiBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jOAofSa9g3FVg8UhRgEORiUeXonLZUFCrIllxZW5hxglOJiVRHidzwGFeFMSK6tSi/Lji0pz
	UosPMSYDHTWRWUo0OR+YQPJK4g2NTcyMLI3MDS2MjM1JE1YS5z3Yah0oJJCeWJKanZpakFoE
	s4WJg1OqgTHzhX2A6Ny00zecui+fvH3WlfP5/CXLdjgqzFm/4/51k4um61Qq/k9c0Lry0HOH
	/R95Z3OrJZfs+Cbu8jMrmNNX69LZrVODLGedrZwZGKL/tufpMb8tAvLs2V6tptlM/Xp12w7e
	8r76/pz3n0he6YdRYRsivJyna558fGCFlnVydb71rkNP8sqUWIozEg21mIuKEwGhmLArFgMA	AA==
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

