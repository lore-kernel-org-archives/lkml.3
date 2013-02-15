Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161234Ab3BOGrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:47:19 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51077 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161118Ab3BOGrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:47:18 -0500
X-AuditID: cbfee690-b7f066d00000169f-7b-511dd9f5bb5d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 08/11] rtc: rtc-vr41xx: use dev_info() instead of printk()
Date: Fri, 15 Feb 2013 15:47:17 +0900
Message-id: <002601ce0b48$4bb35d80$e31a1880$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAAKjTw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zA92vN2UDDR5NNbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZz3ZtZC1oY6v4eeo0SwPjH5YuRk4OCQETiZ973rFC2GISF+6t
	Z+ti5OIQEljGKLGhdxtQEQdY0dJ3xhDx6YwSXf8fskI4s5kkFl94xQTSzSagJvHly2F2kAYR
	AX2JthYNkBpmgV5GiTO9u8HiQgK2ElNvO4OYnAJ2Eu+nm4J0Cgv4StxqesIMYrMIqEq8XjgJ
	zOYFqm443cAGYQtK/Jh8D+xmZgEtic3bmlghbHmJzWveMkOcqS7x6K8uxAFGEp0dTBAVIhL7
	XrxjhPhwHrvEmtmsEJsEJL5NPgT1oKzEpgPMECWSEgdX3GCZwCgxC8neWUj2zkKydxaSDQsY
	WVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525ihETUhB2M9w5YH2JMBlo/kVlKNDkfGJF5JfGG
	xsYmZiamJuaWpuampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cA4tSn56NRT
	6WvFAo9oKMVt+xshpvZohTv/urtub/MiFmleSkh9r57BWnnu8cqgeTb9zgGM6utVVzrpvFv2
	yvE3x8UJ1Xuk5n9hucS7pFZSarE3y/HlqmfXq7U9slXNXPPX3FV7xd3bS3TrZ3xg6a3YGfRD
	rz900YXSthl8e5m1b8dV8E1aNHWNEktxRqKhFnNRcSIAj/93gr4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoO7Xm7KBBus6dS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxrNdG1kL2tgqfp46zdLA
	+Ieli5GDQ0LARGLpO+MuRk4gU0ziwr31bF2MXBxCAtMZJbr+P2SFcGYzSSy+8IoJpIpNQE3i
	y5fD7CDNIgL6Em0tGiA1zAK9jBJneneDxYUEbCWm3nYGMTkF7CTeTzcF6RQW8JW41fSEGcRm
	EVCVeL1wEpjNC1TdcLqBDcIWlPgx+R4LiM0soCWxeVsTK4QtL7F5zVtmiJPVJR791YU4wEii
	s4MJokJEYt+Ld4wTGIVmIRk0C8mgWUgGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcMQ+k9rBuLLB4hCjAAejEg+vgIRsoBBrYllxZe4hRgkOZiUR3jUhQCHelMTKqtSi/Pii
	0pzU4kOMyUB/TmSWEk3OByaTvJJ4Q2MTMyNLIzMLIxNzc9KElcR5GU89CRASSE8sSc1OTS1I
	LYLZwsTBKdXAOKF2sv8xVV9ugUPTXtesd/+hu2lrcOTeEFUPzpITXAtuSNTvUFx7YIb9Id+N
	c/51XD/t313I+HVaUccGXqapjyVEGBfrff2S9WHbhhOlF9Y9Z77bJS/9y0/Vu9t7TqjA3TSG
	alF5vuDgcx/mHY8qFdfIKzTxzPqXfM7Gx/jk4buP3jguntNlrcRSnJFoqMVcVJwIAC6YEz4c	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/rtc/rtc-vr41xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 6c3774c..f91be04 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -352,7 +352,7 @@ static int rtc_probe(struct platform_device *pdev)
 	disable_irq(aie_irq);
 	disable_irq(pie_irq);
 
-	printk(KERN_INFO "rtc: Real Time Clock of NEC VR4100 series\n");
+	dev_info(&pdev->dev, "Real Time Clock of NEC VR4100 series\n");
 
 	return 0;
 
-- 
1.7.2.5


