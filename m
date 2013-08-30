Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3H3ENw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:13:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50860 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3H3ENv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:13:51 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-05-52201bfd7d09
From: Jingoo Han <jg1.han@samsung.com>
To: "'Hans J. Koch'" <hjk@hansjkoch.de>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01cea537$10ed8930$32c89b90$%han@samsung.com>
In-reply-to: <002b01cea537$10ed8930$32c89b90$%han@samsung.com>
Subject: [PATCH 3/3] drivers: uio_pruss: use dev_get_platdata()
Date: Fri, 30 Aug 2013 13:13:50 +0900
Message-id: <002d01cea537$54af4500$fe0dcf00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6lNxC0zCCz2b5JSCutk7ruoAGsQQAAC2/Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zfd2/0gpBBhNf6lg0L17PZnH07HR2
	i8sLL7FaXN41h82BxWP+Qy+P/XPXsHv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxoSuC8wF
	X9gqes6/YW9gfMjaxcjJISFgItH1rIkZwhaTuHBvPVsXIxeHkMAyRonrTw8wwhQ9XH4DrEFI
	YDqjxJwTeRBFvxglfv9ZA1bEJqAm8eXLYfYuRg4OEQF1iZ8tcSAms0ClxOLuGBBTSMBW4sty
	NpBiTgE7iTvnJoBNFBawl3i/4jFYnEVAVeLS5hmMIOW8QOUdi0xAwrwCghI/Jt9jAbGZBbQk
	1u88zgRhy0tsXvOWGaRcAmjno7+6IGERASOJpTO/MEKUiEjse/GOEeReCYFT7BJbdn1gh1gl
	IPFt8iEWiF5ZiU0HoIEgKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kale
	cWJucWleul5yfu4mRkgsTtzBeP+A9SHGZKD1E5mlRJPzgbGcVxJvaGxmZGFqYmpsZG5pRpqw
	kjiveot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGFckTXzdvE2zNlTkX+8Z9wa4ZMbPX
	mhyxjPi0uS5y7pWZNtc5z92wNNbMOnVc7ef8uV4Za1g3GixR/HiYxz/usIBXr+JBJadtbHKn
	Fcpc19zk82FIjfoROeWQw4kNNVwLrmjmG2hGvBewMfVsXFfnnhwiIr1dYubsnrC8ymdCzT8u
	rU5/1yujxFKckWioxVxUnAgA+liKstsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQd2/0gpBBn87NC2aF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWNC1wXmgi9sFT3n37A3MD5k7WLk5JAQMJF4uPwGlC0mceHeejYQ
	W0hgOqPEnBN5XYxcQPYvRonff9YwgiTYBNQkvnw5zN7FyMEhIqAu8bMlDsRkFqiUWNwdA2IK
	CdhKfFkONoVTwE7izrkJYNOFBewl3q94DBZnEVCVuLR5BiNIOS9QecciE5Awr4CgxI/J91hA
	bGYBLYn1O48zQdjyEpvXvGUGKZcA2vnory5IWETASGLpzC+MECUiEvtevGOcwCg0C8mkWUgm
	zUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgiP9mfQOxlUNFocYBTgYlXh4
	G6bKBwmxJpYVV+YeYpTgYFYS4Y3fBhTiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGASyiuJ
	NzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRu3/IlPtW3mf6H36
	yddmYr/LY8PsgjkXt/S31ehEloU7Cz/iLrr0bs8y1hNzrh6IYInimnlusgnnos2aehlcSs0x
	Wp63Dbbkbk4+u/WdpO3cuEfp7zjCF9gG+9Ttr5Y8/S4ns5W1u+6ZacIN44fs76r2TToxIyz+
	GY9jztXZ01tiutju/ynbr8RSnJFoqMVcVJwIAF8OFPI4AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/uio/uio_pruss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
index df75346..f519da9 100644
--- a/drivers/uio/uio_pruss.c
+++ b/drivers/uio/uio_pruss.c
@@ -121,7 +121,7 @@ static int pruss_probe(struct platform_device *dev)
 	struct uio_pruss_dev *gdev;
 	struct resource *regs_prussio;
 	int ret = -ENODEV, cnt = 0, len;
-	struct uio_pruss_pdata *pdata = dev->dev.platform_data;
+	struct uio_pruss_pdata *pdata = dev_get_platdata(&dev->dev);
 
 	gdev = kzalloc(sizeof(struct uio_pruss_dev), GFP_KERNEL);
 	if (!gdev)
-- 
1.7.10.4


