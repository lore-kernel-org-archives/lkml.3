Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692Ab3ECG3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:29:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59721 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762646Ab3ECG3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:29:08 -0400
X-AuditID: cbfee68f-b7f066d000003683-59-51835933ddb7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: [PATCH 12/42] rtc: rtc-da9052: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:29:07 +0900
Message-id: <001a01ce47c7$83aadcc0$8b009640$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx37Mt4uiUNqIRcqvo1Tb5ksSxg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zY13jyOZAg5tnJS2WXLzKbjFn/Ro2
	i8u75rBZ7O/sYHRg8dgz8SSbx4kZv1k8ps/7yeTxeZNcAEsUl01Kak5mWWqRvl0CV8a5Q0/Z
	CtaxVXzepdbAuJi1i5GDQ0LARGJ/k18XIyeQKSZx4d56ti5GLg4hgWWMEj3d/1khEiYSky7M
	Y4FITGeU+HzvF5Tzi1Fi7p7vzCBVbAJqEl++HGYHmSoioC/R1qIBEmYWyJR4v/gzG4gtLBAs
	cb3vPzuIzSKgKvHz5hqwcl4BS4lF85xAwrwCghI/Jt9jgWjVkli/8zgThC0vsXnNW2aIexQk
	dpx9zQhiiwjoSUxa0g1VLyKx78U7RpDTJAS2sUv0PZjLArFLQOLb5EMsEA/LSmw6ADVHUuLg
	ihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJAI69/B
	ePeA9SHGZKD1E5mlRJPzgRGaVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQZGkZ9vz86Z2VYfzBT25alnzYQo1zTH2rh3m3u5bp559reh6Z60kkfI
	Ei3RKakqzq94NWS5m9ZWKYseSwj8sOjd9ZIjd5Z/ZVLZK5aQFGfDqbHrW9H/vRqtSx00i3N7
	Gif/sHQ7JrY9h/9dfMTS9MXlpnds753/VrFsJq94cvliPolLqjey535VYinOSDTUYi4qTgQA
	GQmOKMYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQV3jyOZAg8crxSyWXLzKbjFn/Ro2
	i8u75rBZ7O/sYHRg8dgz8SSbx4kZv1k8ps/7yeTxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGuUNP2QrWsVV83qXWwLiYtYuRk0NCwERi0oV5LBC2mMSFe+vZ
	uhi5OIQEpjNKfL73iwXC+cUoMXfPd2aQKjYBNYkvXw6zdzFycIgI6Eu0tWiAhJkFMiXeL/7M
	BmILCwRLXO/7zw5iswioSvy8uQasnFfAUmLRPCeQMK+AoMSPyfdYIFq1JNbvPM4EYctLbF7z
	lhniHgWJHWdfM4LYIgJ6EpOWdEPVi0jse/GOcQKjwCwko2YhGTULyahZSFoWMLKsYhRNLUgu
	KE5KzzXSK07MLS7NS9dLzs/dxAiO4GfSOxhXNVgcYhTgYFTi4VVoaQoUYk0sK67MPcQowcGs
	JMLr9gMoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnA5JJXEm9obGJmZGlkZmFkYm5OmrCS
	OO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzai/9KG99W+2ApKX4sZnfU6SXPe7V6jsbc9A31
	uH9NZMvtvis/M5++mfJR1Zyx6ZrQ5HO5/y6s1Lvde4d9g5FE085fK6UvPJ+TZeO44MwK1913
	sw+/WqEUa1TEdHS1oUdjXdvkmbVlZz6mXjxydae4/vaTV6923Xj7bbdK12rpAP2/jsm3rMuf
	KrEUZyQaajEXFScCAAZwFjEkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-da9052.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index 7286b27..a61ab7f 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -257,8 +257,6 @@ static int da9052_rtc_probe(struct platform_device *pdev)
 
 static int da9052_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


