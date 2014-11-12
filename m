Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaKLClT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:41:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:51235 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbaKLClO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:41:14 -0500
X-AuditID: cbfee68f-f791c6d000004834-cd-5462c8c78b3b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] ARM: dts: Fix the number of DMA channels for Exynos3250/4
Date: Wed, 12 Nov 2014 11:41:06 +0900
Message-id: <1415760068-765-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWyRsSkRPf4iaQQgy39khaT1h1gsrj+5Tmr
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72NyYPf4u+oFs8fmJfUefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlXH18HzWgg8sFRMe+Dcw/mLuYuTkkBAwkdi8vZEdwhaTuHBvPVsXIxeHkMBS
	RomerhesMEWPbm1jhkhMZ5RYc3QOK4TTxCTR8f8r2Cg2AS2J/S9usIHYIgKSEk0Nf8A6mAW2
	MEp8338YbIewgJ/EnT1nGUFsFgFViROTV7GA2LwCzhJf1/1mhFinILFs+UywDRIC39kklq5c
	DNUgIPFt8iGgBg6ghKzEpgNQP0hKHFxxg2UCo+ACRoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ
	+bmbGIHBevrfs/4djHcPWB9iFOBgVOLhzdicFCLEmlhWXJl7iNEUaMNEZinR5HxgTOSVxBsa
	mxlZmJqYGhuZW5opifMulPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx+EJUyqKPK/7/
	3D95t9KagBvbrIUkZ3GKnF+ydYJ6VdHUZZbdEi1tv+SvMD0U/bqpwZrvv1bXHo0PznXLcxNO
	ePA53353euONa7Int99eejTbZqnCs43/N85VKxWZe1qiz1t2L8vs6WU2mQ+Mp+h/Myx6LqzK
	bGTD/rTyRIeNxvUQt2WrN51mVmIpzkg01GIuKk4EAAHKPalRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xoO7xE0khBs8eCFhMWneAyeL6l+es
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/Jgd3j76oXzB6bl9R79G1ZxejxeZNcAEtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMq4fnsxZ8YKmY8MC/gfEXcxcjJ4eE
	gInEo1vboGwxiQv31rN1MXJxCAlMZ5RYc3QOK4TTxCTR8f8rWBWbgJbE/hc32EBsEQFJiaaG
	P8wgRcwCWxglvu8/zA6SEBbwk7iz5ywjiM0ioCpxYvIqFhCbV8BZ4uu634wQ6xQkli2fyTqB
	kXsBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBYeCa9g3FVg8UhRgEORiUe3ozNSSFC
	rIllxZW5hxglOJiVRHgfLAUK8aYkVlalFuXHF5XmpBYfYjQF2j6RWUo0OR8Yp3kl8YbGJmZG
	lkbmhhZGxuZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhhL3aMbT/vNEytZdsZHzlxs/z9f
	+Yt3xAPbHtcbMOd6HBaYwd/JnL3Yd2JZKdub6KbCjcc3snm8MwhZr3O0qWG/6ibPOA0nFfd9
	qmJ7L/hOtFAXfeSv/sdXfnPEkQPsrPsqmw9xL7x/ufFZ7grzSbJcMlPbf2w+mmP+oYp374f5
	08RnMd3ZxqrEUpyRaKjFXFScCACVUWxrmwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix minor issuse to correct the number of DMA channels for
Exynos3250 and Exynos4 series. The PL330 DMA of Exynos3250/Exynos4 support
16 channels simultaneously but, PL330 DMA driver don't use 'dma-channels'
property directly. This patchset fix the correct information
of Exynos3250/Exynos4's PL330 DMA simply.

Chanwoo Choi (2):
  ARM: dts: Fix the number of DMA channels for Exynos3250
  ARM: dts: Fix the number of DMA channels for Exynos4

 arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
 arch/arm/boot/dts/exynos4.dtsi    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.5.5

