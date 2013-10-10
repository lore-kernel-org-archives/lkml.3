Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3JJAaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:30:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60758 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3JJAaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:30:08 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-ae-5255f50e5541
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/3] ARM: dts: exynos4212: Add PMU dt data for pmu-irq
Date: Thu, 10 Oct 2013 09:30:05 +0900
Message-id: <1381365007-1782-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
References: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkWJfva2iQwc7bQhbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjigu
	m5TUnMyy1CJ9uwSujCP/ljAVXGepePtqDWMD4yvmLkZODgkBE4ld3fvZIWwxiQv31rN1MXJx
	CAksZZToa3/GCFN0f/taRojEdEaJ9e8fs0I4jUwS02Z/A6tiE9CS2P/iBli7iEA7o8Tq1gUs
	IA6zQCuTxNUtu8AWCgu4STxumA62kEVAVeLZ9LlsIDavgIvEvk23oI6Sk/iw5xFYDaeAq8Sb
	eV1gNUJANQ3NJ5hBhkoI3GOX2Nu6mxlikIDEt8mHgLZxACVkJTYdgJojKXFwxQ2WCYzCCxgZ
	VjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIExtLpf8/6dzDePWB9iDEZaNxEZinR5HxgLOaV
	xBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXEyo8n2
	uCUXj14y7XDy3eCyaivvrMlq9fudn0388TNDcLPZh8a1Ahey2TY+Wv1f/px5bPBp7qkrRczm
	rc6e9JJ70sKL2ntCfZ2ETc75CnV3HOi7pZjRnrXL0Do90FBQ7e7x8Er+/1VLViVd3lXUty70
	9qZnFtkmC2zvFJt1TrjziuVmR2h5pqYSS3FGoqEWc1FxIgAs438ouwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoC7f19Agg1WvuSyuf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDOO/FvCVHCdpeLtqzWMDYyvmLsY
	OTkkBEwk7m9fywhhi0lcuLeerYuRi0NIYDqjxPr3j1khnEYmiWmzv4FVsQloSex/cQOsSkSg
	nVFidesCFhCHWaCVSeLqll1gc4UF3CQeN0xnB7FZBFQlnk2fywZi8wq4SOzbdAtqt5zEhz2P
	wGo4BVwl3szrAqsRAqppaD7BPIGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Eh9
	Jr2DcVWDxSFGAQ5GJR7eirLQICHWxLLiytxDjBIczEoivNNPAoV4UxIrq1KL8uOLSnNSiw8x
	JgNdNZFZSjQ5H5hE8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmD
	U6qB0eAKr0+MhEmnRqu3ELO05MujE5+vPd6wx8qUnfHE/ZLXlyZKv7jpmnT2hL5c8qSCiI7b
	a1TUWPa5PjhoKDTJWNFlKtv/Hd9bpZXzTy+Zfv1Tt/bXO9HvsrdfLHXUstjx+8a7bQqTlnqo
	r2BNjP/IcyO0Jvf3TCs3Ga358THFnFUB57bUBpRzKLEUZyQaajEXFScCAIy+ZcAYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4212.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 6f34d7f..3081bae 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
@@ -56,4 +56,10 @@
 					<0x5 0 &gic 1 12 0>;
 		};
 	};
+
+	pmu {
+		compatible = "arm,cortex-a9-pmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>, <3 2>;
+	};
 };
-- 
1.8.0

