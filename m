Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3LBXXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:23:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30291 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3LBXXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:23:05 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-63-529d165837cc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Richard Cochran'" <richardcochran@gmail.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 24/39] ptp: ptp_pch: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:23:04 +0900
Message-id: <002d01ceefb5$738024e0$5a806ea0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABAQpg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zQ90IsblBBmunG1o0L17PZnF54SVW
	i8u75rBZHDnzgtmBxWPnrLvsHvvnrmH36NuyitHj8ya5AJYoLpuU1JzMstQifbsErowlp+sL
	Olgr/jVPZWpgnMrSxcjJISFgIrGi/wqULSZx4d56ti5GLg4hgWWMElvntzHBFK27v5oRIrGI
	UeLu/rksEM4vRombd3eygVSxCahJfPlymB3EFhEwldj4fgojiM0sUCLx79QmsElCArYS019s
	BrI5ODgF7CT6PtWChIUFPCUW7u9kBbFZBFQl3u14xwxi8wKVT378lgXCFpT4MfkeC8RILYn1
	O48zQdjyEpvXvGUGGSkhoC7x6K8uxAVGEudOn4UqF5HY9+Id2P0SAufYJT53rWSD2CUg8W3y
	IRaIXlmJTQeYIf6VlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yEivODG3
	uDQvXS85P3cTIyQm+3Yw3jxgfYgxGWj9RGYp0eR8YEznlcQbGpsZWZiamBobmVuakSasJM67
	6GFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGnFccP5t09lxQv85+ptOJ5/bZoxyvVsj7
	Pq74/S34stN33huKhluUF+dEpSTeZZ7buK/gwPYjPgzLJ9eFs9Ttmt78uHe32U0mB928pXPE
	dJ9sPXrD/F6lueNlt34VdvZsfaVGO4tHhTmzj2ts2fb3XLZr7tNbkqor8k5MlTZQ7zszeYWF
	n8AjJZbijERDLeai4kQA5cqRI98CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd0IsblBBktv6lo0L17PZnF54SVW
	i8u75rBZHDnzgtmBxWPnrLvsHvvnrmH36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMJafrCzpYK/41T2VqYJzK0sXIySEhYCKx7v5qRghbTOLCvfVs
	XYxcHEICixgl7u6fywLh/GKUuHl3JxtIFZuAmsSXL4fZQWwRAVOJje+ngHUzC5RI/Du1iQnE
	FhKwlZj+YjOQzcHBKWAn0fepFiQsLOApsXB/JyuIzSKgKvFuxztmEJsXqHzy47csELagxI/J
	91ggRmpJrN95nAnClpfYvOYtM8hICQF1iUd/dSEuMJI4d/osVLmIxL4X7xgnMArNQjJpFpJJ
	s5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Ih/Jr2DcVWDxSFGAQ5GJR7e
	B9vnBAmxJpYVV+YeYpTgYFYS4e3kmRskxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAZJRX
	Em9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYx5KtPLPiwTjLBu
	L9e6Yt5eOFn1mGP0ORtlJ82A+hvRG3eEe+116plt5i/Tcfv/3EQ+wYe7fjYozVnhbfwrSlj4
	VTaP8cy/vRvyNA4vuOHvPoVNO+1RRZuD5AT7C40sZ9k+3Vs3a8Z0DtUbre/OHHv9umudxdzD
	AjZz9vxpu1nPe1Q/XWJvoqsSS3FGoqEWc1FxIgDVKYlCPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/ptp/ptp_pch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 71a2559..4c9578a 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -690,7 +690,7 @@ err_pci_en:
 	return ret;
 }
 
-static DEFINE_PCI_DEVICE_TABLE(pch_ieee1588_pcidev_id) = {
+static const struct pci_device_id pch_ieee1588_pcidev_id[] = {
 	{
 	  .vendor = PCI_VENDOR_ID_INTEL,
 	  .device = PCI_DEVICE_ID_PCH_1588
-- 
1.7.10.4


