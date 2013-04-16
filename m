Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3DPJa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:30:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46397 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3DPJax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:30:53 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-03-516d1a4b8ed2
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Chris Ball'" <cjb@laptop.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Bing Zhao'" <bzhao@marvell.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1365698338-27503-1-git-send-email-dianders@chromium.org>
 <001701ce39d2$c0dbf8c0$4293ea40$%jun@samsung.com>
 <CAD=FV=XqmLRjQPwWCZfw0Nfu_uK16SOP=OgJcrbziWs4e__h7A@mail.gmail.com>
In-reply-to: <CAD=FV=XqmLRjQPwWCZfw0Nfu_uK16SOP=OgJcrbziWs4e__h7A@mail.gmail.com>
Subject: RE: [PATCH] mmc: dw_mmc: exynos: Turn SDIO interrupts on
Date: Tue, 16 Apr 2013 18:30:51 +0900
Message-id: <001601ce3a85$16087f00$42197d00$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac456qokNU0ujioMQkyLKxZCuChTqwAWSFUQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zfV1vqdxAg4/L9CzmbT3KarH99UY2
	i7PLDrJZ3PjVxmpxedccNosj//sZLU5d/8xmcfJPL6PFsRlLGB04PWY3XGTxOHRlLaPHnWt7
	2DyunGhi9Zi88CKzR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGWcn3CYpaBVoOLlf90Gxr08
	XYwcHBICJhL7vnp1MXICmWISF+6tZwOxhQSWMUq03LCCiJtInN7wgLWLkQsoPp1RYtXjC6wQ
	RX8YJY7+AmtmE9CS+PvmDTOILSKgLfHywUpmkAZmgRVMEmfWt7BDdB9glJhydCI7yGZOgWCJ
	tb3WIKawgKPEzf8GIL0sAqoSl5/vYOxiZOfgFbCVuF0FEuUVEJT4MfkeC0gxs4CexP2LWiBh
	ZgF5ic1r3jJDPKIu8eivLsR+I4kzvXPYIUpEJPa9eMcIsl5CYCKHxLOmb2wQiwQkvk0+xALR
	Kyux6QAzxLOSEgdX3GCZwCgxC8niWQiLZyFZPAvJhgWMLKsYRVMLkguKk9KLTPWKE3OLS/PS
	9ZLzczcxQuJ64g7G+wesDzEmA22fyCwlmpwPTAt5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gH
	CgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamC8lMhecpD/RYewwaMH+ZLvVMsFNi3gyN7QaqVn
	WbtzHePG3iKNDTqsdTH7jh/ve3wxO6ng42GTsPmaWUs/XZ7/JuMt87792yrt3qt87VvRa3d3
	ihhDctLDP/Msdtoa8Vj8SxJzeT3fSuKCyjKHJMXT82pqp6y5VS9+z62r8mJlX0JJ5B61ZduV
	WIozEg21mIuKEwFWfNzMAQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jQV1vqdxAgyM3NSzmbT3KarH99UY2
	i7PLDrJZ3PjVxmpxedccNosj//sZLU5d/8xmcfJPL6PFsRlLGB04PWY3XGTxOHRlLaPHnWt7
	2DyunGhi9Zi88CKzR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
	GlpamCsp5CXmptoqufgE6Lpl5gDdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfI
	AA0krGPMOD/hMEtBq0DFy/+6DYx7eboYOTkkBEwkTm94wAphi0lcuLeerYuRi0NIYDqjxKrH
	F8ASQgJ/GCWO/vICsdkEtCT+vnnDDGKLCGhLvHywkhmkgVlgBZPEmfUt7BDdBxglphydCORw
	cHAKBEus7bUGMYUFHCVu/jcA6WURUJW4/HwHYxcjOwevgK3E7SqQKK+AoMSPyfdYQIqZBfQk
	7l/UAgkzC8hLbF7zlhkkLCGgLvHory7EfiOJM71z2CFKRCT2vXjHOIFRaBaSQbMQBs1CMmgW
	ko4FjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYITxzOpHYwrGywOMQpwMCrx8AbI5wQK
	sSaWFVfmHmKU4GBWEuFVXw4U4k1JrKxKLcqPLyrNSS0+xJgM9OREZinR5HxgUssriTc0NjEz
	sjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsYNyyyeMMd5vJJfndDpbXGE
	0Zv5+p8KXckXRc6XVRvvb/rwfOJCx5kzvj057sdyoz5nBWtDmcplc79Lv37ta1pbYOjNK+o5
	vWSqd8BJ+0PfdKp9zzx83ndQ4fBOLRM7pi3bCl579Tmb7Sp9zBqy49QMi54/mmEKga+SriwW
	TjF57vfil6xd4mIlluKMREMt5qLiRAAanSR8YAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 16, 2013, Doug Anderson
> Seungwon,
> 
> On Mon, Apr 15, 2013 at 5:14 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> >> +             MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
> >> +     MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
> > This line for [1]
> >> +     MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
> >> +     MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
> > [1] is for mshc1. mshc1 is only used for SDIO.
> > As I know, The others are improper for SDIO.
> 
> I'm nearly certain that all of the ports are OK for SDIO.  Specifically:
> 
> * On the ARM Chromebook (exynos5250) we are using mmc3 (12230000) for
> the SDIO connection to WiFi.
> 
> * I have plugged in an external WiFi module to the SD card slot on the
> ARM Chromebook and seen it work (including interrupts).  This is mmc2
> (12220000).
Yes, we also have tested WiFi module type of sd slot with ch#2.

> 
> * I have seen a board where mmc1 was wired up to WiFi and seen it work.
Yes, mmc2, mmc3 can 
> 
> 
> It is possible that mmc0 wouldn't work for SDIO.  I've never tested it
> since mmc0 is intended for eMMC and every system I've worked with has
> eMMC on that port.  There is some evidence that mmc0 would work for
> SDIO, though: there is a muxing slot on GPC0[2] for SD_0_CARD_INT_n.
> That implies that mmc0 ought to also work for SDIO (and even could be
> configured for an external eSDIO interrupt, I guess).
I don't mean that SDIO is impossible except in ch#1.
Basically, SDIO device can be attached on all host's channel and may works.
In case of ch#0, it's almost dedicated for eMMC and is actually arranged for eMMC.
And ch#1 is recommended for SDIO and can support UHS-I speed.
So, I don't think MMC_CAP_SDIO_IRQ is needed to ch#0.
Similarly, MMC_CAP_SDIO_IRQ is not a good choice for ch#2, ch#3 by default.
If needed for specific channel, it can be got from dts as property.
if (of_find_property(np, "cap-sdio-irq", NULL))
	pdata->caps |= MMC_CAP_SDIO_IRQ;
	
Thanks,
Seungwon Jeon
> 
> 
> Thanks!
> 
> -Doug

