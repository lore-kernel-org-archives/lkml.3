Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846Ab3IECn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:43:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19571 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935440Ab3IECnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:43:25 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-58-5227efcc2ad9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
In-reply-to: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
Subject: [PATCH 5/6] backlight: lp8788: Staticize 'default_bl_config'
Date: Thu, 05 Sep 2013 11:43:24 +0900
Message-id: <002601cea9e1$b103b8f0$130b2ad0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p4TRpKe++09SiQwq9N1m2ivIIowAAGZtA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zY90z79WDDHael7OYs34Nm8Xk3V2s
	FpcXXgISu+awWSz/tY7FYveup6wObB47Z91l9zgx4zeLx575P1g9+rasYvQ4fmM7k8fnTXIB
	bFFcNimpOZllqUX6dglcGZN3z2QqOMxWsafrAHMD4yHWLkZODgkBE4kruyewQdhiEhfurQey
	uTiEBJYxShxpfccCU7R76jaoxCJGiXn/f4ElhAR+MUpMuqQCYrMJqEl8+XKYvYuRg0NEQF+i
	rUUDpJ5ZYCujxOaPu1kh6m0lzi+ZDbaNU8BO4tOPvYwgtrCAq8T3ib1gNSwCqhIvz98Gq+EF
	qj9xZiYrhC0o8WPyPbC9zAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12QsIiAkcSEv5fZIUpE
	JPa9eMcIco+EwEd2iW8dtxghdglIfJt8iAWiV1Zi0wFmiH8lJQ6uuMEygVFiFpLNs5BsnoVk
	8ywkKxYwsqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECIneCTsY7x2wPsSYDLR+IrOUaHI+
	MPrzSuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4
	xiM799GrAKNLL7iOt5u92rJpVxzf8t8LOlONohn95n5smGUWVplsuOHksUIFteyVZ3YdDtn9
	cNOuTMfX/UYu2/tddv6e/sqvwnjZx9Z7YX57UgruPfeybF23809Q1uSWQ1rh97aU/98bG/2S
	hWH1nYt9YS+PbvpR7ZKmtv39g0+Jd5ZM9VEvVGIpzkg01GIuKk4EABHZLi/0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAd0z79WDDA4dlbKYs34Nm8Xk3V2s
	FpcXXgISu+awWSz/tY7FYveup6wObB47Z91l9zgx4zeLx575P1g9+rasYvQ4fmM7k8fnTXIB
	bFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QHco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDMm757JVHCYrWJP1wHmBsZD
	rF2MnBwSAiYSu6duY4OwxSQu3FsPZHNxCAksYpSY9/8XC0hCSOAXo8SkSyogNpuAmsSXL4fZ
	uxg5OEQE9CXaWjRA6pkFtjJKbP64mxWi3lbi/JLZYEM5BewkPv3YywhiCwu4Snyf2AtWwyKg
	KvHy/G2wGl6g+hNnZrJC2IISPybfA9vLLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgY
	SUz4e5kdokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGcGp4Jr2DcVWDxSFGAQ5GJR7eBmP1ICHWxLLiytxDjBIczEoivBYrgUK8KYmVValF
	+fFFpTmpxYcYk4EencgsJZqcD0xbeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1O
	TS1ILYLZwsTBKdXA6Gzr+v/qnddLOL2yf2Xu+XWIa13wtMzVAde8dXs9bLbo7i/5+3ra3FUX
	3/47Oi3UWyIn7SvrZmsFwb0mnKd37tsptOi68cMNOvwWTkcn3o7ZvNndPVrG8E3P2eitGr6z
	Mhq6DvKcuTFvcfmTVYVlUWdm3nW9veer/Syt7sPLFSseyqcwOD9SvqHEUpyRaKjFXFScCACU
	gXrxUQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning:

drivers/video/backlight/lp8788_bl.c:55:25: warning: symbol 'default_bl_config' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lp8788_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
index 980855e..e49905d 100644
--- a/drivers/video/backlight/lp8788_bl.c
+++ b/drivers/video/backlight/lp8788_bl.c
@@ -52,7 +52,7 @@ struct lp8788_bl {
 	struct pwm_device *pwm;
 };
 
-struct lp8788_bl_config default_bl_config = {
+static struct lp8788_bl_config default_bl_config = {
 	.bl_mode    = LP8788_BL_REGISTER_ONLY,
 	.dim_mode   = LP8788_DIM_EXPONENTIAL,
 	.full_scale = LP8788_FULLSCALE_1900uA,
-- 
1.7.10.4


