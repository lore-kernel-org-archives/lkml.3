Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbbALJXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:23:51 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32012 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbbALJX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:23:28 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-49-54b3928b7975
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kukjin Kim <kgene@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 3/3] ARM: dts: Use frequency scaling for MSHC
Date: Mon, 12 Jan 2015 10:23:05 +0100
Message-id: <1421054585-9032-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
References: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t/xy7rdkzaHGPx9Km+xccZ6VosJl7cz
	Wsw/co7V4savNlaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hszjyv5/RYsb5fUwWa4/cZbc4
	vjbcgddj06pONo871/aweWxeUu9x49VCJo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKeNfk
	WbCYrWLO/63MDYxrWbsYOTkkBEwk/izZBGWLSVy4t56ti5GLQ0hgKaPErlUbWSGcPiaJpd8u
	sYBUsQkYS2xevgSsSkRgC5PEqjVrwaqYBY4yStyYdZcJpEpYwFpid+cpRhCbRUBVYuv8A8wg
	Nq+Am8TkyTuZIPbJSZw8NhlsN6eAu8TBiT/AbCGgmqu7OpkmMPIuYGRYxSiaWppcUJyUnmuo
	V5yYW1yal66XnJ+7iRESmF92MC4+ZnWIUYCDUYmHd4LM5hAh1sSy4srcQ4wSHMxKIryuZUAh
	3pTEyqrUovz4otKc1OJDjEwcnFINjBterpV5IimWxSVxjv3wNQVFawW+QvG15b/NWvP0hIOW
	tNydfWPbk2qegxvKDZNfT11s3RbzPDkyr9lx8uH0rkNu67/ev29a8anPUyp/3tfti0UbEkpq
	E+LZbk7YP2kDX9m9i//tLq2KSJtUtmH1/3+6s9dJ9N0rtT/O99xyCvdp6c+R109cl1ViKc5I
	NNRiLipOBAD+qv7UKgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable frequency scaling on MSHC to reduce energy consumption. In idle
this reduced energy consumption by 1.0% (from 27.16 mA to 26.89 mA).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index e53f62f216ba..aad09109fdbc 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -493,6 +493,7 @@
 	vmmc-supply = <&ldo12_reg>;
 	clock-frequency = <100000000>;
 	clock-freq-min-max = <400000 100000000>;
+	frequency-scaling;
 	samsung,dw-mshc-ciu-div = <1>;
 	samsung,dw-mshc-sdr-timing = <0 1>;
 	samsung,dw-mshc-ddr-timing = <1 2>;
-- 
1.9.1

