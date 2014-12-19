Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaLSRlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:41:12 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31147 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaLSRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:40:54 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-21-54946324caf8
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v2 3/3] iio: core: Get rid of misleading comment
Date: Fri, 19 Dec 2014 18:39:26 +0100
Message-id: <1419010766-13557-4-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1419010766-13557-1-git-send-email-k.wrona@samsung.com>
References: <1419010766-13557-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4NV2V5CkhBgt+qlpsnLGe1eJB0yom
	i1PL9jNZ7Pr/htnibNMbdoslk+ezWsw78o7F4vKuOWwWv3cdY7fYs24LkwOXx85Zd9k9PnyM
	89i0qpPNY8mbQ6we55uPMHr0bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXxvuu42wFZ1grHi54
	ytLAeJali5GTQ0LAROLC3JWMELaYxIV769m6GLk4hASWMkrs+d/DDOH0MUkse/mODaSKTUBd
	onnHYrCEiMAFRonjh7awgDjMAmsYJc6cncAOUiUs4CDRv3E1E4jNIqAqsWfTarB9vALOEg86
	24H2cQDtU5CYM8kGJMwp4CKx/Eov2AIhoJL3/d2sExh5FzAyrGIUTS1NLihOSs811CtOzC0u
	zUvXS87P3cQICcQvOxgXH7M6xCjAwajEw/uyanKIEGtiWXFl7iFGCQ5mJRFeQ/cpIUK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoYmzJ2bZs38QvLW7O9LXZFq/b8E1zuwfz+W6C17NyHERfuzQ2b
	ELy9Nf7ecfs3s6Ue51jd+hY4o94998S9GY83C3PGrsx87vNSvYQtsvq+yZxrO/9snPtkQojK
	9Bkf9jmt/iJ/4quU5YulNxnVRLN4Xz04nnMvLPbVGZ7GMzX9PA/F7+5csibrVLMSS3FGoqEW
	c1FxIgDDQIDJIgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment did not fit here.  It explains why devm_kmalloc
uses dr_alloc.  Generally is not needed at all.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
---
 drivers/iio/industrialio-core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index af3e76d..1d030ae 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1035,7 +1035,6 @@ struct iio_dev *devm_iio_device_alloc(struct device *dev, int sizeof_priv)
 	if (!ptr)
 		return NULL;
 
-	/* use raw alloc_dr for kmalloc caller tracing */
 	iio_dev = iio_device_alloc(sizeof_priv);
 	if (iio_dev) {
 		*ptr = iio_dev;
-- 
1.7.9.5

