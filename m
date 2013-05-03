Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707Ab3ECG33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:29:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63094 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762633Ab3ECG31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:29:27 -0400
X-AuditID: cbfee691-b7fe56d000004b96-f2-51835945545a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 13/42] rtc: rtc-da9055: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:29:25 +0900
Message-id: <001b01ce47c7$8e89c2a0$ab9d47e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx43IkWF5atgcQtC1EJagUnMlpA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zI13XyOZAgyW3NCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK+PrhK1vBX9aK9uOn2BsYv7F0MXJySAiYSPQtugdli0lcuLeerYuRi0NIYBmjxL1V
	85hgira0TGOCSExnlLj67QozhPOLUWLu3wtg7WwCahJfvhxm72Lk4BAR0Jdoa9EAqWEW6GaU
	eNQ8lxmkRlggWOL84T4wm0VAVaL71ko2kHpeAUuJizsEQMK8AoISPyZDXMQsoCWxfudxJghb
	XmLzmrfMEAcpSOw4+5oRxBYR0JNYdHgzI0SNiMS+F+8YQfZKCBxjlzh3fy0TxC4BiW+TD7GA
	7JIQkJXYdABqjqTEwRU3WCYwis1CsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UWmesWJucWl
	eel6yfm5mxghsTdxB+P9A9aHGJOB1k9klhJNzgfGbl5JvKGxmZGFqYmpsZG5pRlpwkrivOot
	1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGI1CLq+NvfV4wrzar9eD46+8Cw9YK3NvBZ9n
	kJP5D89VGgs6fojodd/5v29izDT11J37GnM3T2C8aX5DRi2ZveHfLVfVDKvgLd8uP9kSKa1c
	rijG3vSqhk9ZUWtx/fxrURav3NOi3qbZTb7jH6Sy9Iw7T/GlyKjUuq9+fX+vZXOuer8qUjlu
	lRJLcUaioRZzUXEiAH7YFavTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV3XyOZAg89nVS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzPj64StbwV/Wivbjp9gbGL+xdDFyckgImEhs
	aZnGBGGLSVy4t56ti5GLQ0hgOqPE1W9XmCGcX4wSc/9eAOtgE1CT+PLlMHsXIweHiIC+RFuL
	BkgNs0A3o8Sj5rnMIDXCAsES5w/3gdksAqoS3bdWsoHU8wpYSlzcIQAS5hUQlPgx+R7YSGYB
	LYn1O48zQdjyEpvXvGWGOEhBYsfZ14wgtoiAnsSiw5sZIWpEJPa9eMc4gVFgFpJRs5CMmoVk
	1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf2M+kdjKsaLA4xCnAwKvHwKrQ0
	BQqxJpYVV+YeYpTgYFYS4XX7ARTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGDSySuJNzQ2
	MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxiQrO3E3iTPT9d+wfdp/
	5FPFbonnnqvZls7x6fv2e/7XVnbp8Ol1urc0PRaaLDy5YTrnzdsb9xj0m+9mF3biM8r8/Frx
	pcnDotMKgp4CL3b+mR19PHBlsphU5TqLsBnbuVwkMiVsZV28kvLWvUzyTzKcdu7oO1lrpgXn
	Lt9Qn9/apPYi9JbfFyWW4oxEQy3mouJEAFGiKaMwAwAA
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
 drivers/rtc/rtc-da9055.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-da9055.c b/drivers/rtc/rtc-da9055.c
index 73858ca..df4cf16 100644
--- a/drivers/rtc/rtc-da9055.c
+++ b/drivers/rtc/rtc-da9055.c
@@ -317,8 +317,6 @@ err_rtc:
 
 static int da9055_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


