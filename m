Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab3JJAaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:30:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33892 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3JJAa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:30:26 -0400
X-AuditID: cbfee68e-b7f756d000004512-d0-5255f50e9436
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/3] ARM: dts: exynos4212: Add missing clock for multi core
 timer
Date: Thu, 10 Oct 2013 09:30:06 +0900
Message-id: <1381365007-1782-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
References: <1381365007-1782-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkRJfva2iQwaOZ1hbzj5xjtTj3aiWj
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12LtkbvsFkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjigu
	m5TUnMyy1CJ9uwSujEe/TrMUnGet2Lv/DXsD41mWLkZODgkBE4mGnb2sELaYxIV769m6GLk4
	hASWMkp0X/vNDFO0fM0FJojEdEaJj7taWSCcRiaJSes2MoJUsQloSex/cQOsXUSgnVFidesC
	sCpmgR4micevNzGBVAkLBEs8XHgIqIqDg0VAVWL+f1uQMK+Ai8SbtveMEOvkJD7secQOYnMK
	uEq8mdfFBmILAdU0NJ9gBpkpIfCIXeLE7y1gDSwCAhLfJh9iAZkpISArsekA1NmSEgdX3GCZ
	wCi8gJFhFaNoakFyQXFSepGRXnFibnFpXrpecn7uJkZgJJ3+96xvB+PNA9aHGJOBxk1klhJN
	zgdGYl5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUa
	GLOWbks4fTXj/kfp0lkXT8/i861o/NbVY371VItU/ayZZxfkMycvvHGMd4knR4faoZzVU5YV
	Za95tnzZjMS3e0VLG9avNdndamVUe7L7ft76vT0qoXvrRTd/+HLJcNuK9QHLcn7wzZL7OGfX
	+pTz+uu6yo0Wr1mY3b6Sb8q82ROMnE9kmfV0PPBQYinOSDTUYi4qTgQAR5UXpLoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xoC7f19Agg+/HjCzmHznHanHu1UpG
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8XaI3fZLZZev8hkMWH6WhaLwysOMFm8
	OtjGYrF+xmsWBz6PNfPWMHq0NPeweSz4fIXdY+XyL2wem5fUe/RtWcXo8XmTnMfGuaEBHFEN
	jDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDMe/TrNUnCetWLv/jfsDYxnWboY
	OTkkBEwklq+5wARhi0lcuLeerYuRi0NIYDqjxMddrSwQTiOTxKR1GxlBqtgEtCT2v7gBViUi
	0M4osbp1AVgVs0APk8Tj15vAZgkLBEs8XHgIqIqDg0VAVWL+f1uQMK+Ai8SbtveMEOvkJD7s
	ecQOYnMKuEq8mdfFBmILAdU0NJ9gnsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZG
	cJw+k9rBuLLB4hCjAAejEg9vRVlokBBrYllxZe4hRgkOZiUR3ukngUK8KYmVValF+fFFpTmp
	xYcYk4GOmsgsJZqcD0wheSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZ
	wsTBKdXAOP383/NCC3Y/DGtLb74+ofju/ZcnTZ/vjzEMXJq6r+y4472yl+pVQaKrLKSCMsXz
	3r7sue2Q7Xhw36/d+a/jS+7uPHAmNWpWgsOyP2KL163gzXTIOvfU1knf59yxpZM+MGl7OEQ7
	l+tmTTY/mMHg8dfD2ee49dcwzz8miXfXh7C1TpWvXLxnsxJLcUaioRZzUXEiAMLCUhUXAwAA
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

