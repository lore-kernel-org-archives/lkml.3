Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaEGIf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:35:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65512 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaEGIfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:35:20 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-00-5369f046382b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Arnaud Ebalard'" <arno@natisbad.org>
References: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com>
In-reply-to: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com>
Subject: [PATCH 3/5] rtc: isl12057: Make of_device_id array const
Date: Wed, 07 May 2014 17:35:18 +0900
Message-id: <021401cf69cf$46f9b370$d4ed1a50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pzr9CTHGzqjsGTXmFpMFJp7KU/wAAHNYA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zQ123D5nBBkdeWFssuXiV3WLO+jVs
	FucPnGGyuLzwEqvF5V1z2Cz2d3YwOrB57Jl4ks3jxIzfLB5ztz9m9+jbsorRY/q8n0wenzfJ
	BbBFcdmkpOZklqUW6dslcGXsnriRpWAha8XuZ/tZGxhXs3QxcnJICJhINBy6zw5hi0lcuLee
	rYuRi0NIYBmjxO8Lm9hgilo/zmGESCxilJj8soEJwvnNKHH+awtYFZuAmsSXL4eBRnFwiAjo
	S7S1aIDUMAtsZZSYv2w6WI2QgK3E2uavYDangJ3E5CNTwVYLCzhKNC9eyApiswioSkw7cxis
	hheovv3mYkYIW1Dix+R7YGczC2hJrN95nAnClpfYvOYtM8heCQF1iUd/dUHCIgJGEr+nvYcq
	EZHY9+Id2AMSAh/ZJc72/WKD2CUg8W3yIRaIXlmJTQeYIR6WlDi44gbLBEaJWUg2z0KyeRaS
	zbOQrFjAyLKKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIyR+J+5gvH/A+hBjMtD6icxSosn5
	wPjPK4k3NDYzsjA1MTU2Mrc0I01YSZw3/VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG
	LOXLb8t+bm5cuWOPpGX+mydqa/buS7wWwLLm3AyuuosqBpy7v1REM07Rkn4iLHWmULdmsQW/
	U/TGP3z/n1jKCfcVlKt4rOg3m7dDpPQUn+CO9Kcra7fONYxdL1dkfen3Oq6F2zxObdWIKzTY
	mvK7uHTixMkfI3YZb/6hef9FZUXMp1lrQkullFiKMxINtZiLihMBQacVhvUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAV23D5nBBge+mVssuXiV3WLO+jVs
	FucPnGGyuLzwEqvF5V1z2Cz2d3YwOrB57Jl4ks3jxIzfLB5ztz9m9+jbsorRY/q8n0wenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2D1xI0vBQtaK3c/2szYw
	rmbpYuTkkBAwkWj9OIcRwhaTuHBvPVsXIxeHkMAiRonJLxuYIJzfjBLnv7awgVSxCahJfPly
	mL2LkYNDREBfoq1FA6SGWWAro8T8ZdPBaoQEbCXWNn8FszkF7CQmH5nKDmILCzhKNC9eyApi
	swioSkw7cxishheovv3mYkYIW1Dix+R7YNcxC2hJrN95nAnClpfYvOYtM8heCQF1iUd/dUHC
	IgJGEr+nvYcqEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iRGcHJ5J72Bc1WBxiFGAg1GJh9fibUawEGtiWXFl7iFGCQ5mJRHeXRczg4V4UxIr
	q1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5i48kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5Y
	kpqdmlqQWgSzhYmDU6qBMSh1C+eFBes9I87/2W7VYKSqvb3w7cRK1dUMH303aS1IZbNrueWq
	9G7qtZWml+ODEv/xqTjx++bJ3/u2VuHw5QOCG1exWvEbfPvjvH6y4rP9wZ99thvbeu6MUmKd
	76auJn2eR2y6yzLbf/OOGnVJe1sLT5gibd67xfPEvIv1kaLF37bqHOHoUGIpzkg01GIuKk4E
	AMN2tElSAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-isl12057.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-isl12057.c b/drivers/rtc/rtc-isl12057.c
index 41bd76a..455b601 100644
--- a/drivers/rtc/rtc-isl12057.c
+++ b/drivers/rtc/rtc-isl12057.c
@@ -278,7 +278,7 @@ static int isl12057_probe(struct i2c_client *client,
 }
 
 #ifdef CONFIG_OF
-static struct of_device_id isl12057_dt_match[] = {
+static const struct of_device_id isl12057_dt_match[] = {
 	{ .compatible = "isl,isl12057" },
 	{ },
 };
-- 
1.7.10.4


