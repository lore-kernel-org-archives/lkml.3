Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3KGKsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:48:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25545 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3KGKst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:48:49 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-de-527b7010b838
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org, cpgs@samsung.com
Subject: Re: [PATCH 1/3 v8] thermal: samsung: add intclr_fall_shift bit in
 exynos_tmu_register struct
Date: Thu, 07 Nov 2013 11:48:42 +0100
Message-id: <1864683.tCrpAXuim8@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1383803562-31752-1-git-send-email-ch.naveen@samsung.com>
References: <1381979473-7079-1-git-send-email-ch.naveen@samsung.com>
 <1383803562-31752-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jQV2Bguogg1MtwhYNV0Ms7j4/zGjx
	8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjc+D22DnrLrvH
	4j0vmTz6tqxi9Dh+YzuTx+dNcgGsUVw2Kak5mWWpRfp2CVwZbb3HWQu+s1dsXXuFvYFxI1sX
	IyeHhICJxPHtx5kgbDGJC/fWA8W5OIQEpjNKrDyzA8ppYZL4fnY9K0gVm4CVxMT2VYwgtghI
	96sz7CBFzALdTBLLn1wDGyUskC5xpv8aM4jNIqAqsftLM5jNK6Ap8fLYbTBbVMBTYsf2lUAb
	ODg4BdwkTv6shljWwCix5d1BqHpBiR+T77GA2MwC8hL79k9lhbB1JPa3TmObwCgwC0nZLCRl
	s5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHA3PpHYwrmywOMQowMGoxMM7o6Yq
	SIg1say4MvcQowQHs5IIb3NIdZAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZ
	qakFqUUwWSYOTqkGRt6+4yc8Y85++ueWZFqX1hU4+cOfntV7My71PdvzzztKUMr2nswE0eYr
	+xnEa8PWppzV6lkp02N07uxRsbLfC9tTtj//2O1yPWB9cd62fp2cVwev5nfzHNNUnsqf+/jU
	gZIAaQNOg75jVluN3kTlKob1NJ4NMTHfoFCVzPNfNuiplM2RL5buSizFGYmGWsxFxYkA6Y8W
	+IICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, November 07, 2013 11:22:42 AM Naveen Krishna Chatradhi wrote:
> On Exynos5250, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT registers and at an offset of
> 12 in INTCLEAR register.
> 
> On Exynos5420, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT and INTCLEAR registers.
> 
> On Exynos5440,
> the FALL_IRQEN bits are at an offset of 4
> and the RISE_IRQEN bits are at an offset of 0
> 
> This patch introduces a new bit field intclr_fall_shift to handle the
> offset for exyns5250 and exynos5440
> Also removes the unused macros EXYNOS_TMU_FALL_INT_SHIFT and
> EXYNOS5440_TMU_FALL_INT_SHIFT, inten_fall_shift field

Thanks for fixing this.  All three patches look good to me now.

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

