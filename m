Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbaD2I2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:28:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13210 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbaD2I2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:28:19 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-06-535f62a1ff64
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Magnus Damm'" <damm@opensource.se>
References: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
In-reply-to: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
Subject: [PATCH 4/4] clocksource: sh_tmu: remove unnecessary OOM messages
Date: Tue, 29 Apr 2014 17:28:17 +0900
Message-id: <003001cf6384$f8b02500$ea106f00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9jhHgACh38PpSJS1ewNnY0fIuPzwAAG9pQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY92FSfHBBlPvGVvcf3yLyWLeZ1mL
	ywsvsVpc3jWHzWLzpqnMDqwed67tYfN4d+4cu8fKH5fYPfq2rGL0+LxJLoA1issmJTUnsyy1
	SN8ugSvjzYotbAWfWCt+77rC3MD4lKWLkYNDQsBE4vw+mS5GTiBTTOLCvfVsXYxcHEICyxgl
	lj++zQpTc+FNGER8EaPEmvYDjBDOb0aJ/5t+MIN0swmoSXz5cpgdxBYRMJB4ffo3O0gRs8Ak
	RolrVxcygiSEBGwlJpy4yQZicwrYScw5sg/MFhbwlHh+9QFYDYuAqsT+lWfAhvIC1W9cd5oJ
	whaU+DH5HguIzSygJbF+53EmCFteYvOat8wQl6pLPPqrC3GDkcSxw3+gykUk9r14B3a0hMA9
	don//1exQewSkPg2+RA0JGQlNh1ghoSEpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKp
	BckFxUnpRcZ6xYm5xaV56XrJ+bmbGCFx2r+D8e4B60OMyUDrJzJLiSbnA+M8ryTe0NjMyMLU
	xNTYyNzSjDRhJXHe+w+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwNnNz1czUcKhYsCSf
	LWCWunWd3s6XUWt5+vY7G3CslPmh6DT37ePbgvMEg0RTE2tvG1x15vOXjBFWY/iyrtsznOXW
	2tlXNN7seR+S5d3QMOlBy1oGXWs3iznvj3sqfjB0yp3EHXE4q8E7vueN16H0wxFSd9k3sj0K
	ODlDvF9skdnim0Kf5/xSYinOSDTUYi4qTgQASUrfAOkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd2FSfHBBmu6DSzuP77FZDHvs6zF
	5YWXWC0u75rDZrF501RmB1aPO9f2sHm8O3eO3WPlj0vsHn1bVjF6fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8WbFFraCT6wVv3ddYW5gfMrSxcjBISFgInHh
	TVgXIyeQKSZx4d56ti5GLg4hgUWMEmvaDzBCOL8ZJf5v+sEMUsUmoCbx5cthdhBbRMBA4vXp
	3+wgRcwCkxglrl1dyAiSEBKwlZhw4iYbiM0pYCcx58g+MFtYwFPi+dUHYDUsAqoS+1eeARvK
	C1S/cd1pJghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yQ1ytLvHory7EDUYSxw7/gSoXkdj3
	4h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZwGnknv
	YFzVYHGIUYCDUYmHtyMmLliINbGsuDL3EKMEB7OSCG++VXywEG9KYmVValF+fFFpTmrxIcZk
	oEcnMkuJJucDU1ReSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBK
	NTAKiBqVzS0r8y/Q23ql3vbvtZwXvxr1Z/F5Nd5f8ulJy7ynGxeGMP9Onl2Vs267h5OQdVjY
	s/f/9zHzaVTOmM79weXfq7tH+JX2xfqsfsOZIXNeUG69/4Pzi+axS51eut6b50p/fa6eR+WN
	hPNbKuR8nZzmspf8Mb+0rD7pevf1mXNCyhO+bFRQYinOSDTUYi4qTgQAUsyT9UcDAAA=
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
 drivers/clocksource/sh_tmu.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index ecd7b60..b62f28c 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -514,10 +514,8 @@ static int sh_tmu_probe(struct platform_device *pdev)
 	}
 
 	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (p == NULL)
 		return -ENOMEM;
-	}
 
 	ret = sh_tmu_setup(p, pdev);
 	if (ret) {
-- 
1.7.10.4


