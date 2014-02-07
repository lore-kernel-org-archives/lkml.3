Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaBGILL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:11:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22752 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaBGILJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:11:09 -0500
X-AuditID: cbfee690-b7f266d00000287c-a4-52f4951cb473
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Wolfgang Grandegger'" <wg@grandegger.com>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 08/10] rtc: rtc-rx8025: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:11:08 +0900
Message-id: <001101cf23dc$27c876a0$775963e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAUiYQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zY12ZqV+CDOYfVbZYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djBZL7+1kdWDz2DPxJJvHx0u3GT1OzPjN4tG3ZRWjx/R5P5k8Pm+S
	C2CL4rJJSc3JLEst0rdL4Mr4f6OLuWAJa8X2zyfZGxjXsHQxcnJICJhITFs8nQ3CFpO4cG89
	kM3FISSwjFFi9YtLjDBFh08vYIRITGeUmPF6G1TVL0aJvceWsIJUsQmoSXz5cpi9i5GDQ0RA
	X6KtRQOkhllgF6PE29YrYJOEBGwlfn2GqOcUsJNYdOIsmC0s4C5xZMM9sJNYBFQlWl4fZgKZ
	wwtUf3iyDUiYV0BQ4sdkiBJmAS2J9TuPM0HY8hKb17xlBimXEFCXePRXFyQsImAksaTzJ1S5
	iMS+F+/A7pcQ+MguceHFe1aIVQIS3yYfYoHolZXYdIAZ4l9JiYMrbrBMYJSYhWTzLCSbZyHZ
	PAvJigWMLKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQqJ3wg7GewesDzEmA62fyCwlmpwP
	jP68knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDs
	v7A8uFB5/b47qio2G7kN71bl+md79Sf8vhl28bF3JfuOoiM1SSGTXsYurOcu3q/buZanMafo
	DY+QgkJS2MybLFX7/wmbLXGes+zoP+ncNXwX7PXLW571Pjl6zGHuEdvZjm7Pr20qMdb50hd9
	mc3Hs4/X3EdjmnDDHN/j+h32PG1TVmdldSuxFGckGmoxFxUnAgCMZAVK9AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQV2ZqV+CDLYfl7dYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djBZL7+1kdWDz2DPxJJvHx0u3GT1OzPjN4tG3ZRWjx/R5P5k8Pm+S
	C2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8f9GF3PBEtaK7Z9Psjcw
	rmHpYuTkkBAwkTh8egEjhC0mceHeerYuRi4OIYHpjBIzXm+Dcn4xSuw9toQVpIpNQE3iy5fD
	7F2MHBwiAvoSbS0aIDXMArsYJd62XgGbJCRgK/HrM0Q9p4CdxKITZ8FsYQF3iSMb7oFtZhFQ
	lWh5fZgJZA4vUP3hyTYgYV4BQYkfkyFKmAW0JNbvPM4EYctLbF7zlhmkXEJAXeLRX12QsIiA
	kcSSzp9Q5SIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1
	kvNzNzGCU8Mz6R2MqxosDjEKcDAq8fCeWPo5SIg1say4MvcQowQHs5II78+GL0FCvCmJlVWp
	RfnxRaU5qcWHGJOB/pzILCWanA9MW3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnN
	Tk0tSC2C2cLEwSnVwLho28rglssHRKU0gyTUFdsuc5c88vkVknn1hvKPDes8hM7+y1SUNfLK
	specdjfo4/OL/1KfMxs8FVKv1Zm16bHLcw7dNe3LbgbskxPR37312UznxaYik7emC674Y94+
	44L9IaNHS6R6pl/dP4PFMMDb6mTNtPdJf5qYQhQneNvtPMl2LK72XbASS3FGoqEWc1FxIgCh
	sK6CUQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rx8025.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index 8fa23ea..e6298e0 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -551,7 +551,6 @@ static int rx8025_probe(struct i2c_client *client,
 
 	rx8025 = devm_kzalloc(&client->dev, sizeof(*rx8025), GFP_KERNEL);
 	if (!rx8025) {
-		dev_err(&adapter->dev, "failed to alloc memory\n");
 		err = -ENOMEM;
 		goto errout;
 	}
-- 
1.7.10.4


