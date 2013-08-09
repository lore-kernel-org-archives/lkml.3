Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3HIEEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:04:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41580 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3HIEEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:04:37 -0400
X-AuditID: cbfee68f-b7f436d000000f81-3f-52046a537318
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Yehuda Sadeh'" <yehuda@inktank.com>,
        "'Sage Weil'" <sage@inktank.com>, "'Alex Elder'" <elder@inktank.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 1/3] block: rbd: use NULL instead of 0
Date: Fri, 09 Aug 2013 13:04:35 +0900
Message-id: <001801ce94b5$8f590390$ae0b0ab0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: Ac6UtU7bIwcokOXeQde+7urIF0Y8Zw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zA92QLJYgg6YCiznr17BZ/LzyhdHi
	8sJLrBaXd81hs9h9oovVYu3lY+wObB6HGlewe5yY8ZvFo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDJOrdzNVtDJUbFq33HmBsZrbF2MHBwSAiYSrzbJdjFyApliEhfurQcKc3EICSxjlOib
	c54JImEi0X1mFlRiOqPEvV3/oJxfjBINf3aygFSxCahJfPlymB3EFhHQlVj1fBczSBGzwFqg
	orazrCDrhAXMJGacTACpYRFQlWg+OpsNxOYVsJRYf7OTFcIWlPgx+R7YTGYBLYnN25pYIWx5
	ic1r3jJDXKQgsePsa0aIuIjEvhfvGCH26kmsPPsS6upD7BJ/DopC7BKQ+Db5EAvEx7ISmw5A
	jZGUOLjiBssERrFZSDbPQrJ5FpLNs5BsW8DIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMj
	JO76dzDePWB9iDEZaP1EZinR5Hxg3OaVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgXGFsYn3jgcT01o/ff9vI6PD5zPD/cVcLenN51d9M17apSZ/
	+vApHp+oJd+FSk38G22n/H5TtSHkvK3dznOssb3BOeH1b0XFt7M8tt9ZeCLpnP2M3Kc3y3Ni
	fwQGqL6suX37ba9fzeF9E0UNbRZ+Fb2xfPmDDfblKxtezE2tEnwjHrD2z497EnuVWIozEg21
	mIuKEwEcGPk+0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd3gLJYgg84vlhZz1q9hs/h55Quj
	xeWFl1gtLu+aw2ax+0QXq8Xay8fYHdg8DjWuYPc4MeM3i0ffllWMHp83yQWwRDUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZpxauZutoJOjYtW+48wNjNfYuhg5OSQETCS6
	z8yCssUkLtxbD2RzcQgJTGeUuLfrH5Tzi1Gi4c9OFpAqNgE1iS9fDrOD2CICuhKrnu9iBili
	FlgLVNR2lrWLkYNDWMBMYsbJBJAaFgFVieajs8E28ApYSqy/2ckKYQtK/Jh8D2wms4CWxOZt
	TawQtrzE5jVvmSEuUpDYcfY1I0RcRGLfi3eMEHv1JFaefck0gVFgFpJRs5CMmoVk1Cwk7QsY
	WVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMf2M6kdjCsbLA4xCnAwKvHwKm5nDhJiTSwr
	rsw9xCjBwawkwvsiCyjEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cC0k1cSb2hsYmZkaWRm
	YWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjKwrI0wy2dX8+Sxz3+w+FvharXLb
	scl1RxzdPN8fkXmg/944cYLPrv4bx36ffORY+2l7aPe8y8tEF3Qu2xt71OOXhHhR/7vXTXKX
	pHicBNcysHPNnPFechPjrSeFj/Iersz/Nf9GAueVbwET+8TXtfPdrZuYff3s+zjd9xuuylo+
	Ox5Q0PU8YLYSS3FGoqEWc1FxIgAi78P6MQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local variables such as 'bio_list', and 'pages' are pointers;
thus, use NULL instead of 0 to fix the following sparse warnings.

drivers/block/rbd.c:2166:32: warning: Using plain integer as NULL pointer
drivers/block/rbd.c:2168:31: warning: Using plain integer as NULL pointer

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/block/rbd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 9e00010..fa198de 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2163,9 +2163,9 @@ static int rbd_img_request_fill(struct rbd_img_request *img_request,
 	struct rbd_obj_request *obj_request = NULL;
 	struct rbd_obj_request *next_obj_request;
 	bool write_request = img_request_write_test(img_request);
-	struct bio *bio_list = 0;
+	struct bio *bio_list = NULL;
 	unsigned int bio_offset = 0;
-	struct page **pages = 0;
+	struct page **pages = NULL;
 	u64 img_offset;
 	u64 resid;
 	u16 opcode;
-- 
1.7.10.4


