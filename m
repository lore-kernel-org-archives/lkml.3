Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3EFDxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:53:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27263 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3EFDxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:53:35 -0400
X-AuditID: cbfee691-b7fe56d000004b96-91-5187293e7b20
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] dma: at_hdmac: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:53:33 +0900
Message-id: <002701ce4a0d$47c62000$d7526000$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KDSRrm4qp2BuCTYWKhG6spHIw0A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY107zfZAg9sTOC029z9gs7i88BKr
	xeVdc9gsvl1uZrd42befxYHVY8GvrSweE5vfsXss3vOSyaNvyypGj8+b5AJYo7hsUlJzMstS
	i/TtErgy3uxsZyo4wlnR83QrcwPjTI4uRk4OCQETidkHjzFC2GISF+6tZ+ti5OIQEljGKPH7
	9l9WmKLfM24xQSQWMUp0T2ljhHB+MUr8m9kF1s4moCbx5cth9i5GDg4RAXWJpddlQGqYBXoZ
	JVY2TwCrERbwlfh/fzYTiM0ioCrRfO8i2AZeAUuJxxNfskDYghI/Jt8Ds5kFtCTW7zzOBGHL
	S2xe85YZ4iIFiR1nX4PNFBHQk+hfcR6qRkRi34t3YMdJCBxilzh0op0VYpmAxLfJh1hAjpMQ
	kJXYdABqjqTEwRU3WCYwis1CsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UWmesWJucWleel6
	yfm5mxgh0TdxB+P9A9aHGJOB1k9klhJNzgdGb15JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGJfvmvXI59mzFVNZDq/8evdek+vhn64/JMzurpwv
	e0/3W+B2k02TL38QzGVwe/fIw7boaPaNWU8+tZ++dVjP2crTcYnNdY1DR9zlHWUbn+Y82fg0
	dPqZedn7155e9Yjx51qHmbWpjHOLLZfp3Hs4Qafy++ITjNk5wutm/X7x7WC5WkMjy11b8QNb
	lViKMxINtZiLihMBss70/dQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAV07zfZAg6d9rBab+x+wWVxeeInV
	4vKuOWwW3y43s1u87NvP4sDqseDXVhaPic3v2D0W73nJ5NG3ZRWjx+dNcgGsUQ2MNhmpiSmp
	RQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA25UUyhJzSoFCAYnF
	xUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGW92tjMVHOGs6Hm6lbmBcSZHFyMnh4SAicTv
	GbeYIGwxiQv31rN1MXJxCAksYpTontLGCOH8YpT4N7OLEaSKTUBN4suXw+xdjBwcIgLqEkuv
	y4DUMAv0MkqsbJ4AViMs4Cvx//5ssKksAqoSzfcusoLYvAKWEo8nvmSBsAUlfky+B2YzC2hJ
	rN95nAnClpfYvOYtM8RFChI7zr4GmykioCfRv+I8VI2IxL4X7xgnMArMQjJqFpJRs5CMmoWk
	ZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Nh+JrWDcWWDxSFGAQ5GJR7egidtgUKs
	iWXFlbmHGCU4mJVEeH32AoV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5h28kriDY1NzIws
	jcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsfa9964lSnu+XVeX//2creuI
	q79yx0ptze2W+5X3RN/NclF+cnPGG38+uy1udypP3Qv5OX/iknvt+tJTnx85q5X810A8OSfF
	xvJO5fmatadWHng320sp60XnYZGVWVsNHDZHKKj+/cXFPy32+gS5wOkabYIiHx1/d2n1N3W+
	LPVfcu1J94u7RUosxRmJhlrMRcWJAEggmKExAwAA
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
 drivers/dma/at_hdmac.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index e923cda..c093ab7 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1472,7 +1472,6 @@ err_of_dma_controller_register:
 	dma_async_device_unregister(&atdma->dma_common);
 	dma_pool_destroy(atdma->dma_desc_pool);
 err_pool_create:
-	platform_set_drvdata(pdev, NULL);
 	free_irq(platform_get_irq(pdev, 0), atdma);
 err_irq:
 	clk_disable(atdma->clk);
@@ -1497,7 +1496,6 @@ static int at_dma_remove(struct platform_device *pdev)
 	dma_async_device_unregister(&atdma->dma_common);
 
 	dma_pool_destroy(atdma->dma_desc_pool);
-	platform_set_drvdata(pdev, NULL);
 	free_irq(platform_get_irq(pdev, 0), atdma);
 
 	list_for_each_entry_safe(chan, _chan, &atdma->dma_common.channels,
-- 
1.7.2.5

