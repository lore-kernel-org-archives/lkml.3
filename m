Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3ILGof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:44:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38668 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab3ILGoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:44:32 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-9c-523162cf6965
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001501ceaf83$1e558220$5b008660$%han@samsung.com>
In-reply-to: <001501ceaf83$1e558220$5b008660$%han@samsung.com>
Subject: [PATCH 3/3] mfd: timberdale: remove unnecessary pci_set_drvdata()
Date: Thu, 12 Sep 2013 15:44:31 +0900
Message-id: <001701ceaf83$8921e6c0$9b65b440$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgx4pjQNLnVsKTseFP8zkmoiH8wAADrqw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zY93zSYZBBgf/SVhcXniJ1eL+16OM
	Fpd3zWGzON3N6sDicefaHjaPeScDPfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugStjxcrHTAWL
	2Cs2XG5hamD8xdrFyMkhIWAicWLKbWYIW0ziwr31bF2MXBxCAssYJfb9OsMEUzRxz3lmiMR0
	RonVr5rZIZxfjBKLbz9nAaliE1CT+PLlMFCCg0NEwE+iYQWYySzgInF0mghIhZCArcTxFc1g
	yzgF7CQeTlsJdoSwgJfEqtU9TCDlLAKqEn1HIkHCvEDlq04fZoawBSV+TL4HtohZQEti/c7j
	TBC2vMTmNW+ZQVolBNQlHv3VBQmLCBhJvFg8jw2iRERi34t3jCAHSwicY5f42D0JrJdFQEDi
	2+RDLBC9shKbDkCDQVLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJjveLE
	3OLSvHS95PzcTYyQaOzfwXj3gPUhxmSg9ROZpUST84HRnFcSb2hsZmRhamJqbGRuaUaasJI4
	r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxjTuy5Kv1zkXu7S1zn1y5UCCbHLipwuK
	33lTEo0VxMtXRN5XXeU69e7V/xE+cw68yXi3N6Uu7PP0jNjXHeZt06IEjASL2tzMn5S8fhl1
	bjV3XE+s56c7e2X3W12fIssSurz+rG0Bg5S0aCVbn7vwBYMHdTw+kr7JXivvf4l6En786SqH
	qSWnlFiKMxINtZiLihMBOvuqItwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jQd3zSYZBBmvWiFpcXniJ1eL+16OM
	Fpd3zWGzON3N6sDicefaHjaPeScDPfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xY8XKx0wFi9grNlxuYWpg/MXaxcjJISFgIjFxz3lmCFtM4sK99Wxd
	jFwcQgLTGSVWv2pmh3B+MUosvv2cBaSKTUBN4suXw0AJDg4RAT+JhhVgJrOAi8TRaSIgFUIC
	thLHVzSDzeQUsJN4OG0l2C5hAS+JVat7mEDKWQRUJfqORIKEeYHKV50+zAxhC0r8mHwPbBGz
	gJbE+p3HmSBseYnNa94yg7RKCKhLPPqrCxIWETCSeLF4HhtEiYjEvhfvGCcwCs1CMmkWkkmz
	kEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgWH8mvYNxVYPFIUYBDkYlHt6O
	WQZBQqyJZcWVuYcYJTiYlUR4480Ng4R4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5iG8kri
	DY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBkXGaDzvTvmmPql2t
	JRZ6fD7wubjlTOLtNcfzJ4S9iGtZYXaAQ3bh+0Mbv+3dusSfpUj3nYb/gbx5U6/85elQOZU6
	gX//NftMl2mfwzrt+HYVBJx9Jf112b5Is4Py8bt3LFp9t17H9UxKyfUZpyL1uxTfnHzNpqDW
	sWth0X2PmJDJ73qbP1k1NiixFGckGmoxFxUnAgBqcGU2OQMAAA==
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
 drivers/mfd/timberdale.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index a6755ec..084767b 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -829,12 +829,10 @@ err_config:
 err_ioremap:
 	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
 err_request:
-	pci_set_drvdata(dev, NULL);
 err_start:
 	pci_disable_device(dev);
 err_enable:
 	kfree(priv);
-	pci_set_drvdata(dev, NULL);
 	return -ENODEV;
 }
 
@@ -851,7 +849,6 @@ static void timb_remove(struct pci_dev *dev)
 
 	pci_disable_msix(dev);
 	pci_disable_device(dev);
-	pci_set_drvdata(dev, NULL);
 	kfree(priv);
 }
 
-- 
1.7.10.4


