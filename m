Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaCLEQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:16:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39884 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaCLEQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:16:50 -0400
X-AuditID: cbfee68f-b7f156d00000276c-b7-531fdfb11650
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 3/4] ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and
 ARCH_S3C64XX
Date: Wed, 12 Mar 2014 13:33:00 +0900
Message-id: <1394598781-3848-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t8zQ92N9+WDDWZ1cFtsenyN1eLyrjls
	FjPO72OyuH2Z12LR1i/sDqweLc09bB6bl9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8as
	+/OZC46xV5x+0MXWwDiPrYuRk0NCwERi2a4fjBC2mMSFe+uB4lwcQgLLGCXuLv3KBFO0oOEq
	C0RiOqPE+S3nGCGcNiaJbX+2sYBUsQnoSjx5P5cZxBYRyJa4NOsWWJxZIETi9otVYHFhgUiJ
	3ntPwWwWAVWJVQcfg9XwCrhLLO7fz97FyAG0TUFiziQbkDCngIfEzp+nwK4TAirZdWgnO8he
	CYH/bBJTevYzQswRkPg2+RALRK+sxKYDzBBHS0ocXHGDZQKj8AJGhlWMoqkFyQXFSelFxnrF
	ibnFpXnpesn5uZsYIUHcv4Px7gHrQ4zJQOMmMkuJJucDoyCvJN7Q2MzIwtTE1NjI3NKMNGEl
	cd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAqMvHOcro6a/UsazHuLM+Lx3znrLnj
	1h6SHnjz5HHpt75Vun419Z1GlQ/Myu5Ovau0rUbsUJdyWIrBifOSd3M3f6+VNvn544PWy1eT
	z756YZ2c7rZy8YWerJRTWxaILNux9KgQS+70kyl+4e690V6+53ivSLVc4nf+L7viZ3JX3NWi
	OLaGKbuVWIozEg21mIuKEwFa54h9eAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQd2N9+WDDbbuZrfY9Pgaq8XlXXPY
	LGac38dkcfsyr8WirV/YHVg9Wpp72Dw2L6n36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07TBNC
	Q9x0LWAaI3R9Q4LgeowM0EDCOsaMWffnMxccY684/aCLrYFxHlsXIyeHhICJxIKGqywQtpjE
	hXvrgeJcHEIC0xklzm85xwjhtDFJbPuzDayKTUBX4sn7ucwgtohAtsSlWbfA4swCIRK3X6wC
	iwsLREr03nsKZrMIqEqsOvgYrIZXwF1icf9+9i5GDqBtChJzJtmAhDkFPCR2/jzFCGILAZXs
	OrSTfQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwTHyTHoH46oGi0OMAhyMSjy8
	CzXlg4VYE8uKK3MPMUpwMCuJ8H4ECfGmJFZWpRblxxeV5qQWH2JMBjpqIrOUaHI+MH7zSuIN
	jU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGxjq/dNHni0ez9Z2cy
	pOl8vZ0cOfvctd6A6fHSukGhOwK7W/P2HrZVbzQ/E8f96Hj91B1fu1J59SW6s/iP+WbKFgad
	Kuy/F7trXvZO9TVHDy2uUdqgz/FA2umw0uEjG/dLbb73hVNerCbCKYmVf84FidlP1tvOPdQS
	c33Wj76SlU7ZNzOvvNioxFKckWioxVxUnAgAaDbEf9UCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects COMMON_CLK_SAMSUNG for EXYNOS and S3C64XX SoC
and removes COMMON_CLK selection as COMMON_CLK_SAMSUNG selects it's dependency.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e254198..0c15aa7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -755,7 +755,7 @@ config ARCH_S3C64XX
 	select ARM_VIC
 	select CLKDEV_LOOKUP
 	select CLKSRC_SAMSUNG_PWM
-	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_V6K
 	select GENERIC_CLOCKEVENTS
 	select GPIO_SAMSUNG
@@ -834,7 +834,7 @@ config ARCH_EXYNOS
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_SPARSEMEM_ENABLE
 	select ARM_GIC
-	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select HAVE_S3C2410_I2C if I2C
-- 
1.7.9.5

