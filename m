Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaBQBvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:51:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34352 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaBQBvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:51:31 -0500
X-AuditID: cbfee690-b7f266d00000287c-69-53016b201582
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'David Airlie'" <airlied@linux.ie>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1392376711-11290-1-git-send-email-tomi.valkeinen@ti.com>
 <1392376711-11290-2-git-send-email-tomi.valkeinen@ti.com>
In-reply-to: <1392376711-11290-2-git-send-email-tomi.valkeinen@ti.com>
Subject: Re: [PATCH RFC 2/3] fbdev: move fbdev core files to separate directory
Date: Mon, 17 Feb 2014 10:51:28 +0900
Message-id: <000d01cf2b82$c5f2cbc0$51d86340$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8pdqp5TO7Mz6yxSByYvoukkvmANACC36ZQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zQ12FbMZgg6ZXuha9504yWVz5+p7N
	4tmtvUwWlxdeYrXonLiE3eJE3wdWi8u75rBZrHv4gsli/fxbbA6cHrM7ZrJ6vLpwh8Xj0OEO
	Ro/t3x6wetzvPs7k0bdlFaPH8RvbmTw+b5IL4IjisklJzcksSy3St0vgyrhxbCFLwR/xin/v
	ZrM2MK4X7mLk5JAQMJF4euUOO4QtJnHh3nq2LkYuDiGBZYwSFy8fYYIretLMApFYxCjx8GUb
	K4TzC6jq5B+wdjYBNYkvXw6zgyREBLoYJX5+/AjmMAvMZ5K4v24r1OBGRon1Sx+wgbRwCrhJ
	tF78BNYuLOAv0de4AmghBweLgKrE5s2VIGFeAVuJ1Zd2MUPYghI/Jt9jAbGZBbQk1u88zgRh
	y0tsXvOWGaRVQkBd4tFfXZCwiICRxPRJd6BKRCT2vXjHCHKChMBMDolPvyB+YxEQkPg2+RAL
	RK+sxKYDzBAvS0ocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSiV5yYW1ya
	l66XnJ+7iRES9RN2MN47YH2IMRlo/URmKdHkfGDSyCuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1R
	UpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxjU5M1faHlp45OfjtYvXffnpXLzj4QXDDw2s
	fzczm+78En+G7fG8Mo06o+v912at+cNdfNqzabnchqufT1r9jA/1WZ3//oGgb3razhjbFwfe
	STRMnHxylu6eGM9Cxg2/pT99+3HDU0d49p1Kdc/veRZdRge7HGZ3TNm+MPDG05kTpt/9L7Dm
	ZX6QEktxRqKhFnNRcSIAc3orahADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jAV2FbMZggxvNmha9504yWVz5+p7N
	4tmtvUwWlxdeYrXonLiE3eJE3wdWi8u75rBZrHv4gsli/fxbbA6cHrM7ZrJ6vLpwh8Xj0OEO
	Ro/t3x6wetzvPs7k0bdlFaPH8RvbmTw+b5IL4IhqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpQSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx49hCloI/4hX/3s1mbWBcL9zFyMkhIWAi8fRJMwuELSZx4d56ti5GLg4h
	gUWMEg9ftrFCOL8YJS6e/MMOUsUmoCbx5cthdpCEiEAXo8TPjx/BHGaB+UwS99dthepvZJRY
	v/QBG0gLp4CbROvFT2DtwgL+En2NK5i6GDk4WARUJTZvrgQJ8wrYSqy+tIsZwhaU+DH5HthN
	zAJaEut3HmeCsOUlNq95ywzSKiGgLvHory5IWETASGL6pDtQJSIS+168Y5zAKDQLyaRZSCbN
	QjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCU8oz6R2MqxosDjEKcDAq8fAm
	PP4fJMSaWFZcmXuIUYKDWUmE1z2OMViINyWxsiq1KD++qDQntfgQYzLQnxOZpUST84HpLq8k
	3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGEMmLVX1v8kskXun
	0rWUZVPya7auotZqtktvLJc+uqNwcs2m6V0+ekG7X3A93nbR1uVQ+jepf6wr2VTP77+x75+/
	Oguj1wOTQ+y7PF9paOp92Dp7wRabnuPN71bLLX024ci1/71qBpJBcrddzL50XvdeeyTlfLAJ
	o5LYHsttJi8m7P+lIrGqQ1uJpTgj0VCLuag4EQA+EkPhbQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 14, 2014 8:19 PM, Tomi Valkeinen wrote:
