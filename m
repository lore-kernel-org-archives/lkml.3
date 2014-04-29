Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbaD2I1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:27:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59546 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbaD2I1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:27:47 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-4b-535f62826449
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Magnus Damm'" <damm@opensource.se>
References: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
In-reply-to: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
Subject: [PATCH 3/4] clocksource: sh_mtu2: remove unnecessary OOM messages
Date: Tue, 29 Apr 2014 17:27:46 +0900
Message-id: <002f01cf6384$e62522a0$b26f67e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9jhHgACh38PpSJS1ewNnY0fIuPzwAAFX4g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zY92mpPhgg38f9SzuP77FZDHvs6zF
	5YWXWC0u75rDZrF501RmB1aPO9f2sHm8O3eO3WPlj0vsHn1bVjF6fN4kF8AaxWWTkpqTWZZa
	pG+XwJXx+YBHwU/Wig+XExsY37B0MXJwSAiYSHTNSO9i5AQyxSQu3FvP1sXIxSEksIxR4n/z
	MmaIhInEsbtL2UFsIYFFjBJd9xwgin4zSux9eR0swSagJvHly2EwW0TAQOL16d/sIEXMApMY
	Ja5dXcgI0W0rMeHETTYQm1PATmLOkX1gtrCAl8T0fZtYQWwWAVWJqf1/wep5gernr22AsgUl
	fky+xwJiMwtoSazfeZwJwpaX2LzmLTPEN+oSj/7qQtxgJNHV9AeqRERi34t3jCD3SAhcYpdY
	N3krO8QuAYlvkw9BQ0JWYtMBqIclJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4o
	TkovMtQrTswtLs1L10vOz93ECInR3h2Mtw9YH2JMBlo/kVlKNDkfGON5JfGGxmZGFqYmpsZG
	5pZmpAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCYFy1bvNlE/uLdc0Vr23q/
	avptdBVwD+i5eLLzsMuBpFM7j7Mdvb+ohcvkfPzX+MOJm6YtWm32MVrJhvlom+PkYx+l9+X8
	UtNX6FJjPddw92rG++ub0xiWlPv923S/uaNtSZzhgoMN/Qdz11Z/fda08+wkTdEa1/3r1+Z+
	YjByn8VmIKwaJ++sxFKckWioxVxUnAgARumasOcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAd2mpPhgg59ztC3uP77FZDHvs6zF
	5YWXWC0u75rDZrF501RmB1aPO9f2sHm8O3eO3WPlj0vsHn1bVjF6fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8fmAR8FP1ooPlxMbGN+wdDFyckgImEgcu7uU
	HcIWk7hwbz0biC0ksIhRouueQxcjF5D9m1Fi78vrYEVsAmoSX74cBrNFBAwkXp/+zQ5SxCww
	iVHi2tWFjBDdthITTtwEm8QpYCcx58g+MFtYwEti+r5NrCA2i4CqxNT+v2D1vED189c2QNmC
	Ej8m3wO7jllAS2L9zuNMELa8xOY1b5m7GDmALlWXePRXF+IGI4mupj9QJSIS+168Y5zAKDQL
	yaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCU8AzqR2MKxssDjEK
	cDAq8fAaRMUFC7EmlhVX5h5ilOBgVhLhzbeKDxbiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHk
	fGB6yiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRv2UY+Ze
	k3RD3rOsDuE/t/fdchFVse9rHvu2H/ew239/sauC9IvPsayCkZZCe+Om37nsr2z2J2HCqoXb
	BH/k5EzJZjUTDzg0NfRyWtCMtZ/EJgkrOd3kdfzs5yGw62DRGbE9FxKyFDYvDv8d+GNqTFKo
	1R9LQxbrBHu7hft/CD/yvXR1XVESrxJLcUaioRZzUXEiAHGzX+dFAwAA
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
 drivers/clocksource/sh_mtu2.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index e30d76e..e6bee62 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -349,10 +349,8 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 	}
 
 	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (p == NULL)
 		return -ENOMEM;
-	}
 
 	ret = sh_mtu2_setup(p, pdev);
 	if (ret) {
-- 
1.7.10.4


