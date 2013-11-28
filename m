Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab3K1Dpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:45:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:65153 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3K1Dpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:45:49 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-52-5296bc6b7a8c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Evgeniy Polyakov'" <zbr@ioremap.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] w1: matrox: use DEFINE_PCI_DEVICE_TABLE macro
Date: Thu, 28 Nov 2013 12:45:47 +0900
Message-id: <004e01ceebec$52ed0f80$f8c72e80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7r7FLGMO75lsWtQoOv/j+n0ORRdg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zA93sPdOCDPY8MraYs34Nm8XlhZdY
	LS7vmsNm8Wv1OTYHFo/HO7YzeZyY8ZvFo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJObX7N
	VjCDraLpxRa2BsYlrF2MnBwSAiYSK84/YISwxSQu3FvP1sXIxSEksIxR4sfBcywwRe9+HWAH
	sYUEpgMlzstBFP1ilJi/6CxYgk1ATeLLl8NANgeHiIC+RFuLBkiYWSBH4s6qd8wgtrCAncTS
	k2vZQGwWAVWJrh3vweK8ArYS736/ZIKwBSV+TL7HAtGrJbF+53EmCFteYvOat8wg4yUE1CUe
	/dUFCYsI6EmsOrWUDaJERGLfi3eMIKdJCGxil2ife48VYpeAxLfJh1ggemUlNh1ghnhLUuLg
	ihssExjFZiHZPAvJ5llINs9CsmIBI8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJAY69vB
	ePOA9SHGZKD1E5mlRJPzgTGaVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWp
	RfFFpTmpxYcYmTg4pRoYTT4dXZXxw/yV4D/L+7K9exbXptfYH+Wf2HzoyK2Wh0JaPXfmc86W
	1s2aWMcYos+8Pz2nr/akx2u5tdUqXa/mLGKv7fhk/neNkfbNmLnRuW9MFzw4eVQi8np3k/A6
	+WcMT5K9Xh67E9GoZMGqXfQpan1wVv+Xa3nvNhparrLpvm3db3H1H3utEktxRqKhFnNRcSIA
	Q17pjMcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQd3sPdOCDOZ3G1jMWb+GzeLywkus
	Fpd3zWGz+LX6HJsDi8fjHduZPE7M+M3i0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZpza/ZiuYwVbR9GILWwPjEtYuRk4OCQETiXe/DrBD2GISF+6t
	ZwOxhQSmM0r8OC/XxcgFZP9ilJi/6CxYEZuAmsSXL4eBbA4OEQF9ibYWDZAws0COxJ1V75hB
	bGEBO4mlJ9eCzWERUJXo2vEeLM4rYCvx7vdLJghbUOLH5HssEL1aEut3HmeCsOUlNq95ywwy
	XkJAXeLRX12QsIiAnsSqU0vZIEpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBEfwM+kdjKsaLA4xCnAwKvHwSuhMCxJiTSwrrsw9xCjBwawk
	wqtQDBTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGByySuJNzQ2MTOyNDKzMDIxNydNWEmc
	92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxibHx1sEs166zjgi/Vx+WsgsY7at0q3qjLv/e4g8
	3PxU3MDzg43c3g1/Vl8/YH165dnjJS/kmQ8J5zAuWVazyNpRgvF6eu1rjY6zpueOn9B9JcLK
	VjElv9i76uDZ01M5PsQv+uSgsFN9b+bOwjfvYz2lom6kJzrU3N9mbXGjW8hlLt8r09gHnEos
	xRmJhlrMRcWJAA1lCz8kAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is used to create a struct pci_device_id array.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/w1/masters/matrox_w1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/matrox_w1.c b/drivers/w1/masters/matrox_w1.c
index d8667b0..9361cea 100644
--- a/drivers/w1/masters/matrox_w1.c
+++ b/drivers/w1/masters/matrox_w1.c
@@ -42,7 +42,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for transport(Dallas 1-wire prtocol) over VGA DDC(matrox gpio).");
 
-static struct pci_device_id matrox_w1_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(matrox_w1_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MATROX, PCI_DEVICE_ID_MATROX_G400) },
 	{ },
 };
-- 
1.7.10.4