> 
> Instead of having fbdev framework core files at the root fbdev
> directory, mixed with random fbdev device drivers, move the fbdev core
> files to a separate core directory. This makes it much clearer which of
> the files are actually part of the fbdev framework, and which are part
> of device drivers.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

Hi Tomi,

This is what I wanted for a long time!
Thank you for your effort!

Last year, I noticed that the current FB directory and files
are not clear. It looks good!

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/fbdev/Makefile                 | 16 +---------------
>  drivers/video/fbdev/core/Makefile            | 16 ++++++++++++++++
>  drivers/video/fbdev/{ => core}/cfbcopyarea.c |  0
>  drivers/video/fbdev/{ => core}/cfbfillrect.c |  0
>  drivers/video/fbdev/{ => core}/cfbimgblt.c   |  0
>  drivers/video/fbdev/{ => core}/fb_ddc.c      |  2 +-
>  drivers/video/fbdev/{ => core}/fb_defio.c    |  0
>  drivers/video/fbdev/{ => core}/fb_draw.h     |  0
>  drivers/video/fbdev/{ => core}/fb_notify.c   |  0
>  drivers/video/fbdev/{ => core}/fb_sys_fops.c |  0
>  drivers/video/fbdev/{ => core}/fbcmap.c      |  0
>  drivers/video/fbdev/{ => core}/fbcvt.c       |  0
>  drivers/video/fbdev/{ => core}/fbmem.c       |  0
>  drivers/video/fbdev/{ => core}/fbmon.c       |  2 +-
>  drivers/video/fbdev/{ => core}/fbsysfs.c     |  0
>  drivers/video/fbdev/{ => core}/modedb.c      |  0
>  drivers/video/fbdev/{ => core}/svgalib.c     |  0
>  drivers/video/fbdev/{ => core}/syscopyarea.c |  0
>  drivers/video/fbdev/{ => core}/sysfillrect.c |  0
>  drivers/video/fbdev/{ => core}/sysimgblt.c   |  0
>  drivers/video/fbdev/wmt_ge_rops.c            |  2 +-
>  21 files changed, 20 insertions(+), 18 deletions(-)
>  create mode 100644 drivers/video/fbdev/core/Makefile
>  rename drivers/video/fbdev/{ => core}/cfbcopyarea.c (100%)
>  rename drivers/video/fbdev/{ => core}/cfbfillrect.c (100%)
>  rename drivers/video/fbdev/{ => core}/cfbimgblt.c (100%)
>  rename drivers/video/fbdev/{ => core}/fb_ddc.c (99%)
>  rename drivers/video/fbdev/{ => core}/fb_defio.c (100%)
>  rename drivers/video/fbdev/{ => core}/fb_draw.h (100%)
>  rename drivers/video/fbdev/{ => core}/fb_notify.c (100%)
>  rename drivers/video/fbdev/{ => core}/fb_sys_fops.c (100%)
>  rename drivers/video/fbdev/{ => core}/fbcmap.c (100%)
>  rename drivers/video/fbdev/{ => core}/fbcvt.c (100%)
>  rename drivers/video/fbdev/{ => core}/fbmem.c (100%)
>  rename drivers/video/fbdev/{ => core}/fbmon.c (99%)
>  rename drivers/video/fbdev/{ => core}/fbsysfs.c (100%)
>  rename drivers/video/fbdev/{ => core}/modedb.c (100%)
>  rename drivers/video/fbdev/{ => core}/svgalib.c (100%)
>  rename drivers/video/fbdev/{ => core}/syscopyarea.c (100%)
>  rename drivers/video/fbdev/{ => core}/sysfillrect.c (100%)
>  rename drivers/video/fbdev/{ => core}/sysimgblt.c (100%)

