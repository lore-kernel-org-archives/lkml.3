Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967223Ab3HIFxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 01:53:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50780 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966964Ab3HIFxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 01:53:53 -0400
X-AuditID: cbfee68e-b7f276d000002279-31-520483ee07a7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Subject: [PATCH] hwrng: pixocel - Staticize 'rng_dev'
Date: Fri, 09 Aug 2013 14:53:50 +0900
Message-id: <000201ce94c4$d2591f40$770b5dc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UxMto0Y6xyNf0T7mG7zcsiQ5iVg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ913zSxBBlPfG1l0v5KxmLF5PpPF
	5YWXWC0u75rDZrFgWx+jA6vHtgOqHnu6/7N79G1ZxejR93IDo8fnTXIBrFFcNimpOZllqUX6
	dglcGefmnGAv6GWruH1xMmMD42TWLkZODgkBE4ntD3awQNhiEhfurWfrYuTiEBJYxihx5NI1
	RpiiH7MOMkEkpjNKbOy+DVX1i1Fi08smsHY2ATWJL18Os4PYIgJ6En3rG8G6hQVMJZbO/80M
	YrMIqErcab0IZvMKWEocmXufEcIWlPgx+R7YHGYBLYn1O48zQdjyEpvXvGWGuEJBYsfZ14ww
	87euf8QKUSMise/FO6hL17FLXFrsArFLQOLb5ENAMzmA4rISmw5AjZGUOLjiBssERtFZSDbP
	QrJ5FpLNs5BsWMDIsopRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJL76djDePGB9iDEZaP1E
	ZinR5HxgfOaVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJ
	g1OqgdEqo+3KjcssWaueiWQUx/3/uJs3blt1lTqffAX3g2t2ar+vPizN+T1dJ+7DV1F7Vuul
	N6Mqt0RrTPNwDEy/fCzg6e//s68ocS6L2DZhheSWyqkTF9flXfeSV105R58hY5P+Zee3agsd
	WI5ET4l6ER4eMuVhtfTS6/ybritzLPZyi/hy2PdT/1wlluKMREMt5qLiRAAQN1o6xQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd13zSxBBqv/6Fl0v5KxmLF5PpPF
	5YWXWC0u75rDZrFgWx+jA6vHtgOqHnu6/7N79G1ZxejR93IDo8fnTXIBrFENjDYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
	+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnn5pxgL+hlq7h9cTJjA+Nk1i5GTg4JAROJH7MO
	MkHYYhIX7q1n62Lk4hASmM4osbH7NpTzi1Fi08smFpAqNgE1iS9fDrOD2CICehJ96xsZQWxh
	AVOJpfN/M4PYLAKqEndaL4LZvAKWEkfm3meEsAUlfky+BzaHWUBLYv3O40wQtrzE5jVvmSGu
	UJDYcfY1I8z8resfsULUiEjse/GOcQIj/ywko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXS
	K07MLS7NS9dLzs/dxAiO32fSOxhXNVgcYhTgYFTi4VXczhwkxJpYVlyZe4hRgoNZSYT3RRZQ
	iDclsbIqtSg/vqg0J7X4EGMy0KcTmaVEk/OBqSWvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaB
	QgLpiSWp2ampBalFMFuYODilGhjzlSaf199UvDBfqll2obrUV4n+T6pNwkk9MoFzcz4f75uf
	s7OzKntfQcMazx8Xf09bYbn00Mzd6+qMv2+Mk5L3nTcv61623pv6I7Wxxwyjg7SWOspdq4k5
	stHl5Yyr7Y9UVhZGKn4/l/FD5YRV54zC4Mc3bSfMv1vxT8eNLWHT/XZe39zvrbeUWIozEg21
	mIuKEwG4TIdAIwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'rng_dev' is used only in this file.
Fix the following sparse warning:

drivers/char/hw_random/picoxcell-rng.c:36:15: warning: symbol 'rng_dev' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/picoxcell-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/picoxcell-rng.c b/drivers/char/hw_random/picoxcell-rng.c
index 973b951..3d4c229 100644
--- a/drivers/char/hw_random/picoxcell-rng.c
+++ b/drivers/char/hw_random/picoxcell-rng.c
@@ -33,7 +33,7 @@
 
 static void __iomem *rng_base;
 static struct clk *rng_clk;
-struct device *rng_dev;
+static struct device *rng_dev;
 
 static inline u32 picoxcell_trng_read_csr(void)
 {
-- 
1.7.10.4


