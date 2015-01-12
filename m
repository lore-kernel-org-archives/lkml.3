Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbbALMfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:35:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29238 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbbALMfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:35:09 -0500
X-AuditID: cbfee68f-f791c6d000004834-d9-54b3bf752636
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv8 9/9] ARM: dts: exynos: Add PPMU node for Exynos4412-based
 TRATS2 board
Date: Mon, 12 Jan 2015 21:34:57 +0900
Message-id: <1421066097-26237-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
References: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSqFu6f3OIwfsjshaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgyti78CxbwXruit5nG5kbGBdwdjFyckgImEi0NCxjhLDFJC7c
	W8/WxcjFISSwlFHi8u4WRpiizg9TWCESixglpt39zAThNDFJPD4wmR2kik1AS2L/ixtsILaI
	gJ5E57E9YHFmgT9MEk2bWEBsYYEoifP/+oHiHBwsAqoSNz7WgYR5BdwkLuz5zQ6xTEFi2fKZ
	rCA2J1D83e41bCDlQgKuEjfW14OslRB4yS4xrX0eE0gNi4CAxLfJh1hAaiQEZCU2HWCGGCMp
	cXDFDZYJjMILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYgTG0+l/z/p3MN49YH2IUYCD
	UYmH10Jqc4gQa2JZcWXuIUZToA0TmaVEk/OBUZtXEm9obGZkYWpiamxkbmmmJM67UOpnsJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQZGbvPJrqfzXheF3HI+cun7A2XJmuzgneoGUc3/w39s
	P2fyZWXeRF1J2cVzvkcddf6uwH725RRHhh0zoh1u+BnOlD/yZqP+/8SpcZ/bzP4niM63zdO5
	91i4i9VsRePhn897z1RsflYc+rXIcO624IW7VLkjrpYqGT+0stJgdNov8foA5zvx8oftSizF
	GYmGWsxFxYkA3ad/jaICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAd3S/ZtDDCbPErV4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMvQvPshWs567ofbaR
	uYFxAWcXIyeHhICJROeHKawQtpjEhXvr2boYuTiEBBYxSky7+5kJwmliknh8YDI7SBWbgJbE
	/hc32EBsEQE9ic5je8DizAJ/mCSaNrGA2MICURLn//UDxTk4WARUJW58rAMJ8wq4SVzY85sd
	YpmCxLLlM8EWcwLF3+1ewwZSLiTgKnFjff0ERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS
	83M3MYKj9Zn0DsZVDRaHGAU4GJV4eC2kNocIsSaWFVfmHmKU4GBWEuF1LQMK8aYkVlalFuXH
	F5XmpBYfYjQFumkis5Rocj4wkeSVxBsam5gZWRqZG1oYGZsrifMq2beFCAmkJ5akZqemFqQW
	wfQxcXBKNTBO3lAsVzrpzLcLXt9txC2rpRf97fpovIvXwTnv25aPooo3msWPaLzpdrq/5zOj
	5d+p81QN/qxo3yVVtv628Ufrt45GOsv38C6rjM6fU9Qpv4kp85pcjMY9zymh3P2p+o8k1Fcs
	PNBiLbH66OMesZcVtXPmyS4WfsFQfEjrky7X68bnYd6TS54osRRnJBpqMRcVJwIA0v6VeuwC	AAA=
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
index c9b70b6..bee0eed 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -877,6 +877,46 @@
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

