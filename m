Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3IWBh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:37:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48851 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3IWBhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:37:25 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-af-523f9b544128
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Tomas Winkler'" <tomas.winkler@intel.com>
References: <003101ceb7fd$21e97540$65bc5fc0$%han@samsung.com>
In-reply-to: <003101ceb7fd$21e97540$65bc5fc0$%han@samsung.com>
Subject: [PATCH 3/4] misc: mei: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:37:24 +0900
Message-id: <003401ceb7fd$7417d190$5c4774b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac63/SHKB4kHrvrSQPCGprHejMhtRAAAC/KA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI92Q2fZBBofa5Sz+TjrGbtG8eD2b
	xeWFl1gtLu+aw2bxoafOgdXj969JjB6L97xk8tg/dw27R9+WVYwenzfJBbBGcdmkpOZklqUW
	6dslcGU83/iCtWAHa8XkuXMYGxj3snQxcnJICJhI3Fw/nwnCFpO4cG89WxcjF4eQwDJGiVOT
	/rPDFL3Z1waVmM4ocXfDVGYI5xejxO83x9lAqtgE1CS+fDkM1iEiYCqx8f0URpAiZoFJjBKX
	3k0ESwgJ2Eos3biUGcTmFLCTePfzJ5DNwSEs4CJxuRcszCKgKvFjwUdGEJsXqPxP81ooW1Di
	x+R7YGczC2hJrN95nAnClpfYvOYt2BgJAXWJR391IU4wkvi+/wZUiYjEvhfvwM6RELjGLnGk
	4R0rxC4BiW+TD7FA9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckF
	xUnpRcZ6xYm5xaV56XrJ+bmbGCGR2r+D8e4B60OMyUDrJzJLiSbnAyM9ryTe0NjMyMLUxNTY
	yNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MwdMY9ryu0PqzOG3H9CNc
	LhUSK5eWxN6caJg9xS9sxdamIo6v2gH7Il7z+4XXubT/ZHn1aSmn9pOjxd+/OyXeXLfe93WT
	7bLqFd4fj87k+OYrJ7xcXJGl+86mLQccn/Q1TBdZ0Gxx6mtFzAlDO0GJ5bb6Jv9vP7fb48eo
	p/LsMuMBv5tXm00XK7EUZyQaajEXFScCABs80A/qAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd2Q2fZBBlfPS1n8nXSM3aJ58Xo2
	i8sLL7FaXN41h83iQ0+dA6vH71+TGD0W73nJ5LF/7hp2j74tqxg9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMeL7xBWvBDtaKyXPnMDYw7mXpYuTkkBAwkXiz
	r40NwhaTuHBvPZDNxSEkMJ1R4u6GqcwQzi9Gid9vjoNVsQmoSXz5cpgdxBYRMJXY+H4KI0gR
	s8AkRolL7yaCJYQEbCWWblzKDGJzCthJvPv5E8jm4BAWcJG43AsWZhFQlfix4CMjiM0LVP6n
	eS2ULSjxY/I9sOuYBbQk1u88zgRhy0tsXvMWbIyEgLrEo7+6ECcYSXzffwOqRERi34t3jBMY
	hWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwGngmtYNxZYPF
	IUYBDkYlHt6IRPsgIdbEsuLK3EOMEhzMSiK8TZ1AId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYS
	Tc4Hpqi8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamAsKtJT
	89a69OtUvUlNajn7JPZDyps5A1s4ygLf3W8XNzC61eB//szSVJmvvG+Wd51I/t3DmOaweJ/o
	8kL5Nb6a+z7+SM16dF3Q1kzqtS9v0FsftnS9PTHf/CTLXM7J3JjEIqBxfunFpvNcbzZuXTFh
	g+jDSYr7etX1z931/hSq0Lq7pfVfd6sSS3FGoqEWc1FxIgCFrUjyRwMAAA==
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
 drivers/misc/mei/pci-me.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1b3844e..1b8a4c6 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -239,7 +239,6 @@ static void mei_me_remove(struct pci_dev *pdev)
 
 	free_irq(pdev->irq, dev);
 	pci_disable_msi(pdev);
-	pci_set_drvdata(pdev, NULL);
 
 	if (hw->mem_addr)
 		pci_iounmap(pdev, hw->mem_addr);
-- 
1.7.10.4


