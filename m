Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaDXXgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:36:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28467 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaDXXgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:36:06 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-ea-53599fe2d872
Message-id: <1398382436.4283.21.camel@kjgkr>
Subject: Re: f2fs causes system stall
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 25 Apr 2014 08:33:56 +0900
In-reply-to: <20140424135910.f095d63eafdf136cc8851114@gmx.de>
References: <2601952.jk1l5iHOJT@ax5200p> <1398297270.4283.19.camel@kjgkr>
 <20140424135910.f095d63eafdf136cc8851114@gmx.de>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zI91H8yODDRZPN7a4vGsOm0Xn+YWM
	DkweHz7GeXzeJBfAFMVlk5Kak1mWWqRvl8CVcebIa6aC38wV0yb+ZW5g7GfuYuTkkBAwkTi2
	7QYrhC0mceHeejYQW0hgGaNE5wxJmJremXsZuxi5gOKLGCW+39nFCFH0ilHi6Q4BEJtXQEfi
	8tJFYHFhAVWJHS8bmboYOTjYBLQlNu83gChXlHi7/y4rSFhEQFni6yJFkDCzgL7EltUbwDpZ
	gDovzTsNZnMK2Eq8OfmYGaRcSKBG4kirBUiYX0BU4vDC7cwQreoSk+YtgvpESWJ3eyc7RFxe
	YvOat8wQhwlK/Jh8jwXkegmBVewSaw4dZ4XYJSDxbfIhFpD5EgKyEpsOQM2RlDi44gbLBEaJ
	WUhWzEIydhaSsQsYmVcxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525ihERT7w7G2wesDzEmA62c
	yCwlmpwPjMa8knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamBcFv+sw6jZrWyOwG7GW4V80yL+bOgoXPzktf00nSf5zMGePwR5t027/TxhzySnGtHb
	5b0zz19dt7Qv95un8P1FW7cFsFx/fuzZM+f/st96dKS/fi5edGHxzabAv9cZn9+Nue5w59d6
	Cc7DZ9ND9MWe+V6/aSLqd5JJ9EDHleufvvZKV22ZkvxFW4mlOCPRUIu5qDgRANgsSim8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xgO6j+ZHBBv8e6Ftc3jWHzaLz/EJG
	ByaPDx/jPD5vkgtgimpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
	VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDhz5DVT
	wW/mimkT/zI3MPYzdzFyckgImEj0ztzLCGGLSVy4t56ti5GLQ0hgEaPE9zu7wBJCAq8YJZ7u
	EACxeQV0JC4vXQQWFxZQldjxspGpi5GDg01AW2LzfgOIckWJt/vvsoKERQSUJb4uUgQJMwvo
	S2xZvQGskwWo89K802A2p4CtxJuTj5lByoUEaiSOtFqAhPkFRCUOL9zODNGqLjFp3iKoi5Uk
	drd3skPE5SU2r3nLDHGYoMSPyfdYJjAKzULSMgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YW
	l+al6yXn525iBEfrM+kdjKsaLA4xCnAwKvHwTpCNDBZiTSwrrsw9xCjBwawkwjthOlCINyWx
	siq1KD++qDQntfgQYzLQcxOZpUST84GJJK8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGGvbNsy8nfzm2cN7ZQd2rnQN+rbQSKbjgCpH4oKul7amTgGd1+e7
	xE/ZJLhUMH+R0ea4VxMKXyj53CybZxNwQC+1wyxhQyWX6PG7P/zlrWL3f2PcoNGT/+z89y23
	Fko3HapbeOa+2aqeuZefaS0K2dlyafoR++kvRBl3LMnj8ly4xOqHS+z2aS1KLMUZiYZazEXF
	iQBXYEDpGgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much.

Could you test the following patch?

---
 fs/f2fs/data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 150c12a..0147de7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -833,6 +833,8 @@ out:
 	unlock_page(page);
 	if (need_balance_fs)
 		f2fs_balance_fs(sbi);
+	if (wbc->for_reclaim)
+		f2fs_submit_merged_bio(sbi, DATA, WRITE);
 	return 0;
 
 redirty_out:
-- 
1.8.4.474.g128a96c


-- 
Jaegeuk Kim
Samsung

