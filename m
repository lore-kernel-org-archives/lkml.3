Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766Ab3ECGbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:31:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60709 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760176Ab3ECGbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:31:04 -0400
X-AuditID: cbfee68d-b7f016d000007930-65-518359a74e3b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 19/42] rtc: rtc-lp8788: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:31:03 +0900
Message-id: <002101ce47c7$c8c41240$5a4c36c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx8gdQDoREjI2QBmBKldMbOFEhA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zA93lkc2BBrM2KVssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0f1qJVPBOraKPet+MjUwLmbtYuTkkBAwkVj0awcjhC0mceHeerYuRi4OIYFljBLP
	zvczwhT1/l/HDJFYxChx+PB/KOcXo8TOjXuZQarYBNQkvnw5zN7FyMEhIqAv0daiAVLDLNDN
	KPGoeS5YjbBAsMS1g6tZQGwWAVWJh+v3gG3gFbCU6F+ygB3CFpT4MfkeWA2zgJbE+p3HmSBs
	eYnNa94yQ1ykILHj7GuwXhEBPYnJ+4+yQtSISOx78Y4RZLGEwDF2iXPL/0MtE5D4NvkQC8hx
	EgKyEpsOQM2RlDi44gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yFCvODG3uDQv
	XS85P3cTIyT6encw3j5gfYgxGWj9RGYp0eR8YPTmlcQbGpsZWZiamBobmVuakSasJM6r1mId
	KCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxc0lW4+PGS7fYWP6G7XEqehqb2Rj8RUD+udOx
	Zwbm82ef+vA05cmvW926nhHzMpw7L1pd7W/l27+1wK2R49T3YGPJ/M1bjyft3PkoZ7nj5R9G
	bNdb+s1m3Jw989ChaU7v2W7UZNy/FZmhoXp5zbVzlQtMeLO2KJ/e8jqXhWVau0yVrbvne7PV
	SizFGYmGWsxFxYkA9sbFfNQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd3lkc2BBn+vyVssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNH9aiVTwTq2ij3rfjI1MC5m7WLk5JAQMJHo
	/b+OGcIWk7hwbz1bFyMXh5DAIkaJw4f/M0M4vxgldm7cC1bFJqAm8eXLYfYuRg4OEQF9ibYW
	DZAaZoFuRolHzXPBaoQFgiWuHVzNAmKzCKhKPFy/hxHE5hWwlOhfsoAdwhaU+DH5HlgNs4CW
	xPqdx5kgbHmJzWveQl2kILHj7GuwXhEBPYnJ+4+yQtSISOx78Y5xAqPALCSjZiEZNQvJqFlI
	WhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7tZ9I7GFc1WBxiFOBgVOLhVWhpChRi
	TSwrrsw9xCjBwawkwuv2AyjEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cC0k1cSb2hsYmZk
	aWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjDqpPs3ncy0eZIe+ifKaxX7G
	/OSmcynXglZbTZkUyc79denHVycObZ/xYNUzsxKByW99FS/m6XL5iIZxHTLZN+1v8k2mp+wK
	2pHPRDQf3eN+5vH0d5vFhICF1WXR8nsZFwtfZ01KncWzacPRDae+cOUGF7wPf1PcduSCyou/
	Ju71hwvftAZw3FRiKc5INNRiLipOBADkOc0pMQMAAA==
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
 drivers/rtc/rtc-lp8788.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-lp8788.c b/drivers/rtc/rtc-lp8788.c
index 9853ac1..76a82dc 100644
--- a/drivers/rtc/rtc-lp8788.c
+++ b/drivers/rtc/rtc-lp8788.c
@@ -314,8 +314,6 @@ static int lp8788_rtc_probe(struct platform_device *pdev)
 
 static int lp8788_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


