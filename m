Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaKMItw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:49:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51351 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaKMItu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:49:50 -0500
X-AuditID: cbfee68e-f79b46d000002b74-81-546470ac72fa
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: pratikp@codeaurora.org, mathieu.poirier@linaro.org,
        gregkh@linuxfoundation.org, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 3/3] coresight-replicator: remove .owner field for driver
Date: Thu, 13 Nov 2014 14:12:49 +0530
Message-id: <1415868169-13325-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415868169-13325-1-git-send-email-pankaj.dubey@samsung.com>
References: <1415868169-13325-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWyRsSkSndNQUqIQfNxPovmxevZLDY9vsZq
	cXnXHDaLrXsOMFks2vqF3eLbfXMHNo/Lfb1MHneu7WHz2D93DbvH5iX1Hn1bVjF6fN4kF8AW
	xWWTkpqTWZZapG+XwJWxt+0Ee8FZ1orOx7tYGxhPs3QxcnJICJhIfD93EcoWk7hwbz1bFyMX
	h5DAUkaJxj1NjDBFp9e1sYHYQgKLGCUuf9eHKJrAJHH79lywIjYBXYkn7+cyg9giAm4SNxo7
	mEBsZoFaiRPrloHFhQU8JSZtWcAOYrMIqEos290M1MvBwSvgIXHmVwmIKSGgIDFnkg1IBSdQ
	9aVjP1gh1npInNy0gBVkrYTAZHaJ6+uvMEKMEZD4NvkQC0SvrMSmA8wQJ0tKHFxxg2UCo/AC
	RoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIHhffrfs74djDcPWB9iFOBgVOLhfcmSEiLE
	mlhWXJl7iNEUaMNEZinR5HxgFOWVxBsamxlZmJqYGhuZW5opifMmSP0MFhJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cCYZW++hOFZNT+T7NbYqTeXdu1UjD7zzMD78+7D556zzT7kH1bN8ujM
	lUCdrS/+XWQ1ZTULeL3LJUjS3j7BtDvwu0j6zhTZ2EdXJ2Yfc9Z4L3BrwQXl81nZQd82t8YJ
	cuZO8DgZ+U82UuN7yfT3ni+2dCzKvP1e+gWfsUX4OeHiaDFmThV2VnslluKMREMt5qLiRADQ
	7aASagIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd01BSkhBl9fsFk0L17PZrHp8TVW
	i8u75rBZbN1zgMli0dYv7Bbf7ps7sHlc7utl8rhzbQ+bx/65a9g9Ni+p9+jbsorR4/MmuQC2
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGXvbTrAXnGWt6Hy8i7WB8TRL
	FyMnh4SAicTpdW1sELaYxIV768FsIYFFjBKXv+t3MXIB2ROYJG7fnssIkmAT0JV48n4uM4gt
	IuAmcaOxgwnEZhaolTixbhlYXFjAU2LSlgXsIDaLgKrEst3NQL0cHLwCHhJnfpWAmBICChJz
	JtmAVHACVV869oMVYq2HxMlNC1gnMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc
	Pc+kdzCuarA4xCjAwajEw/uCJSVEiDWxrLgy9xCjBAezkghvkw5QiDclsbIqtSg/vqg0J7X4
	EKMp0E0TmaVEk/OBkZ1XEm9obGJuamxqaWJhYmapJM57sNU6UEggPbEkNTs1tSC1CKaPiYNT
	qoGR66KI5iMu6bIWkR8hEyMLhcUef5Lk+PXlgKXNb415l3ef+x6c2yU43TrQ859W5cs102sK
	lpyM33LoW4UwX3aR9Jonsjus+kT38vy6Lrbt0b//13OiP6bME6x7PrnEwo8zaM++d7MOSd1c
	cdh0duAPhp/m/mKHMiI2ZHz9HJn7eEVZC+u7FRV9SizFGYmGWsxFxYkAHD37dbQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need of .owner field for driver using
module_platform_driver.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/coresight/coresight-replicator.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/coresight/coresight-replicator.c b/drivers/coresight/coresight-replicator.c
index c879039..a2dfcf9 100644
--- a/drivers/coresight/coresight-replicator.c
+++ b/drivers/coresight/coresight-replicator.c
@@ -117,7 +117,6 @@ static struct platform_driver replicator_driver = {
 	.remove         = replicator_remove,
 	.driver         = {
 		.name   = "coresight-replicator",
-		.owner	= THIS_MODULE,
 		.of_match_table = replicator_match,
 	},
 };
-- 
1.7.9.5

