Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3HUJLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:11:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18453 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3HUJLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:11:44 -0400
X-AuditID: cbfee68e-b7f276d000002279-80-52148442a2ab
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jean Delvare'" <khali@linux-fr.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] block: swim: remove unnecessary platform_set_drvdata()
Date: Wed, 21 Aug 2013 18:11:30 +0900
Message-id: <001a01ce9e4e$6c580ab0$45082010$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6eTmwhCnrtHr4AR1GvFEFn8gnVtA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zA12nFpEgg3u7lC3mrF/DZnF54SVW
	i8a/kRaXd81hc2DxODHjN4vHlYaTbB59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVcfrNM7aC
	a2wVLa8uszYwbmftYuTkkBAwkThx+xsbhC0mceHeeiCbi0NIYBmjRNeUo0wwRVeXNLFAJKYz
	Slyb+YIVwvnFKPF4UScLSBWbgJrEly+H2UFsEQFdiVXPdzF3MXJwMAtkSzw4bQISFhZwl1hz
	dQJYCYuAqsT3n3/AFvAK2Eo83fWIHcIWlPgx+R7YSGYBLYn1O48zQdjyEpvXvAUbKSGgLvHo
	ry6IKSKgJ9F9sQiiQkRi34t3jCCXSQhsYpc43rCcFWKVgMS3yYdYIFplJTYdYIZ4S1Li4Iob
	LBMYxWYhWTwLyeJZSBbPQrJiASPLKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYyQCOvbwXjz
	gPUhxmSg9ROZpUST84ERmlcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGxgpug8apJoHHXh0Vb/1irlRfeXB28SSW3mXnv4mZnGuZXXJoh9vhN+Jx
	z+9x/LuyWnThzi9+SgXbWnsi9yllnpt2s5B1z885W1XOrtW7cN3w6mTGzNtLzHPlsoxP3lS/
	Wd7g66U5TWxODfNG1mURR6ZobU1jS/n+UK7uSq1WT3WyA++NKZJX9ZRYijMSDbWYi4oTAWVu
	mSbGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQV2nFpEgg5NL5S3mrF/DZnF54SVW
	i8a/kRaXd81hc2DxODHjN4vHlYaTbB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmHH6zTO2gmtsFS2vLrM2MG5n7WLk5JAQMJG4uqSJBcIWk7hwbz1b
	FyMXh5DAdEaJazNfsEI4vxglHi/qBKtiE1CT+PLlMDuILSKgK7Hq+S7mLkYODmaBbIkHp01A
	wsIC7hJrrk4AK2ERUJX4/vMPE4jNK2Ar8XTXI3YIW1Dix+R7YCOZBbQk1u88zgRhy0tsXvMW
	bKSEgLrEo7+6IKaIgJ5E98UiiAoRiX0v3jFOYBSYhWTQLCSDZiEZNAtJywJGllWMoqkFyQXF
	Sem5hnrFibnFpXnpesn5uZsYwfH7TGoH48oGi0OMAhyMSjy8F5RFgoRYE8uKK3MPMUpwMCuJ
	8C6qBgrxpiRWVqUW5ccXleakFh9iTAb6cyKzlGhyPjC15JXEGxqbmBlZGplZGJmYm5MmrCTO
	e6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD4/HMLaJ7A24bCafc+b5+bt+T3al9PC6XYl+fMV3M
	umfKBZ7nu03OhqnM/Lq37NO1xpT/2lqqftLH+LS/Wep2C+y00qp9v4PzqlnjnI4tqf4cBxI/
	H0l5KjfhaYTpLlWFO2ZWScfMb57zdTVyNfr1ufKk3YTaTrZLVSeOPBT4ZxUYd+HbfZHWPiWW
	4oxEQy3mouJEAGi2BaojAwAA
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
 drivers/block/swim.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 8ed6ccb..b02d53a 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -924,7 +924,6 @@ static int swim_probe(struct platform_device *dev)
 	return 0;
 
 out_kfree:
-	platform_set_drvdata(dev, NULL);
 	kfree(swd);
 out_iounmap:
 	iounmap(swim_base);
@@ -962,7 +961,6 @@ static int swim_remove(struct platform_device *dev)
 	if (res)
 		release_mem_region(res->start, resource_size(res));
 
-	platform_set_drvdata(dev, NULL);
 	kfree(swd);
 
 	return 0;
-- 
1.7.10.4


