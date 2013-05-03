Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755Ab3ECGa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:30:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60640 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762633Ab3ECGa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:30:56 -0400
X-AuditID: cbfee691-b7fe56d000004b96-11-51835995c5b0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 18/42] rtc: rtc-jz4740: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:30:45 +0900
Message-id: <002001ce47c7$be5e05e0$3b1a11a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx72sLj2/LOXUQM2GsgfzaxuMFQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY92pkc2BBuvbLSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmLL+H2tBK0fFh5+vmBsY77J1MXJySAiYSNw8u5YFwhaTuHBvPVCci0NIYBmjxN3r
	p9lhig5dO8YKkZjOKLFy7n9GCOcXo8TEA78YQarYBNQkvnw5DNTBwSEioC/R1qIBUsMs0M0o
	8ah5LjNIjbBAsMTVh+/AprIIqEr8+vUSzOYVsJS43j2NBcIWlPgx+R6YzSygJbF+53EmCFte
	YvOat8wQFylI7Dj7GmyviICeROOzP1D1IhL7XrwDO05C4BC7xIndPcwQywQkvk0+xAJynISA
	rMSmA1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dL
	zs/dxAiJvok7GO8fsD7EmAy0fiKzlGhyPjB680riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6HG1OS7kcOa7dwd/3Fn8/nHjM3N9n8mcacsnb1f4
	sL2Vv2JmSeZCq2Vy4fxbtY5ds0u4sPLvoeAvnr/j+ktLGz8IODCpuRZpFpxV+rZk1yLnupm9
	c59yTNjz+aCBwv8bT0+dFYxKUFKwOF/i01udwLRlSi7Pz7qX/1tm5shUhf5L1Xz4/M9VXiWW
	4oxEQy3mouJEAD+2GXLUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd2pkc2BBvPnmFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDFl/T/WglaOig8/XzE3MN5l62Lk5JAQMJE4
	dO0YK4QtJnHh3nqgOBeHkMB0RomVc/8zQji/GCUmHvjFCFLFJqAm8eXLYfYuRg4OEQF9ibYW
	DZAaZoFuRolHzXOZQWqEBYIlrj58xw5iswioSvz69RLM5hWwlLjePY0FwhaU+DH5HpjNLKAl
	sX7ncSYIW15i85q3zBAXKUjsOPsabK+IgJ5E47M/UPUiEvtevGOcwCgwC8moWUhGzUIyahaS
	lgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmP7mdQOxpUNFocYBTgYlXh4FVqaAoVY
	E8uKK3MPMUpwMCuJ8Lr9AArxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjDt5JXEGxqbmBlZ
	GplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDI5+PpF9VjFrop6PHtecauq88
	99DsyeIl2sF8TFbXXzmmsNtYcD9ZqKWjEHr3QNOJ7ZI3jXVWWYTIcV/bcyPo+OeTGefkcwMC
	4pdHPOacc9rp6NywG6uirr9M3bLFq9r78OJ5b/xXJwdXM5xvORPDzr4r+bLOheiYLEPJCFPv
	aX1y/q9PC742UWIpzkg01GIuKk4EAPzXmywxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-jz4740.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 1e48686..c6573585 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -287,7 +287,6 @@ err_free_irq:
 err_unregister_rtc:
 	rtc_device_unregister(rtc->rtc);
 err_iounmap:
-	platform_set_drvdata(pdev, NULL);
 	iounmap(rtc->base);
 err_release_mem_region:
 	release_mem_region(rtc->mem->start, resource_size(rtc->mem));
@@ -310,8 +309,6 @@ static int jz4740_rtc_remove(struct platform_device *pdev)
 
 	kfree(rtc);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


