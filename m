Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3COJQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:16:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61231 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3COJQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:16:50 -0400
X-AuditID: cbfee68d-b7f786d000005188-2e-5142e701150b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] gpio: mc33880: use dev_err() instead of printk()
Date: Fri, 15 Mar 2013 18:16:49 +0900
Message-id: <006801ce215d$d2cc90e0$7865b2a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hXdKzz0gcn8GSSfqrA8bvTFEHzQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t8zA13G506BBnc+Kltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mvi/WBatZK7qm9LI2MK5j6WLk4JAQMJH42FbTxcgJZIpJXLi3
	nq2LkYtDSGAZo8Sb6TsYIRImEtO+7mKCSCxilNixdRULhDObSWLyytusIFVsAmoSX74cZgex
	RQT0JG5c6ADrZhYoknjeNQusRljAUeL3jvdsIDaLgKrE7rNNYDW8ArYSK69vYYWwBSV+TL7H
	AtGrJbF+53EmCFteYvOat8wQV6tLPPqrC2KCrNrTagVRISKx78U7RpDTJASa2SVa79xghVgl
	IPFt8iGoh2UlNh1ghvhLUuLgihssExjFZiFZPAvJ4llIFs9CsmIBI8sqRtHUguSC4qT0IkO9
	4sTc4tK8dL3k/NxNjJAo6d3BePuA9SHGZKD1E5mlRJPzgVGWVxJvaGxmZGFqYmpsZG5pRpqw
	kjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG+eCfBelTEmMf8vsFL3UUYerL0JwV
	YfDwXjHvrNspQU/bD869cjO8u7XQkLdHL9zs5q/kleFa8clnLeyF/34xvtJ4qvn7xCc/BFeF
	doS6vuA6ZvxaYXfNg/uW5VFzDtg3zX+qeX356vlvPwnce7b3OruHZ/YhkV8yL7Y1/xC6z/ty
	e6QMh0CKEktxRqKhFnNRcSIAtCYNragCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAV3G506BBucXy1tc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjL4v1gWrWSu6pvSyNjCu
	Y+li5OSQEDCRmPZ1FxOELSZx4d56ti5GLg4hgUWMEju2rmKBcGYzSUxeeZsVpIpNQE3iy5fD
	7CC2iICexI0LHYwgNrNAkcTzrllgNcICjhK/d7xnA7FZBFQldp9tAqvhFbCVWHl9CyuELSjx
	Y/I9FoheLYn1O48zQdjyEpvXvGXuYuQAukhd4tFfXRATZNWeViuIChGJfS/eMU5gFJiFZNAs
	JINmIRk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBUfhMegfjqgaLQ4wCHIxK
	PLwODx0DhVgTy4orcw8xSnAwK4nwfrzoFCjEm5JYWZValB9fVJqTWnyIMRnoz4nMUqLJ+cAE
	kVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjMs9W8/xdr3/
	6avqvtw6TbOpfsfBzuhgmQfOLRM6jy3eFxN+8pO14JQrvds3XJ/Lr9wz79/m+kX99Z4xibdc
	5U8wBL0QYF/cuFe89cbsP5kzbk35v6n88tfMq2Hi7cfcTsnyrsqRfX3iWomzaGTnLO+lk7uE
	zsdPSnvJ8mnJPqmPRmZMwjJfo5RYijMSDbWYi4oTATrvk0sGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_err() is more preferred than printk().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-mc33880.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-mc33880.c b/drivers/gpio/gpio-mc33880.c
index b161489..3395879 100644
--- a/drivers/gpio/gpio-mc33880.c
+++ b/drivers/gpio/gpio-mc33880.c
@@ -130,7 +130,8 @@ static int mc33880_probe(struct spi_device *spi)
 		ret = mc33880_write_config(mc);
 
 	if (ret) {
-		printk(KERN_ERR "Failed writing to " DRIVER_NAME ": %d\n", ret);
+		dev_err(&spi->dev, "Failed writing to " DRIVER_NAME ": %d\n",
+			ret);
 		goto exit_destroy;
 	}
 
-- 
1.7.2.5

