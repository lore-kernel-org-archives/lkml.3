Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbbAHBl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:41:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40189 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbbAHBlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:41:07 -0500
X-AuditID: cbfee691-f79b86d000004a5a-ea-54ade02b7497
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv3 8/8] ARM: dts: Add memory bus node for Exynos4412-based
 TRATS2 board
Date: Thu, 08 Jan 2015 10:40:57 +0900
Message-id: <1420681257-3078-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkQFf7wdoQg/MrlC0er1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlTF7z3fGghmcFT27L7A1MD5k72Lk5JAQMJF4e+MFlC0mceHe
	erYuRi4OIYGljBKX1i6GK/r3+AcrRGIRo8Sia/MYIZwmJomdf++wglSxCWhJ7H9xgw3EFhHQ
	k+g8tgesm1ngD5NE0yYWEFtYIELiStdssHoWAVWJJcf2MYPYvAIuEhs/72GE2KYgsWz5TLAa
	TgFXif6n18BsIaCay49XQdW8ZJd4dksaYo6AxLfJh4DmcwDFZSU2HWCGKJGUOLjiBssERuEF
	jAyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQIj6vS/ZxN3MN4/YH2IUYCDUYmHt6BvTYgQ
	a2JZcWXuIUZToA0TmaVEk/OBcZtXEm9obGZkYWpiamxkbmmmJM6rI/0zWEggPbEkNTs1tSC1
	KL6oNCe1+BAjEwenVAPjjui9S/qyw/iez5tkanl4ZcmdI4syRfcq/jpxWGTSzLef9irH7w/7
	4j1xfta7aKPNz2eWiTY9UdNSORzmeU9DWq7vjnmqfuuHrPdxEhNO7RNVCQ/W93FJ8W9with2
	0139Q4Lc558P78+cFn7yU/TaJ1u+R/5rc9nSbi+/bYq5lLnpJbep0db7lFiKMxINtZiLihMB
	Mrp18qMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV3tB2tDDFYek7J4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM2Xu+MxbM4Kzo2X2B
	rYHxIXsXIyeHhICJxL/HP1ghbDGJC/fWs3UxcnEICSxilFh0bR4jhNPEJLHz7x2wKjYBLYn9
	L26wgdgiAnoSncf2gE1iFvjDJNG0iQXEFhaIkLjSNRusnkVAVWLJsX3MIDavgIvExs97GCG2
	KUgsWz4TrIZTwFWi/+k1MFsIqOby41WMExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P
	3cQIjthnUjsYVzZYHGIU4GBU4uEt6FsTIsSaWFZcmXuIUYKDWUmEt+vs2hAh3pTEyqrUovz4
	otKc1OJDjKZAV01klhJNzgcmk7ySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU7NTUgtQi
	mD4mDk6pBsaSP782/WeZ49SebrTMs9tK9QtvxHaTaTJ/j5789d27QVejddtWR8Os5W32nxdm
	KR0VlDaI+3Wn56nar9LN62siZnExqsc9tGaKmxJwmqtBOyRhtWpqkEnu7EOOZ8NfaB7xufjJ
	823BPIad827Uqedz+Wm7bfH4MaVlq8zlK5MubVldtCLFgV+JpTgj0VCLuag4EQBxvAsM7gIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Exynos4412 memory-bus node which includes the regulator
and devfreq-event phandle. The devfreq-event phandle is used for the
governor of devfreq device and provide the current usage state of
MIF (Memory Interface) / INT (Internal) memory bus group.

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index bee0eed..21ba25e 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -917,6 +917,18 @@
 	};
 };
 
+&memory_bus_mif {
+	devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+	vdd-mem-supply = <&buck1_reg>;
+	status = "okay";
+};
+
+&memory_bus_int {
+	devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+	vdd-mem-supply = <&buck3_reg>;
+	status = "okay";
+};
+
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
-- 
1.8.5.5

