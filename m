Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaG2CRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:17:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38620 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaG2CRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:17:20 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-58-53d7042d95d5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: t.figa@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/3] ARM: dts: Add missing pinctrl for uart0/1 for Exynos3250
Date: Tue, 29 Jul 2014 11:17:12 +0900
Message-id: <1406600232-31033-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1406600232-31033-1-git-send-email-cw00.choi@samsung.com>
References: <1406600232-31033-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSqKvLcj3Y4PMdPYtJ6w4wWVz/8pzV
	Yv6Rc6wWvQuuslmcbXrDbrHp8TVWi4VtS1gsLu+aw2Yx4/w+Jovbl3kt1s94zeLA7dHS3MPm
	8XfVC2aPzUvqPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvjcc9O1oL5HBVTuv8zNzBeZOti
	5OSQEDCRaHlyiBXCFpO4cG89UJyLQ0hgKaPEu32bWWGKVl/cyAKRWMQosezfQyiniUni86HT
	YFVsAloS+1/cABsrIiAp0dTwhxmkiFlgFZPEjeMvmEESwgK+EmsmLgIq4uBgEVCVmNlSAhLm
	FXCVmDj9PNQ2OYkPex6xg9icAm4SrTdPgrUKAdWcPnMUbLGEwDZ2id6uQ2AJFgEBiW+TD7GA
	zJQQkJXYdIAZYo6kxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREYDaf/
	PevfwXj3gPUhxmSgcROZpUST84HRlFcSb2hsZmRhamJqbGRuaUaasJI47/2HSUFCAumJJanZ
	qakFqUXxRaU5qcWHGJk4OKUaGNfJ2Dk3rwqM2ePi816j2DWQzyS7bVm7dpd155eM8G2hUwU+
	qrby/3ZbNqtUL9zt0srpET5zNpw77CRXPJcpmOPXoXcxisY+Fv2fak6bxibdk4+7cmGe/am+
	LWJHgmJjD/L2TChSSyiK3zjj3F8JZv1y3W+tO155eEVzlD/5xBlwacZ+k//ySizFGYmGWsxF
	xYkAm6N8YZwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAV1dluvBBgsWa1hMWneAyeL6l+es
	FvOPnGO16F1wlc3ibNMbdotNj6+xWixsW8JicXnXHDaLGef3MVncvsxrsX7GaxYHbo+W5h42
	j7+rXjB7bF5S79G3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYMx737GQtmM9RMaX7P3MD40W2LkZODgkBE4nVFzeyQNhiEhfurQeKc3EICSxilFj27yEL
	hNPEJPH50GlWkCo2AS2J/S9ugHWLCEhKNDX8YQYpYhZYxSRx4/gLZpCEsICvxJqJi4CKODhY
	BFQlZraUgIR5BVwlJk4/zwqxTU7iw55H7CA2p4CbROvNk2CtQkA1p88cZZnAyLuAkWEVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnCsPZPawbiyweIQowAHoxIP74a514KFWBPLiitzDzFK
	cDArifDOXwIU4k1JrKxKLcqPLyrNSS0+xGgKdNREZinR5HxgGsgriTc0NjEzsjQyN7QwMjZX
	Euc90GodKCSQnliSmp2aWpBaBNPHxMEp1cAY7792YlPMNM89X9ZFHWFasCIxvHqrfVpLw72L
	hodFLVrC0yKF2gu9C8qKeJj+aVr3lc5cwOi1zipiah7TNKM04bdH36jKPVrUxMv45lTIt2RL
	tx7RDWG3tIst/Rf/vX/semfhnY8nrjz/03NN6wXXBGXTJ7Hz/HZNM1h4q+Sb7aJalt7aMCMl
	luKMREMt5qLiRAD4/D6TywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add missing pinctrl for uart0/1 for Exynos3250. The gpio pin (
uart0_data, uart0_fctl, uart1_data) is only used for UART IP.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 5043178..abd6eb3 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -284,6 +284,8 @@
 			interrupts = <0 109 0>;
 			clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
 			clock-names = "uart", "clk_uart_baud0";
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart0_data &uart0_fctl>;
 			status = "disabled";
 		};
 
@@ -293,6 +295,8 @@
 			interrupts = <0 110 0>;
 			clocks = <&cmu CLK_UART1>, <&cmu CLK_SCLK_UART1>;
 			clock-names = "uart", "clk_uart_baud0";
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart1_data>;
 			status = "disabled";
 		};
 
-- 
1.8.0

