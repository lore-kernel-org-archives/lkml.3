Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3CDIAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:00:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13322 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3CDIAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:00:13 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-40-5134548ccfff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 07/24] rtc: rtc-ds1302: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:00:12 +0900
Message-id: <014001ce18ae$4c7909e0$e56b1da0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAFpFw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ92eEJNAg4NzLS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG094tTAWNHBWH5y5kbGD8xtbFyMkhIWAi8W5ZGyuELSZx4d56
	oDgXh5DAMkaJNz8OssIUPX66kRkisYhR4tWms+wgCSGB2UwSX47YgNhsAmoSX74cBopzcIgI
	6Eu0tWiA1DML9DJKnOndDVVvK/Hl4QMmEJtTwE7i/rlVYAuEBbwkmg5dB4uzCKhKnPy+mBHE
	5gWq3znxOpQtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZQfZKCKhLPPqrCxIWETCS+Df/DVS5
	iMS+F+8YQe6REFjELtEyrZ8ZYpeAxLfJh1ggemUlNh1ghvhXUuLgihssExglZiHZPAvJ5llI
	Ns9CsmIBI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJDImriD8f4B60OMyUDrJzJLiSbn
	AyMzryTe0NjYxMzE1MTc0tTclDRhJXFe+UsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	j/yb/uS5c3GLDMNhNZ785cLLIx4ZySZP1Ug92FATU37zskfCw8uHnY9w38rsefz6D+eW/YaM
	pqcElZIvPGRIvFDh/dJ1p77IplMBu5890ZGauWnz7qwr3odv/VCsM0psV6uSddnmsXT/CsdL
	4jpL3q3c2Ff1a51wSOXM2LAz52ytTA/pzF86RYmlOCPRUIu5qDgRAEDCvHLCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG5PiEmgwarLJhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo2nvFqaCRo6Kw3MXMjYw
	fmPrYuTkkBAwkXj8dCMzhC0mceHeeqA4F4eQwCJGiVebzrKDJIQEZjNJfDliA2KzCahJfPly
	GCjOwSEioC/R1qIBUs8s0MsocaZ3N1S9rcSXhw+YQGxOATuJ++dWsYLYwgJeEk2HroPFWQRU
	JU5+X8wIYvMC1e+ceB3KFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgY
	Sfyb/waqXERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpe
	cn7uJkZw3D6T2sG4ssHiEKMAB6MSD6/AJ+NAIdbEsuLK3EOMEhzMSiK8ZRImgUK8KYmVValF
	+fFFpTmpxYcYk4EencgsJZqcD0wpeSXxhsYmZkaWRmYWRibm5qQJK4nzMp56EiAkkJ5Ykpqd
	mlqQWgSzhYmDU6qBcafvNY6QD4s0Dq5zXZV/9MSJTn7F7m8lTv9ddToDp7DxLQu4oN125OWL
	X0d7Nqu/D3SNOVWqfKokgCnj363uC/Y7sk6fzts8g7/th9emguLNc3/2/nxy5KhwnfL5lTq7
	8sT4pDfreK/rNiizvRy7+sHnpxKyMxgEFCas4/KaHmJvZ6ChNONCoBJLcUaioRZzUXEiAAiU
	zOQfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1302.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index d20b5f1..7d4c2b4 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -252,18 +252,7 @@ static struct platform_driver ds1302_platform_driver = {
 	.remove		= __exit_p(ds1302_rtc_remove),
 };
 
-static int __init ds1302_rtc_init(void)
-{
-	return platform_driver_probe(&ds1302_platform_driver, ds1302_rtc_probe);
-}
-
-static void __exit ds1302_rtc_exit(void)
-{
-	platform_driver_unregister(&ds1302_platform_driver);
-}
-
-module_init(ds1302_rtc_init);
-module_exit(ds1302_rtc_exit);
+module_platform_driver_probe(ds1302_platform_driver, ds1302_rtc_probe);
 
 MODULE_DESCRIPTION("Dallas DS1302 RTC driver");
 MODULE_VERSION(DRV_VERSION);
-- 
1.7.2.5


