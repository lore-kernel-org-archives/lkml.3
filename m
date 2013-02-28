Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3B1Kjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:39:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57345 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3B1Kjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:39:42 -0500
X-AuditID: cbfee68d-b7f636d0000009be-15-512f33ed40eb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ce159f$94e48270$bead8750$%han@samsung.com>
In-reply-to: <000901ce159f$94e48270$bead8750$%han@samsung.com>
Subject: [PATCH 6/7] rtc: rtc-pcap: add __init/__exit annotation
Date: Thu, 28 Feb 2013 19:39:41 +0900
Message-id: <000e01ce159f$ea2cc8f0$be865ad0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vn5THVyS/kU1xRpiO8bTmT1G2WgAAEm3Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zQ923xvqBBjdPK1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8bxnImNBH1fFvf3PmBoY13F0MXJySAiYSJx4tp4NwhaTuHAPxObiEBJYxijxdN9c
	li5GDrCimZc4IeLTGSUaWzYwQzi/GCU2nZwK1s0moCbx5cthdpAGEQF9ibYWDZAaZoFeRokz
	vbvZQWqEBGwlVnW3soLYnAJ2EnvmT2IFqRcWcJCY9zobxGQRUJXY9pQPpIIXqHrbt/uMELag
	xI/J91hAbGYBLYnN25pYIWx5ic1r3jJDnKku8eivLkhYRMBIYnsLTLmIxL4X7xhBrpEQuMcu
	8eH8PiaQBIuAgMS3yYegXpSV2HSAGRIMkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqm
	FiQXFCelFxnqFSfmFpfmpesl5+duYoREae8OxtsHrA8xJgOtn8gsJZqcD4zyvJJ4Q2NjEzMT
	UxNzS1NzU9KElcR55S7JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgFGDU0mzbViZ0pTqi
	v016nn+QQPH5yOwovW83PsmHct+UE19plM1cO1Ww9eHmNMV/8hfk519L7j6tGLb2/QpPKfdN
	yx7NTqpxEXZ6fOPz3m0XWjs4vGczXHiqfea79yUe65U6bLeXHJZQip0mxBw8pyBkRpne5BlL
	jhvteLJz8pZIo7mzorVPK7EUZyQaajEXFScCANJZmDroAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd23xvqBBnenyVosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPG8ZyJjQR9Xxb39z5gaGNdxdDFycEgImEjM
	vMTZxcgJZIpJXLi3nq2LkYtDSGA6o0RjywZmCOcXo8Smk1PZQKrYBNQkvnw5zA7SLCKgL9HW
	ogFSwyzQyyhxpnc3O0iNkICtxKruVlYQm1PATmLP/EmsIPXCAg4S815ng5gsAqoS257ygVTw
	AlVv+3afEcIWlPgx+R4LiM0soCWxeVsTK4QtL7F5zVtmiJPVJR791QUJiwgYSWxvgSkXkdj3
	4h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZwCnknt
	YFzZYHGIUYCDUYmHt8NEL1CINbGsuDL3EKMEB7OSCK8Lv36gEG9KYmVValF+fFFpTmrxIcZk
	oD8nMkuJJucD01NeSbyhsYmZkaWRmYWRibk5acJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCU
	amDcZ/BzxS3Niy5PDh2bqrOp/sTvwKXM/IX1ss8ZCgwvcBqqnPwdm+ZeIHvKcNJ28ZvBz0+s
	jDnL/zRYZsG2v7s/PruftC204MjKy60Segt3MeWcr3tq2HBzkkrb2dX7tO+WlxhYxogt6xbU
	yTx/x2FJUtcMHhujaybHdm90az+30Nt/g7Thz7vaSizFGYmGWsxFxYkAqnglJkUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is used, bind/unbind via sysfs is
disabled. Thus, __init/__exit annotations can be added to
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pcap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index e0019cd..48db88a 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -139,7 +139,7 @@ static const struct rtc_class_ops pcap_rtc_ops = {
 	.alarm_irq_enable = pcap_rtc_alarm_irq_enable,
 };
 
-static int pcap_rtc_probe(struct platform_device *pdev)
+static int __init pcap_rtc_probe(struct platform_device *pdev)
 {
 	struct pcap_rtc *pcap_rtc;
 	int timer_irq, alarm_irq;
@@ -183,7 +183,7 @@ fail_rtc:
 	return err;
 }
 
-static int pcap_rtc_remove(struct platform_device *pdev)
+static int __exit pcap_rtc_remove(struct platform_device *pdev)
 {
 	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
 
@@ -196,7 +196,7 @@ static int pcap_rtc_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver pcap_rtc_driver = {
-	.remove = pcap_rtc_remove,
+	.remove = __exit_p(pcap_rtc_remove),
 	.driver = {
 		.name  = "pcap-rtc",
 		.owner = THIS_MODULE,
-- 
1.7.2.5


