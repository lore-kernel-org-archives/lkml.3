Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaCKH4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:56:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55512 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaCKHzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:55:24 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-75-531ec157e65e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/5] ARM: dts: exynos4x12: Add GPS_ALIVE power domain
Date: Tue, 11 Mar 2014 16:54:52 +0900
Message-id: <1394524494-30641-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkUDf8oFywweZjchbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjigu
	m5TUnMyy1CJ9uwSujH1T5rAW3OesmNY4m7mBcT5HFyMHh4SAiUTLPNYuRk4gU0ziwr31bF2M
	XBxCAksZJfb37YVKmEj82zwZKrGIUeLXwlfMEE4jk8TJi1fYQKrYBLQk9r+4AWaLCOhKTJl5
	hxWkiFngPpPEj+OrwBLCAq4SN+ZfZQaxWQRUJab9mcQIYvMCxXseLGCCWCcn8WHPI3YQm1PA
	TeLp7eVgZwgB1Xx5cpMJZKiEwD12ia3z1jFCDBKQ+Db5EAvEP7ISmw4wQ8yRlDi44gbLBEbh
	BYwMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzEC4+j0v2cTdzDeP2B9iDEZaNxEZinR5Hxg
	HOaVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Pa
	F22T61N1PfyORHPwfn7+ySl+3sXnh78xqxySWyXtVPR/u94qTY4OCcH7jKcUuL43Tr/WHbbn
	yy1X/yTfi2v6HX7G8uk85F0opSbt9UqP57eoU9gqedfPDH1FNuWzTRdta3ges1dk2qNfkas4
	ny286Tl/4ppCiY4G1UTp5YW/fJS3P/ncoq/EUpyRaKjFXFScCAABne5kuQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xgG74Qblgg7+XxCyuf3nOajH/yDlW
	i3OvVjJa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDP2TZnDWnCfs2Ja42zmBsb5HF2M
	nBwSAiYS/zZPZoOwxSQu3FsPZHNxCAksYpT4tfAVM4TTyCRx8uIVsCo2AS2J/S9ugNkiAroS
	U2beYQUpYha4zyTx4/gqsISwgKvEjflXmUFsFgFViWl/JjGC2LxA8Z4HC5gg1slJfNjziB3E
	5hRwk3h6ezkriC0EVPPlyU2mCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx+kz
	qR2MKxssDjEKcDAq8fAG+MoFC7EmlhVX5h5ilOBgVhLhdVoLFOJNSaysSi3Kjy8qzUktPsSY
	DHTVRGYp0eR8YArJK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5O
	qQbG0NkucTzyxVH/3c/rP77878RvHWGxl0mTy5dGH1b1u/lmirnQ8fXNwin/Tp+azrDTWWCz
	7II3AXO8rmovuCJaPLWkwHIdY+LG5OArEzZHZ6nm30hr43/Cc/PojA+poWJxEvOz/0Xvaryd
	2ltxpGieFlf/L+9W29M5Lz8qnnKbIcdQIhb7xpZLiaU4I9FQi7moOBEAlpIbiBcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add GPS_ALIVE power domain for Exynos4x12 SoC. GPS_ALIVE power domain
include GPS_BLK for GPS IP. Exynos SoC used generic power-domain driver to
control power domain. After completed kernel booting, Exynos power-domain driver
disable un-used power domain to reduce power-consumption/leak.

If GPS_ALIVE power domain isn't registered to Exynos power-domain driver,
happen power-leakage because GPS_ALIVE_CONFIGURATION is default power on state.

- 0x10023D00 : GPS_ALIVE_CONFIGURATION register address

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 1ec77f6..066eb35 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -41,6 +41,11 @@
 		compatible = "samsung,exynos4210-pd";
 		reg = <0x10023CA0 0x20>;
 	};
+	
+	pd_gps_alive: gps-alive-power-domain@10023D00 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023D00 0x20>;
+	};
 
 	clock: clock-controller@10030000 {
 		compatible = "samsung,exynos4412-clock";
-- 
1.8.0

