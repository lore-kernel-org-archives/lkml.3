Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbbAZERb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:17:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35520 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbbAZEQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:16:52 -0500
X-AuditID: cbfee691-f79b86d000004a5a-d3-54c5bfa6ad47
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        sangbae90.lee@samsung.com, inki.dae@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v10 7/7] ARM: dts: exynos: Add PPMU node for Exynos4412-based
 TRATS2 board
Date: Mon, 26 Jan 2015 13:16:33 +0900
Message-id: <1422245793-8552-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
References: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWyRsSkUHfZ/qMhBje2cVo8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtjn86yGKxatcfRgdBjzXz1jB67Jx1l91j8Z6XTB6bVnWyeWxeUu/R
	t2UVo8fnTXIB7FFcNimpOZllqUX6dglcGTOuX2cqWM9dserYb7YGxgWcXYycHBICJhJ7v2xj
	g7DFJC7cWw9kc3EICSxllHjfNokNpqh37hlGiMR0Rom+S2tYIZwmJokN116xgFSxCWhJ7H9x
	A6xDREBPovPYHnaQImaB6cwSkxdMZAVJCAvESNx7sB6siEVAVWLxldlANgcHr4CLxNQvcRDb
	FCSWLZ8JVs4p4CoxseE5I0iJEFDJ9+9cICMlBD6yS2xqPMwMMUZA4tvkQywgNRICshKbDjBD
	jJGUOLjiBssERuEFjAyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQJj6/S/ZxN3MN4/YH2I
	UYCDUYmHV6PxaIgQa2JZcWXuIUZToA0TmaVEk/OBEZxXEm9obGZkYWpiamxkbmmmJM6rI/0z
	WEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjolfRU7ap1nXiv62j3uxTqtjfvO5Tl+Y/q6nf
	lTNFQtzFVuo/1O7JEJx5UIDbrkUymFv18uqtWsYMMXJct2+ZLdXs2mG7TnbFzO79Dj+XeTF+
	Z2VZuM15p90Vg0VlUat5hc//Wb+4elFge37d4k7lp6fnNzXNW/Nctf/dse7CC98F7/5wynyo
	xFKckWioxVxUnAgA7kmSf6gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQd1l+4+GGLxJsHi8ZjGTxcYZ61kt
	rn95zmox6f4EFovXLwwt+h+/ZrY42/SG3WLT42usFpd3zWGz+Nx7hNFixvl9TBZLr19ksrjd
	uILN4vGKt+wWrXuPsFsc/3SQxWLVrj+MDoIea+atYfTYOesuu8fiPS+ZPDat6mTz2Lyk3qNv
	yypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8
	AnTdMnOAHlBSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZsy4fp2pYD13
	xapjv9kaGBdwdjFyckgImEj0zj3DCGGLSVy4t56ti5GLQ0hgOqNE36U1rBBOE5PEhmuvWECq
	2AS0JPa/uMEGYosI6El0HtvDDlLELDCdWWLygomsIAlhgRiJew/WgxWxCKhKLL4yG8jm4OAV
	cJGY+iUOYpuCxLLlM8HKOQVcJSY2PGcEKRECKvn+nWsCI+8CRoZVjKKpBckFxUnpuYZ6xYm5
	xaV56XrJ+bmbGMFx+0xqB+PKBotDjAIcjEo8vA3NR0OEWBPLiitzDzFKcDArifCWTwEK8aYk
	VlalFuXHF5XmpBYfYjQFumkis5Rocj4wpeSVxBsam5gZWRqZG1oYGZsrifMq2beFCAmkJ5ak
	ZqemFqQWwfQxcXBKNTA6H5N9rxRtpDxPxTT3X8+ExOgpk79nbZJ4ei5Tc/qUfQc0ZRRXiZ38
	uPTswYUr8lufBjJklgqnrY65dUu/T9IgfZnK1E2V2atX8niJzOtV6XjMNCvyysOlv/J53Iu7
	90979mRvX8FjkWN796z9Yb+v+dWcNRw8fV+0tYQKYoXSbmls6eJQ3xmgxFKckWioxVxUnAgA
	JDAPS/ECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add dt node for PPMU_{DMC0|DMC1|LEFTBUS|RIGHTBUS} for
exynos4412-trats2 board. Each PPMU dt node includes one event of 'PPMU Count3'.

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 29231b4..70eac85 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -865,6 +865,46 @@
 	};
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
-- 
1.8.5.5

