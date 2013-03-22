Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3CVB4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:56:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44809 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3CVBz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:55:59 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-e0-514bba2dee80
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        "'Herbert Xu'" <herbert@gondor.hengli.com.au>,
        "'David Rientjes'" <rientjes@google.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009c01ce268e$644fdc90$2cef95b0$%han@samsung.com>
In-reply-to: <009c01ce268e$644fdc90$2cef95b0$%han@samsung.com>
Subject: [PATCH] hwrng: exynos - add CONFIG_PM_RUNTIME to suspend/resume
 functions
Date: Fri, 22 Mar 2013 10:55:57 +0900
Message-id: <00ad01ce26a0$652a58e0$2f7f0aa0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4mjmQqxamDydX7S9GdYJ567gCW/AAEeQRQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zQ13dXd6BBvOeq1rMWb+GzaL7lYzF
	5YWXWC0u75rDZrFgWx+jRduSjUwObB7bDqh6LNhU6nFixm8Wj74tqxg9+l5uYPT4vEkugC2K
	yyYlNSezLLVI3y6BK+P4jIfMBas5K1aue83WwNjH0cXIySEhYCKx9mcLI4QtJnHh3nq2LkYu
	DiGBZYwSW98tYYYp+nxiAViRkMAiRoknc4Igin4xSqx7doMNJMEmoCbx5cth9i5GDg4RAX2J
	thYNkDCzwD5Gic47+RC9thK/j+1iB7E5Bewkdq/dygpiCwuESDRN3gFmswioSmz5t4gJxOYF
	qt+6+iYrhC0o8WPyPRaImVoS63ceZ4Kw5SU2r3nLDLJWQkBd4tFfXZCwiICRRPPWPqgSEYl9
	L94xgpwsIfCIXWLO5g1QuwQkvk0+xALRKyux6QDUu5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIV
	CxhZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmKERG3/Dsa7B6wPMSYDrZ/ILCWanA+M+ryS
	eENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MJbFnb54
	Tshzg1HyxYSd6zbtLj+u/PEPn5aF0sHdnQsrlY3yHKdNyZgss0Se3VX65GO/Zwe8e528q05F
	Bv+WmNFWJqNTcNZh00nPiqj+/b+P3LV4eMG775ZeQ5n84iV9bM69WewbL2n4ZpqqMF248vHo
	dbMXV7q7vp3ZNWUS60rVhnSjvA/X+pRYijMSDbWYi4oTAe0bZ23wAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jAV3dXd6BBncvK1rMWb+GzaL7lYzF
	5YWXWC0u75rDZrFgWx+jRduSjUwObB7bDqh6LNhU6nFixm8Wj74tqxg9+l5uYPT4vEkugC2q
	gdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gIJYWy
	xJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG8RkPmQtWc1asXPearYGxj6OL
	kZNDQsBE4vOJBYwQtpjEhXvr2UBsIYFFjBJP5gR1MXIB2b8YJdY9uwGWYBNQk/jy5TB7FyMH
	h4iAvkRbiwZImFlgH6NE5518iF5bid/HdrGD2JwCdhK7125lBbGFBUIkmibvALNZBFQltvxb
	xARi8wLVb119kxXCFpT4MfkeC8RMLYn1O48zQdjyEpvXvGUGWSshoC7x6K8uSFhEwEiieWsf
	VImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M
	4JTwTGoH48oGi0OMAhyMSjy8GjregUKsiWXFlbmHGCU4mJVEeCNTgEK8KYmVValF+fFFpTmp
	xYcYk4EencgsJZqcD0xXeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZ
	wsTBKdXAGHDh1JLMJf+3/9sU1Mm+d+PHt9IhH9rerj24yD5nnfP9s3of/pbuafC5lzIh1s6s
	4qbOvI7m/KKk06mc5d0ZN8si2r5Y6ynUSDE/MYrw2nZ9H8+V49szOpXYHgQKidjxasTVrCne
	z+Ef0XjtwJxpepO6zy6efnKTPfOq6BlTOqWe2X+ebeu9UYmlOCPRUIu5qDgRAAH/KA5NAwAA
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


