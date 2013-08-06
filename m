Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3HFKhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:37:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34162 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab3HFKhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:37:10 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-68-5200d1d52048
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/3] dma: mv_xor: use NULL instead of 0
Date: Tue, 06 Aug 2013 19:37:08 +0900
Message-id: <000201ce9290$e6f0f4e0$b4d2dea0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6SkMfLKTO6jP1URJGycH6YY43hLA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zY92rFxmCDO5/YbfY3P+AzeLywkus
	Fpd3zWGzePqgicniZd9+FgdWj4nN79g9nmy6yOixeM9LJo++LasYPT5vkgtgjeKySUnNySxL
	LdK3S+DKOHDtFGvBTraKP8vOsDYwLmXtYuTkkBAwkWjqOsgGYYtJXLi3HswWEljGKHHxuyJM
	zfu2N0xdjFxA8emMEh+m7YFyfjFKnP7wlRGkik1ATeLLl8PsXYwcHCIC6hJLr8uA1DALzGGU
	OPz8NRNIjbCAucTrt1PB6lkEVCV+NRwGi/MKWEpsWNwAZQtK/Jh8jwXEZhbQkli/8zgThC0v
	sXnNW2aIixQkdpx9DTZHREBPYvKNd1D1IhL7XrxjBFksIXCMXaJ3yWo2iGUCEt8mH2IBOU5C
	QFZi0wGoOZISB1fcYJnAKDYLyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpRcZ6hUn5haX5qXr
	JefnbmKExF7vDsbbB6wPMSYDrZ/ILCWanA+M3bySeENjMyMLUxNTYyNzSzPShJXEedVarAOF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MLK3MHRvjg9+uai39qG62WW3xTwN739K1dZs3HLr
	r9bVP+veHz/bnsigx9q/wUzouDenihc783/xWOEDTxqrJeMq8n1eruS/Eau873X2Q+tZWzQ/
	zrV8t25/e2bQ0t+KfFvl1H7I6q7z5/VwKmgQ82ovF7/nptDt4XlY69iutuIlwYv/2p1boMRS
	nJFoqMVcVJwIAIk/mHTTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd2rFxmCDP51s1hs7n/AZnF54SVW
	i8u75rBZPH3QxGTxsm8/iwOrx8Tmd+weTzZdZPRYvOclk0ffllWMHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZhy4doq1YCdbxZ9lZ1gbGJeydjFyckgImEi8
	b3vDBGGLSVy4t56ti5GLQ0hgOqPEh2l7mCCcX4wSpz98ZQSpYhNQk/jy5TB7FyMHh4iAusTS
	6zIgNcwCcxglDj9/DTZJWMBc4vXbqWD1LAKqEr8aDoPFeQUsJTYsboCyBSV+TL7HAmIzC2hJ
	rN95nAnClpfYvOYtM8RFChI7zr4GmyMioCcx+cY7qHoRiX0v3jFOYBSYhWTULCSjZiEZNQtJ
	ywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwbH9TGoH48oGi0OMAhyMSjy8iVf/Bwqx
	JpYVV+YeYpTgYFYS4VXZyRAkxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnAtJNXEm9obGJm
	ZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzqlutKLDarrK7ceevx5M0f
	eVoLuza7JV+6ei3y10wZtdoavzaG/f/uP/RsUfHQ1+qanZfBpD/1RJr3nqU/j9tdiDljzviX
	z1Hqdamk4A0hTdmysuRJ6wQktLrSKnc3FMQJMh6LX21YlGdpxbnbq4Dz0uWJWV993p6a67Dy
	c/+BtVkcJe2XHyqxFGckGmoxFxUnAgBgQe3bMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%p is used, thus NULL should be used instead of 0
in order to fix the following sparse warning:

drivers/dma/mv_xor.c:648:9: warning: Using plain integer as NULL pointer

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dma/mv_xor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 200f1a3..534e2fe 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -647,7 +647,7 @@ mv_xor_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 
 	dev_dbg(mv_chan_to_devp(mv_chan),
 		"%s sw_desc %p async_tx %p\n",
-		__func__, sw_desc, sw_desc ? &sw_desc->async_tx : 0);
+		__func__, sw_desc, sw_desc ? &sw_desc->async_tx : NULL);
 
 	return sw_desc ? &sw_desc->async_tx : NULL;
 }
-- 
1.7.10.4


