Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762533Ab3ECHgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 03:36:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20364 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3ECHgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 03:36:00 -0400
X-AuditID: cbfee68f-b7f066d000003683-07-518368d9caf5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Srinidhi Kasagar'" <srinidhi.kasagar@stericsson.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <001201ce47c6$daecece0$90c6c6a0$@samsung.com>
 <20130503065743.GA24864@bnru09>
In-reply-to: <20130503065743.GA24864@bnru09>
Subject: Re: [PATCH 04/42] rtc: rtc-ab8500: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 16:35:52 +0900
Message-id: <004f01ce47d0$d71d89d0$85589d70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKTTLmThltDODYxJpQZp1H+EZkL6AHh0uN2l1n4ezA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zQ92bGc2BBl+vaVssuXiV3WLO+jVs
	FpcXXmK1mPJnOZPF5V1z2Cz2d3YwWtza0sTmwO6xZ+JJNo871/aweZyY8ZvFo2/LKkaP70vX
	sHtMn/eTyePzJrkA9igum5TUnMyy1CJ9uwSujEWnd7MXnOeqmLP0E0sD4zmOLkZODgkBE4lV
	22YyQ9hiEhfurWfrYuTiEBJYxiix6NtGFpiiBxt7oRLTGSVWzFrOCJIQEvjFKLHmTAWIzSag
	JvHly2F2EFtEwELi7sc1YDXMAs+AGnrNIeqjJW6emw5WwymgI3FrcjPYAmGBcImmdX9ZQWwW
	AVWJns8QNq+ApcT17X/ZIGxBiR+T77FAzNSSWL/zOBOELS+xec1bqA8UJHacfc0IcYOVxLKJ
	66BuEJHY9+IdI0TNR3aJD7ftIXYJSHybfAhoJgdQXFZi0wGoMZISB1fcYJnAKDELyeZZSDbP
	QrJ5FpINCxhZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmKERHT/Dsa7B6wPMSYDrZ/ILCWa
	nA9MCHkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YEyq/G9x07M34Piti3x6Iq6f7gSedWwtOrKdPfbM4TC2/ReDWBvVAmu2Lf3y58jjhUnXuM8d
	OatbYu0v1nRn/+vuRRceeRulM296lVa1fmulRWvj6qxNd989udF9dkbcIr9le1dr7mJafaf9
	99WtWo+qO3o5Lx7fLu1Td1I79/L9Yw8mKLI1OzMrsRRnJBpqMRcVJwIAvNBMSf4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jQd2bGc2BBv9PqVssuXiV3WLO+jVs
	FpcXXmK1mPJnOZPF5V1z2Cz2d3YwWtza0sTmwO6xZ+JJNo871/aweZyY8ZvFo2/LKkaP70vX
	sHtMn/eTyePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxU
	WyUXnwBdt8wcoIuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmLTu9m
	LzjPVTFn6SeWBsZzHF2MnBwSAiYSDzb2skHYYhIX7q0Hsrk4hASmM0qsmLWcESQhJPCLUWLN
	mQoQm01ATeLLl8PsILaIgIXE3Y9rwGqYBZ4BNfSaQ9RHS9w8Nx2shlNAR+LW5GYWEFtYIFyi
	ad1fVhCbRUBVouczhM0rYClxfftfNghbUOLH5HssEDO1JNbvPM4EYctLbF7zlhniUAWJHWdf
	M0LcYCWxbOI6qBtEJPa9eMc4gVFoFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YW
	l+al6yXn525iBCeMZ1I7GFc2WBxiFOBgVOLhVWhpChRiTSwrrsw9xCjBwawkwuv2AyjEm5JY
	WZValB9fVJqTWnyIMRno04nMUqLJ+cBkllcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTE
	ktTs1NSC1CKYLUwcnFINjMcrFu+qVl1pX5DMKqTqontg+9l1EmdDJ4a7y754pcYpaeIpGZDp
	eObsIbGCe8/Uq/+Kal14/vSTvHH3dWOD5avqj5pXKwpX7fx4x8Wvj4tFZWP0uiqxP1EZBT9e
	bI7knFls7T0/yLT1b0RuuehDT1ulxM1P/3+etORlz/HpO+Ruemcdarj8V4mlOCPRUIu5qDgR
	ANl5s9tcAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 03, 2013 3:58 PM, Srinidhi Kasagar wrote:
> On Fri, May 03, 2013 at 08:24:24 +0200, Jingoo Han wrote:
> > The driver core clears the driver data to NULL after device_release
> > or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> > (device-core: Ensure drvdata = NULL when no driver is bound).
> > Thus, it is not needed to manually clear the device driver data to NULL.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/rtc/rtc-ab8500.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
> > index 63cfa31..c5b62d4 100644
> > --- a/drivers/rtc/rtc-ab8500.c
> > +++ b/drivers/rtc/rtc-ab8500.c
> > @@ -451,8 +451,6 @@ static int ab8500_rtc_remove(struct platform_device *pdev)
> >  {
> >  	ab8500_sysfs_rtc_unregister(&pdev->dev);
> >
> > -	platform_set_drvdata(pdev, NULL);
> > -
> >  	return 0;
> >  }
> Ok, thanks. Hope you have taken care for the ab3100 too...
> 
> Acked-by:srinidhi kasagar <srinidhi.kasagar@stericsson.com>

Hi Srinidhi Kasagar,

I have already modified the ab3100 RTC driver as below:
(http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg428126.html)

Thank you for your Acked-by. :)

Best regards,
Jingoo Han

> 
> regards/srinidhi

