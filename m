Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbaBFIUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:20:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29023 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaBFIUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:20:38 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-fb-52f345d36dec
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Maxime Ripard'" <maxime.ripard@free-electrons.com>,
        "'Alexandre Belloni'" <alexandre.belloni@free-electrons.com>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 05/12] backlight: hx8357: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:20:35 +0900
Message-id: <000601cf2314$4f66a9c0$ee33fd40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAMIJg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zI93Lrp+DDL4ss7KYs34Nm0XHtcVM
	FpcXXmK1uLxrDpvF1k17mR1YPZ5susjocWLGbxaPvi2rGD0+b5ILYInisklJzcksSy3St0vg
	ypj85zV7wWy2ir99e1gbGPtYuxg5OSQETCS2fJsJZYtJXLi3ng3EFhJYxiixZnkCTM22k1+Y
	uhi5gOKLGCX2nP/KAuH8Aipa/Rysg01ATeLLl8PsXYwcHCIC+hJtLRogNcwCOxgl3nS0s0JM
	tZXYffokmM0pYCex7VMrE4gtLOApcWdyCwuIzSKgKrHtzRqwOC9Q/fMpR6BsQYkfk++B1TAL
	aEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYS/258gyoRkdj34h0jxDO32CW2LZCGWCUg
	8W3yIRaIVlmJTQeYIUokJQ6uuMEygVFiFpLFs5AsnoVk8SwkGxYwsqxiFE0tSC4oTkovMtUr
	TswtLs1L10vOz93ECInOiTsY7x+wPsSYDLR+IrOUaHI+MLrzSuINjc2MLExNTI2NzC3NSBNW
	EudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFRUDptx9/pvOKzHIudE5xOBm3Zkzvx
	o7JG51POA7IKhXeXHFSPil95TOa96Z0Ppvat5UZ7Hvu+m8B7dUPEzp3a1mobLQMilwQ/z+S6
	8PPTab35vbn2afyhoX9/zY3+xjplspnvxji20ycs9pVIiJ5akLRVUlYk+v2j3bUH1HdXnpwl
	uT5ceZOLEktxRqKhFnNRcSIAYuyS4+QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jAd3Lrp+DDFY+NbOYs34Nm0XHtcVM
	FpcXXmK1uLxrDpvF1k17mR1YPZ5susjocWLGbxaPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqspFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsY8yY/Oc1e8Fstoq/fXtYGxj7WLsYOTkkBEwktp38wgRh
	i0lcuLeerYuRi0NIYBGjxJ7zX1kgnF+MEmtWP2cDqWITUJP48uUwexcjB4eIgL5EW4sGSA2z
	wA5GiTcd7WBThQRsJXafPglmcwrYSWz71Aq2QVjAU+LO5BYWEJtFQFVi25s1YHFeoPrnU45A
	2YISPybfA6thFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKERQSMJP7d+AZVIiKx78U7xgmM
	QrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4/p9J72Bc1WBx
	iFGAg1GJh3fD+k9BQqyJZcWVuYcYJTiYlUR4t5p/DhLiTUmsrEotyo8vKs1JLT7EmAz06ERm
	KdHkfGBqyiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxvWL
	z31c9jdPdSJn1ATbyl+L1y5oTV6fNNHDcJuc3HTlVSW2Z951Gho0vy7SzeLqW5hbN6P3yb/E
	qU4f4vrvm77+nrrVxlz5w5YfJ3I56qLbqie93eGQcXvXuUb/3GN7NLcLHbB9dc1J5Gr9nr0S
	N8LZPkyxblhUI7tLYf7lKxM1g6zja3X4lymxFGckGmoxFxUnAgAnpvg4QwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/hx8357.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
index 985e854..23f50b9 100644
--- a/drivers/video/backlight/hx8357.c
+++ b/drivers/video/backlight/hx8357.c
@@ -587,10 +587,8 @@ static int hx8357_probe(struct spi_device *spi)
 	int i, ret;
 
 	lcd = devm_kzalloc(&spi->dev, sizeof(*lcd), GFP_KERNEL);
-	if (!lcd) {
-		dev_err(&spi->dev, "Couldn't allocate lcd internal structure!\n");
+	if (!lcd)
 		return -ENOMEM;
-	}
 
 	ret = spi_setup(spi);
 	if (ret < 0) {
-- 
1.7.10.4


