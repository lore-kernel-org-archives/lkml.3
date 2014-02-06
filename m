Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaBFIWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:22:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46594 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaBFIWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:22:37 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-6d-52f3464ccf7b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Ben Dooks'" <ben.dooks@codethink.co.uk>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 07/12] backlight: ili9320: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:22:36 +0900
Message-id: <000801cf2314$979de820$c6d9b860$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAQpsQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA10ft89BBv/nWlrMWb+GzeLBrVYm
	i8sLL7FaXN41h82BxePZy8lMHidm/Gbx6NuyitHj8ya5AJYoLpuU1JzMstQifbsErowHL04z
	Fpxjq2j//o+lgXEvaxcjJ4eEgInE++MvWSBsMYkL99azdTFycQgJLGOUeHPiGhtM0dyvf6ES
	0xklPu37ywzh/GKU+Pv0Glg7m4CaxJcvh9m7GDk4RAT0JdpaNEBMZoF8iWfT9EEqhARsJXaf
	Pgm2mFPATmLbp1YmEFtYwEviz7ZmZpByFgFVienP8kDCvEDlc7dfZ4GwBSV+TL4HZjMLaEms
	33mcCcKWl9i85i1Yq4SAusSjv7ogYREBI4kHLy5AlYhI7HvxjhHkYAmBc+wSf+4cAEuwCAhI
	fJt8iAWiV1Zi0wFmiG8lJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtQr
	TswtLs1L10vOz93ECInI3h2Mtw9YH2JMBlo/kVlKNDkfGNF5JfGGxmZGFqYmpsZG5pZmpAkr
	ifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cA4e/nf9zejFQqt6/VPbK68qpszdz6n
	W4TUO06mzLmitybby1zvapwRZhot9WTiisW9FSY12earWRd11u+bcMN03pUV5zT4N6g+utLR
	0WbHGj5vT05GSy+fV5RJ2/xF19VVCzOLvrzuKbHQObCoqq5vfU0u68KpS+4KvfdZ9zhorlGG
	zsPdG+8qsRRnJBpqMRcVJwIAW6ws8N4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQV0ft89BBu1XTC3mrF/DZvHgViuT
	xeWFl1gtLu+aw+bA4vHs5WQmjxMzfrN49G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGgxenGQvOsVW0f//H0sC4l7WLkZNDQsBEYu7Xv2wQtpjEhXvr
	gWwuDiGB6YwSn/b9ZYZwfjFK/H16jQWkik1ATeLLl8PsXYwcHCIC+hJtLRogJrNAvsSzafog
	FUICthK7T58Em88pYCex7VMrE4gtLOAl8WdbMzNIOYuAqsT0Z3kgYV6g8rnbr7NA2IISPybf
	A7OZBbQk1u88zgRhy0tsXvMWrFVCQF3i0V9dkLCIgJHEgxcXoEpEJPa9eMc4gVFoFpJJs5BM
	moVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMf7M+kdjKsaLA4xCnAwKvHw
	blj/KUiINbGsuDL3EKMEB7OSCO9W889BQrwpiZVVqUX58UWlOanFhxiTgf6cyCwlmpwPTEV5
	JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cA4nanRlklExGvx
	DJfi4jM/Nmz89FDFNOFAm+e6wwbf5bq0pTYu+tRYeWKaYYx6zueK2oLTztzmH9bWzihYJL5J
	MKu5LYXrv4wmz2f9vsu3tFl3nSoJXWG8PMhAVHarWGc6x+ubXPPylYpn/9H7q/dCzjE6TT1T
	ITzjpe7eOb7mhuITfxlpSCixFGckGmoxFxUnAgDEOojAOwMAAA==
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
 drivers/video/backlight/ili9320.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index e2b8b40..2cf39e6 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -219,10 +219,8 @@ int ili9320_probe_spi(struct spi_device *spi,
 	/* allocate and initialse our state */
 
 	ili = devm_kzalloc(&spi->dev, sizeof(struct ili9320), GFP_KERNEL);
-	if (ili == NULL) {
-		dev_err(dev, "no memory for device\n");
+	if (ili == NULL)
 		return -ENOMEM;
-	}
 
 	ili->access.spi.id = ILI9320_SPI_IDCODE | ILI9320_SPI_ID(1);
 
-- 
1.7.10.4


