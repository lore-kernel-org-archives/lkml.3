Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3H1Fz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:55:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18584 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3H1FzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:55:24 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-11-521d90c506b4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Ian Molton'" <ian.molton@collabora.co.uk>,
        "'Chris Ball'" <cjb@laptop.org>, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
In-reply-to: <000301cea3b2$c06f2a20$414d7e60$%han@samsung.com>
Subject: [PATCH 5/5] mfd: tmio_core: Remove tmio_core_mmc_pwr()
Date: Wed, 28 Aug 2013 14:55:17 +0900
Message-id: <000d01cea3b3$2c1b4060$8451c120$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6jssAlip17A5gXTNKNBqRYWYD+6gAAGEfA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zY92jE2SDDE5f0bPY/nojm8X7jfOY
	LPY1PWexuLzwEqvFxKY7LBb3vx5ltLi8aw6bxeluVgcOj7/Pr7N4fPgY5zG7Yyarx6Eraxk9
	7lzbw+Yx72SgR9+WVYwenzfJBXBEcdmkpOZklqUW6dslcGXMm7mLveAfe0XvsjvMDYxP2LoY
	OTkkBEwk5s+5wAhhi0lcuLceKM7FISSwjFFi16IJcEVn/r5lhkhMZ5T4OGkdC4Tzi1Gie1o3
	WBWbgJrEly+H2bsYOThEBPwkGlawg9QwC7QzSfyesQCsRkjAVuJsbysLiM0pYCdxov0mI0i9
	sIC9xL5z+iAmi4CqROcNS5AKXqDqx70/WSBsQYkfk++B2cwCWhLrdx5ngrDlJTavAbmNA+hO
	dYlHf3VBwiICRhJ3ri5khCgRkdj34h0jyDUSAq0cEr9+zmMGSbAICEh8m3yIBaJXVmLTAWaI
	dyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQI
	ie6JOxjvH7A+xJgMtH4is5Rocj4wOeSVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgdFefV6dfJXHmncTVk+ZIsAbEpSz/fS6u9++St61UTJTCX9z
	WXyy8R5VW+2pyvkXZnY55Pfu3Pj2AKNaLr9Qo14X1/mZn51uXnl52sauf8reo/k53dwGbUq8
	JlY8gTO0Xm7nVpj/+JI98+EYjQfX4vebMNzgK4jim9mtaS5SzlPiY2EYeNl2khJLcUaioRZz
	UXEiAEaI7EAEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jQd2jE2SDDO4u0LbY/nojm8X7jfOY
	LPY1PWexuLzwEqvFxKY7LBb3vx5ltLi8aw6bxeluVgcOj7/Pr7N4fPgY5zG7Yyarx6Eraxk9
	7lzbw+Yx72SgR9+WVYwenzfJBXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGPMmDdzF3vBP/aK3mV3mBsYn7B1MXJySAiYSJz5+5YZwhaTuHBvPVCci0NIYDqjxMdJ61gg
	nF+MEt3TusE62ATUJL58OczexcjBISLgJ9Gwgh2khlmgnUni94wFYDVCArYSZ3tbWUBsTgE7
	iRPtNxlB6oUF7CX2ndMHMVkEVCU6b1iCVPACVT/u/ckCYQtK/Jh8D8xmFtCSWL/zOBOELS+x
	eQ3InRxAd6pLPPqrCxIWETCSuHN1ISNEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR
	1ILkguKk9FxDveLE3OLSvHS95PzcTYzg1PFMagfjygaLQ4wCHIxKPLwWm2WChFgTy4orcw8x
	SnAwK4nwlvwHCvGmJFZWpRblxxeV5qQWH2JMBvpzIrOUaHI+MK3llcQbGpuYGVkamVkYmZib
	kyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjysrvS7mOT5gepsZnZTuN9eWleF9j0fC/
	+htDmd4KCKR3H+hWZp2ZkKv6fk/PkdP69hk6Jxdf93xizCT87K3bTYUlN+PmPmb7d7Nk1udN
	KhdspD9vOLO72olpusTFQ8ysRjnzKg7Ga3BeSriwgLePmYVtG7P68YpEpjV9uROKa5cxfyuw
	DVuvxFKckWioxVxUnAgASMOJgWEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmio_core_mmc_pwr() is not called anymore, so remove it.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian.molton@collabora.co.uk>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mfd/tmio_core.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/mfd/tmio_core.c b/drivers/mfd/tmio_core.c
index 83af78c..1a28c85 100644
--- a/drivers/mfd/tmio_core.c
+++ b/drivers/mfd/tmio_core.c
@@ -39,12 +39,6 @@ int tmio_core_mmc_resume(void __iomem *cnf, int shift, unsigned long base)
 }
 EXPORT_SYMBOL(tmio_core_mmc_resume);
 
-void tmio_core_mmc_pwr(void __iomem *cnf, int shift, int state)
-{
-	sd_config_write8(cnf, shift, CNF_PWR_CTL_2, state ? 0x02 : 0x00);
-}
-EXPORT_SYMBOL(tmio_core_mmc_pwr);
-
 void tmio_core_mmc_clk_div(void __iomem *cnf, int shift, int state)
 {
 	sd_config_write8(cnf, shift, CNF_SD_CLK_MODE, state ? 1 : 0);
-- 
1.7.10.4


