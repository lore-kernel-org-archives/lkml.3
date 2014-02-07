Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaBGICt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:02:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:15091 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaBGICr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:02:47 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-ac-52f4932612aa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Kevin Hilman'" <khilman@linaro.org>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 02/10] rtc: rtc-davinci: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:02:45 +0900
Message-id: <000b01cf23da$fc466bf0$f4d343d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAEOYA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zQ121yV+CDKau5rRYcvEqu8Wc9WvY
	LC4vvMRq8fXwCkaLy7vmsFns7+xgdGDz2DPxJJvHnWt72DxOzPjN4tG3ZRWjx/R5P5k8Pm+S
	C2CL4rJJSc3JLEst0rdL4Mp4dOUsY8EltopXa64zNjDuZ+1i5OCQEDCROHhCoYuRE8gUk7hw
	bz1bFyMXh5DAMkaJ/nkLWCASJhITDzRBJRYxSqxY2MME4fxilHiw9hwbSBWbgJrEly+H2UGm
	igjoS7S1aIDUMAtsYZS49HEZO0iNkICtxK/PS1hBbE4BO4lFJ86C2cICHhJnpvUwgtgsAqoS
	d1/MA9vMC1S/edtDJghbUOLH5HtgcWYBLYn1O48zQdjyEpvXvGWG+EZd4tFfXZCwiICRxPOj
	d6FKRCT2vXjHCHKPhMBHdomPi9awQ+wSkPg2+RALRK+sxKYDzBAPS0ocXHGDZQKjxCwkm2ch
	2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRESvb07GG8fsD7EmAy0fiKz
	lGhyPjD680riDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBUdhlvaHB0/MR+Rv5FZmWSag8n3KJqXzfTvWX01OWq5/7HdXocpD51Lu29Q7sbnsLPWc8
	urmrcbOz11SDvZr7Hh+S+Bo349jm9xutVJY/r0je99bl4fcPyrZOWkVFxk+lcqSvKQfITDiz
	ZOYa94jbwk2sfkKnkj+kNNY5/29vZTob7WP+6d/k90osxRmJhlrMRcWJABVnIn70AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAV21yV+CDP5sY7VYcvEqu8Wc9WvY
	LC4vvMRq8fXwCkaLy7vmsFns7+xgdGDz2DPxJJvHnWt72DxOzPjN4tG3ZRWjx/R5P5k8Pm+S
	C2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8ejKWcaCS2wVr9ZcZ2xg
	3M/axcjJISFgIjHxQBMbhC0mceHeeiCbi0NIYBGjxIqFPUwQzi9GiQdrz4FVsQmoSXz5cpi9
	i5GDQ0RAX6KtRQOkhllgC6PEpY/L2EFqhARsJX59XgK2gVPATmLRibNgtrCAh8SZaT2MIDaL
	gKrE3RfzWEBsXqD6zdseMkHYghI/Jt8DizMLaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIi
	AkYSz4/ehSoRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqX
	rpecn7uJEZwcnknvYFzVYHGIUYCDUYmH98TSz0FCrIllxZW5hxglOJiVRHh/NnwJEuJNSays
	Si3Kjy8qzUktPsSYDPToRGYp0eR8YOLKK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJ
	anZqakFqEcwWJg5OqQbGHiFZPd7FFvcZJxgyb53KuKbunaaBl9ba1Ezd6REpbFqWGV03Nyqs
	/1kd/sZg+aPoQl/pM+flbmj9+6sdcadk/at3ETP4jS1eM/TXWEy8MvP28x1LH2uyhe36LB5o
	cYrnfu52sec2R5SMn3L+bq6dcdbCMool0/ylS9keJpPSis2X7XiPmAUosRRnJBpqMRcVJwIA
	Vi3hTVIDAAA=
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
 drivers/rtc/rtc-davinci.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index d3e70f3..c0a3b59 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -484,10 +484,8 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	davinci_rtc = devm_kzalloc(&pdev->dev, sizeof(struct davinci_rtc), GFP_KERNEL);
-	if (!davinci_rtc) {
-		dev_dbg(dev, "could not allocate memory for private data\n");
+	if (!davinci_rtc)
 		return -ENOMEM;
-	}
 
 	davinci_rtc->irq = platform_get_irq(pdev, 0);
 	if (davinci_rtc->irq < 0) {
-- 
1.7.10.4


