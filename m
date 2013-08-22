Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3HVCQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:16:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13821 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3HVCQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:16:19 -0400
X-AuditID: cbfee68f-b7f436d000000f81-7a-52157472e426
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] pcmcia: bfin_cf: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 11:16:17 +0900
Message-id: <002501ce9edd$95cbb740$c16325c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e3ZW0yWqkn3rITp+VdERxCde4wA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zY92iEtEggwMXOS3mrF/DZnF54SVW
	i8u75rBZTO77xeLA4nFixm8Wj81L6j36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4+nf/awF
	09krNl7+yNjA+Ju1i5GTQ0LAROLPl43MELaYxIV769m6GLk4hASWMUpcfbiOEabo7qo+dojE
	IkaJRc2/mCCcX4wSJ75MAqtiE1CT+PLlMDuILSKgK7Hq+S6gsRwczAIZEm+upoKYwgL+Ep8m
	x4NUsAioSmydtIEFxOYVsJV4/eQ1M4QtKPFj8j2wOLOAlsT6nceZIGx5ic1r3oJNlBBQl3j0
	VxfEFBHQk/gyrwyiQkRi34t3jCCHSQhsYpc48W4fK8QqAYlvkw+xQLTKSmw6APWupMTBFTdY
	JjCKzUKyeBaSxbOQLJ6FZMUCRpZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCHx1b+D8e4B
	60OMyUDrJzJLiSbnA+MzryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2MIdM02T8m2X/cO1M5fjlDFqez9fPNTT+MvgfvYRcvaD6buP/Gn5UxWv8O
	GQZtbuPd1dbLeGj7FeYMqdRlFn6drh861Gct0yvoE3hwzy19gv05w4NSDTv0p57z6V8uYd9h
	F7ss+qFD9KtT1bvrnlz8VVezrGj5sQsPW+YL9Wv0m+Y8kZYtP62txFKckWioxVxUnAgA+2qP
	W8UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgG5RiWiQwe+nrBZz1q9hs7i88BKr
	xeVdc9gsJvf9YnFg8Tgx4zeLx+Yl9R59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmPH0737WgunsFRsvf2RsYPzN2sXIySEhYCJxd1UfO4QtJnHh3nq2
	LkYuDiGBRYwSi5p/MUE4vxglTnyZxAhSxSagJvHly2GwDhEBXYlVz3cxdzFycDALZEi8uZoK
	YgoL+Et8mhwPUsEioCqxddIGFhCbV8BW4vWT18wQtqDEj8n3wOLMAloS63ceZ4Kw5SU2r3kL
	NlFCQF3i0V9dEFNEQE/iy7wyiAoRiX0v3jFOYBSYhWTQLCSDZiEZNAtJywJGllWMoqkFyQXF
	Sem5hnrFibnFpXnpesn5uZsYwdH7TGoH48oGi0OMAhyMSjy8F3aKBAmxJpYVV+YeYpTgYFYS
	4ZXWEg0S4k1JrKxKLcqPLyrNSS0+xJgM9OdEZinR5HxgYskriTc0NjEzsjQyszAyMTcnTVhJ
	nPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsb5vz2MpMN28zgYudnJ+SxTynB14a4wV77tIp1e
	HjPhLdfsnVJTfRaE89/0VVX62BcvIPm87dWt6KVczfLZh/uYvxw6Jr5u7hqZG7UOEr9L//Qt
	FuU4mGVUIXg22KNA9Oddpg8ePvrHupdwxr7iKwh8+bxUd2Jjc9HsOTE5ViJajInh6YxvlFiK
	MxINtZiLihMBrjfvSyIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pcmcia/bfin_cf_pcmcia.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pcmcia/bfin_cf_pcmcia.c b/drivers/pcmcia/bfin_cf_pcmcia.c
index ed3b522..624d127 100644
--- a/drivers/pcmcia/bfin_cf_pcmcia.c
+++ b/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -281,7 +281,6 @@ fail2:
 fail0:
 	gpio_free(cf->cd_pfx);
 	kfree(cf);
-	platform_set_drvdata(pdev, NULL);
 
 	return status;
 }
@@ -296,7 +295,6 @@ static int bfin_cf_remove(struct platform_device *pdev)
 	del_timer_sync(&cf->timer);
 	iounmap((void __iomem *)cf->socket.io_offset);
 	release_mem_region(cf->phys_cf_io, SZ_8K);
-	platform_set_drvdata(pdev, NULL);
 	kfree(cf);
 	return 0;
 }
-- 
1.7.10.4


