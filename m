Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaCTEju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:39:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56471 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaCTEjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:39:01 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-5d-532a70e47b1d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 4/4] drivers: clk: use COMMON_CLK_SAMSUNG for Samsung clock
 support
Date: Thu, 20 Mar 2014 13:55:25 +0900
Message-id: <1395291325-4043-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
 <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t8zQ90nBVrBBv3/NC02Pb7GanF51xw2
	ixnn9zFZLNr6hd1i/YzXLA6sHpuX1Hv0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxto3R5gL
	lrNXXFtp2MA4h62LkZNDQsBE4t2ajewQtpjEhXvrgeJcHEICyxglPm1+BVfUs2gHO0RiEaPE
	+ZerGCGcNiaJ/2e7WUCq2AR0JZ68n8sMYosIZEtcmnULLM4s4CvRtGIV2AphgQiJGe/awOIs
	AqoSP5fuBbN5BdwlujtWs3YxcgBtU5CYM8kGJMwp4CFxZ/59FohdrYwSyz4sZwZxJAR+s0l8
	+XyVDWKQgMS3yYdYIJplJTYdYIa4WlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtQrTswtLs1L
	10vOz93ECAne3h2Mtw9YH2JMBho3kVlKNDkfGPx5JfGGxmZGFqYmpsZG5pZmpAkrifMmPUwK
	EhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cB4+7LyxvAZzl++WWRe6Jj9v/XS/QW3KxfdXNW9
	IuDK5aitc89/2LVOfolq2A8bv1WaaXPDRJkFX8osXn73wPrWjQcunPr3776o+Jc8/ZsMnLtn
	F2ypTPvQ/E77755vm9tKan5rnTKLM1Bf424ac4413jHrfazEz7OSHwS4fq/nW33y0X/Jks+R
	WkosxRmJhlrMRcWJAA1+tO90AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jAd0nBVrBBkvXqllsenyN1eLyrjls
	FjPO72OyWLT1C7vF+hmvWRxYPTYvqffo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xoy1b44wFyxnr7i20rCBcQ5bFyMnh4SAiUTPoh3sELaYxIV764Hi
	XBxCAosYJc6/XMUI4bQxSfw/280CUsUmoCvx5P1cZhBbRCBb4tKsW2BxZgFfiaYVq8AmCQtE
	SMx41wYWZxFQlfi5dC+YzSvgLtHdsZq1i5EDaJuCxJxJNiBhTgEPiTvz77NA7GpllFj2YTnz
	BEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY+OZ1A7GlQ0WhxgFOBiVeHhX7NEM
	FmJNLCuuzD3EKMHBrCTCa+2uFSzEm5JYWZValB9fVJqTWnyIMRnoqonMUqLJ+cC4zSuJNzQ2
	MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxkrdq1NSBOV2eS82d3rW
	yKC969aRlMpL15znzGWcy//7WPLCDNkQp8DH+yYsKzdoq//d1T5lvtG6JzcuVc8p2RlmsNSb
	PXftvzeeHfznzFurlvKvag+rWaqyM27qv/IGXZWLJdum8+9a5xI5t9Hiol3x3EVa78811H76
	Pq2Btc2yNH5arFLiCiWW4oxEQy3mouJEABTWkojRAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces PLAT_SAMSUNG with COMMON_CLK_SAMSUNG for Samsung
common clock support. Any Samsung SoC want to use Samsung common clock
infrastructure can simply select COMMON_CLK_SAMSUNG.

CC: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index a367a98..f1da6ee 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_PLAT_ORION)		+= mvebu/
 obj-$(CONFIG_ARCH_MXS)			+= mxs/
 obj-$(CONFIG_COMMON_CLK_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
-obj-$(CONFIG_PLAT_SAMSUNG)		+= samsung/
+obj-$(CONFIG_COMMON_CLK_SAMSUNG)	+= samsung/
 obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= shmobile/
 obj-$(CONFIG_ARCH_SIRF)			+= sirf/
 obj-$(CONFIG_ARCH_SOCFPGA)		+= socfpga/
-- 
1.7.10.4

