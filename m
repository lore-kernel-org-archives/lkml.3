Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaG1Aj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 20:39:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60124 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaG1Ajz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 20:39:55 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-66-53d59bd9b61a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "=?UTF-8?Q?'Andreas_F=C3=A4rber'?=" <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
Cc: "'Tarek Dakhran'" <t.dakhran@samsung.com>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1406463725-4208-1-git-send-email-afaerber@suse.de>
 <53D4EFBB.6000404@suse.de>
In-reply-to: <53D4EFBB.6000404@suse.de>
Subject: RE: [PATCH 0/3] ARM: EXYNOS: Fix Exynos5410 boot
Date: Mon, 28 Jul 2014 09:39:53 +0900
Message-id: <00c901cfa9fc$727b4e10$5771ea30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGL1z+9jtB2rTxYt9Lq23w+zrC3BgJGVL7mnCoXY0A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zQ92bs68GG9zu0LRo3lRs8fXwCkaL
	TY+vsVpc3jWHzWLG+X1MFou2fmG3WP/8FKPF+hmvWRw4PO5c28PmsXlJvUffllWMHptPV3t8
	3iQXwBrFZZOSmpNZllqkb5fAlbFxplpBG3vFyTmvWBoYZ7B2MXJySAiYSPz68pIRwhaTuHBv
	PVsXIxeHkMAyRomG9TPYYYqWLjzODJFYxCjx9Pg+qKq/jBK7LzexgVSxCWhIHH7/DKxDRCBW
	4vD2W2AdzAIvGSX6+3eCFQkJxEj03L4NZnMKqEv8+P+RBcQWFrCUmPR3CdgdLAKqEl/7loPF
	eYHiC75dYYKwBSV+TL4HFmcG6p00bxEzhK0t8eTdBah/FCR2nH3NCHGElcTsxmlQ9SIS+168
	g/rzEbvEwhWcELsEJL5NPgRUwwEUl5XYdIAZokRS4uCKGywTGCVmIdk8C8nmWUg2z0KyYQEj
	yypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkBju28F484D1IcZkoPUTmaVEk/OBKSCvJN7Q
	2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTD2c8xN/XXb
	VsOd5dVWzZIDW+4cCSx8+uf8tqSCwwb/Y9rmRd0RqY/dZle7qrRh5/YbU1eK3+s7k294hz9C
	p9uIqXg6k3F/41Mmu7YvD45pnWnaFf6c4YVadXiexFw99pnJ64or2NNncN+zLaxJ/NWs3/XB
	e7rSoiduR2cv80+bFejVYd0TMkeJpTgj0VCLuag4EQB2zmVA9wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAd2bs68GG1xfr2rRvKnY4uvhFYwW
	mx5fY7W4vGsOm8WM8/uYLBZt/cJusf75KUaL9TNeszhweNy5tofNY/OSeo++LasYPTafrvb4
	vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+gSJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGxplqBW3sFSfnvGJp
	YJzB2sXIySEhYCKxdOFxZghbTOLCvfVsXYxcHEICixglnh7fB+X8ZZTYfbmJDaSKTUBD4vD7
	Z+wgtohArMTh7beYQYqYBV4ySvT37wQrEhKIkei5fRvM5hRQl/jx/yMLiC0sYCkx6e8SRhCb
	RUBV4mvfcrA4L1B8wbcrTBC2oMSPyffA4sxAvZPmLWKGsLUlnry7AHW2gsSOs68ZIY6wkpjd
	OA2qXkRi34t3jBMYhWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwingmtYNxZYPFIUYBDkYlHl6L4KvBQqyJZcWVuYcYJTiYlUR4X7YDhXhTEiurUovy44tK
	c1KLDzGaAn06kVlKNDkfmL7ySuINjU3MjCyNzCyMTMzNlcR5D7RaBwoJpCeWpGanphakFsH0
	MXFwSjUw8ibPF2azYt+trtjAfP/z+v/vRTRU7OY9vn3ssbq/kbhQo92jTNveRvWAC8lWBWYT
	glNbZt+bk2N8P3CyZqrov+fzE3cdthb28jMp+f5ySePa4qCn3JxHdz2ZFP626VXt650rki2X
	MCy9+GOhfcxn7r52t7rbT08HWKzcadjZd21WzS3Ru4xzlFiKMxINtZiLihMBOLB6ICcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Färber wrote:
> 
> Am 27.07.2014 14:22, schrieb Andreas Färber:
> > Hello,
> >
> > This mini-series unbreaks booting on 5410 based ODROID-XU.
> >
> > Since I do not have access to a TRM, the address is a guess based on
> > 5250 and 5410. Such a node was not present in the 3.14 downstream tree.
> 
> s/5410/5420/
> 
OK.

> >
> > Regards,
> > Andreas
> >
> > Andreas Färber (3):
> >   Documentation: devicetree: Document exynos5410 PMU
> >   ARM: dts: exynos: Add PMU to Exynos5410
> >   ARM: EXYNOS: Add support for Exynos5410 PMU
> >
> >  Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
> >  arch/arm/boot/dts/exynos5410.dtsi                     | 5 +++++
> >  arch/arm/mach-exynos/exynos.c                         | 1 +
> >  3 files changed, 7 insertions(+)
> 
Andreas, thanks.

I'll apply this whole series.

- Kukjin

