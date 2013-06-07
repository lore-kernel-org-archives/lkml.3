Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3FGB3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 21:29:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29780 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3FGB3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:29:33 -0400
X-AuditID: cbfee68f-b7f436d000000f81-d3-51b1377cc576
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Shuah Khan'" <shuah.kh@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        rafael.j.wysocki@intel.com, Jingoo Han <jg1.han@samsung.com>
References: <1370128047-2444-1-git-send-email-shuah.kh@samsung.com>
 <001a01ce6010$3daaf3c0$b900db40$@samsung.com> <5441622.ypFXsKluBt@wuerfel>
In-reply-to: <5441622.ypFXsKluBt@wuerfel>
Subject: Re: [PATCH v3] backlight: Convert from Legacy pm ops to dev_pm_ops
Date: Fri, 07 Jun 2013 10:29:31 +0900
Message-id: <000101ce631e$75f5e120$61e1a360$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK9QIxMUpghtMTMupkAiMbuzB1IwQIFRl3tAcjGv3aXLUlKwA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t8zQ90a842BBqen8VjMWb+GzeLvpGPs
	Fp0zrzFaXF54idXiRN8HVovLu+awWax7+ILJ4vGKt+wWu3c9ZbX48pnL4utPB4v182+xOfB4
	/P41idFj56y77B4fPsZ5LN7zksnj1YU7LB4nZvxm8dgz/werR9+WVYwex29sZ/L4vEkugCuK
	yyYlNSezLLVI3y6BK6PhsnbBPJ6KAy9PMTcw/uLsYuTkkBAwkdh8ZAIzhC0mceHeerYuRi4O
	IYFljBJ3/i5ngSma07GSHSIxnVHiZN83ZgjnF6PErWsnwKrYBNQkvnw5zA5iiwgoSxx/eYcF
	pIhZ4CiTxNUFZ6DaJzBKvFzykQmkilNAU+LI5+WMILawgLdEy95VbCA2i4CqxMvfm8Gm8gpY
	SrR/2McOYQtK/Jh8DyzOLKAlsX7ncSYIW15i85q3UE8oSOw4+5oR4gonidblsxkhakQk9r14
	xwhyhITAFg6J6U//M0MsE5D4NvkQ0FAOoISsxKYDUHMkJQ6uuMECdO4sJKtnIVk9C8nqWUhW
	LGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kRkiD6dzDePWB9iDEZaP1EZinR5Hxggskr
	iTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2OMjd+k
	1Uyd3qpMgleOVh5oT2/Zf13CSPaPVqO1iVRH6PGI1+qGC99pbRZKYe36wv/dc+stvVu54eJs
	Ja9ntZW0t9b3Pz1x506qZMMRb5ULattmTzhUvJhnZecL3i/Ldh9/s9K81X/7zA8bX6xRe5EQ
	sJetgP9D8I6KhQ951y3kFn6V6nF7Y6YSS3FGoqEWc1FxIgAOSzZnJgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsVy+t9jQd0a842BBu1T2S3mrF/DZvF30jF2
	i86Z1xgtLi+8xGpxou8Dq8XlXXPYLNY9fMFk8XjFW3aL3bueslp8+cxl8fWng8X6+bfYHHg8
	fv+axOixc9Zddo8PH+M8Fu95yeTx6sIdFo8TM36zeOyZ/4PVo2/LKkaP4ze2M3l83iQXwBXV
	wGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S2kkJZ
	Yk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjGj4bJ2wTyeigMvTzE3MP7i7GLk
	5JAQMJGY07GSHcIWk7hwbz1bFyMXh5DAdEaJk33fmCGcX4wSt66dYAGpYhNQk/jy5TBYh4iA
	ssTxl3dYQIqYBY4ySVxdcIYdomMCo8TLJR+ZQKo4BTQljnxezghiCwt4S7TsXcUGYrMIqEq8
	/L0ZbCqvgKVE+4d97BC2oMSPyffA4swCWhLrdx5ngrDlJTavecsMcauCxI6zrxkhrnCSaF0+
	mxGiRkRi34t3jBMYhWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7u
	JkZw+nkmvYNxVYPFIUYBDkYlHt4fqzYECrEmlhVX5h5ilOBgVhLhPaWxMVCINyWxsiq1KD++
	qDQntfgQYzLQpxOZpUST84GpMa8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakF
	qUUwW5g4OKUaGAu4qpfPLzyw+qi4zfq8GQvfnbF3U21OncjFVfL+iZOGgrHjCimXHS/7551R
	k1A5qZAyM0fY4HY9s5R9xeL8khnbF0okFBQVSGt1Rr8z0Nq9e/JC6+XXxYPulCed1TX/Ndcj
	03jaLnuL/k7dom8vNTi9rPX/Hf/zas7UVyfLLwUejXLu87u6U4mlOCPRUIu5qDgRAM+pKS6D	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 07, 2013 6:28 AM, Arnd Bergmann wrote:
> On Monday 03 June 2013 13:10:10 Jingoo Han wrote:
> > On Sunday, June 02, 2013 8:07 AM, Shuah Khan wrote:
> > >
> > > Convert drivers/video/backlight/class to use dev_pm_ops for power
> > > management and remove Legacy PM ops hooks. With this change, backlight
> > > class registers suspend/resume callbacks via class->pm (dev_pm_ops)
> > > instead of Legacy class->suspend/resume. When __device_suspend() runs
> > > call-backs, it will find class->pm ops for the backlight class.
> > >
> > > Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> > > Cc: Shuah Khan <shuahkhan@gmail.com>
> >
> > CC'ed Andrew Morton,
> >
> > It looks good.
> >
> > Acked-by: Jingoo Han <jg1.han@samsung.com>
> >
> 
> I'm getting this build warning now:
> 
> arnd@wuerfel:/git/arm-soc$ cat build/omap1_defconfig/faillog
> /git/arm-soc/drivers/video/backlight/backlight.c:212:12: warning: 'backlight_suspend' defined but not
> used [-Wunused-function]
>  static int backlight_suspend(struct device *dev)
>             ^
> /git/arm-soc/drivers/video/backlight/backlight.c:226:12: warning: 'backlight_resume' defined but not
> used [-Wunused-function]
>  static int backlight_resume(struct device *dev)

Hi Arnd Bergmann,

I see what happens.
This build warning happens when CONFIG_PM is selected and
CONFIG_PM_SLEEP is not selected.

So, I will add '#ifdef CONFIG_PM_SLEEP' to './drivers/video/backlight/backlight.c'
and send it soon.
Thank you.

Best regards,
Jingoo Han

> 
> 	Arnd

