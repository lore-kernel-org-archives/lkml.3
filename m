Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3CUXrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:47:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57240 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3CUXrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:47:08 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-39-514b9bfae91c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        "'Herbert Xu'" <herbert@gondor.hengli.com.au>,
        "'David Rientjes'" <rientjes@google.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: hwrng: exynos - add CONFIG_PM_RUNTIME to suspend/resume functions
Date: Fri, 22 Mar 2013 08:47:04 +0900
Message-id: <009c01ce268e$644fdc90$2cef95b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4mjmQqxamDydX7S9GdYJ567gCW/A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zA91fs70DDY418FjMWb+GzaL7lYzF
	5YWXWC0u75rDZrFgWx+jRduSjUwObB7bDqh6LNhU6nFixm8Wj74tqxg9+l5uYPT4vEkugC2K
	yyYlNSezLLVI3y6BK+P4jIfMBas5K1aue83WwNjH0cXIySEhYCJxrekwO4QtJnHh3nq2LkYu
	DiGBZYwSM6dMYocpuvVnMgtEYjqjxL0vr6GqfjFKrNndwQhSxSagJvHlC8goDg4RAX2JthYN
	kDCzwD5Gic47+SC2sICXxOIva1lBbBYBVYmb54+wgNi8ArYS29dcYISwBSV+TL7HAtGrJbF+
	53EmCFteYvOat8wg4yUE1CUe/dUFCYsI6Ek83TwDqkREYt+Ld4wgp0kInGKXeLWoE2qXgMS3
	yYdYIHplJTYdYIb4S1Li4IobLBMYxWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJTveLE
	3OLSvHS95PzcTYyQOJy4g/H+AetDjMlA6ycyS4km5wPjOK8k3tDYzMjC1MTU2Mjc0ow0YSVx
	XvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjDu4zqa8sZ7rsLhPbeqTZJnE69E3mt+8
	6HjJEMC2emdGZ3f/wvqNxt9uHjTfV6jPLmu368O1BU4fzk9ybF4axdnyqCL28tGO6hv3VY7e
	uhq38/LzfE35GNYjMz1V5NM3SR3jMzwiuth/v6LVqt7Yf6YtCzZyZdt92HK++LJ3aO0bS64y
	juBJm5VYijMSDbWYi4oTATsQ2nHZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jQd1fs70DDS5sZ7eYs34Nm0X3KxmL
	ywsvsVpc3jWHzWLBtj5Gi7YlG5kc2Dy2HVD1WLCp1OPEjN8sHn1bVjF69L3cwOjxeZNcAFtU
	A6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtARSgpl
	iTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM4zMeMhes5qxYue41WwNjH0cX
	IyeHhICJxK0/k1kgbDGJC/fWs3UxcnEICUxnlLj35TWU84tRYs3uDkaQKjYBNYkvXw6zdzFy
	cIgI6Eu0tWiAhJkF9jFKdN7JB7GFBbwkFn9ZywpiswioStw8fwRsAa+ArcT2NRcYIWxBiR+T
	77FA9GpJrN95nAnClpfYvOYtM8h4CQF1iUd/dUHCIgJ6Ek83z4AqEZHY9+Id4wRGgVlIJs1C
	MmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc5c+kdjCubLA4xCjAwajE
	w6uh4x0oxJpYVlyZe4hRgoNZSYQ3MgUoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnABJRX
	Em9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYz7peV7CqrdtR6L
	17Ce279WRm9v0LpzttLaT+PV0p2jP/oXzPxhsUpfw0r0S9Bcm1XKoabn3nO+/nE8yjyV8aHr
	49rv0t5VKh6S5joMHF809U50n88OVF7lzxDTvfEky97JdRfq7jz+YrzmvgxbV/SnL+XefTbf
	b0+ZlDI5pWSmSMjLrS2zBZVYijMSDbWYi4oTAVD/9TI2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_RUNTIME to suspend/resume functions to fix the build
error. It is because UNIVERSAL_DEV_PM_OPS macro is related to both
CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.

drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_suspend' undeclared here (not in a function)
drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_resume' undeclared here (not in a function)

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reported-by: David Rientjes <rientjes@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/char/hw_random/exynos-rng.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index b7e48a2..402ccfb 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -144,7 +144,7 @@ static int exynos_rng_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
 static int exynos_rng_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-- 
1.7.2.5


