Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaAXCZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:25:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:65039 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaAXCZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:25:48 -0500
X-AuditID: cbfee68e-b7f566d000002344-9f-52e1cf211e5e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Liu Ying'" <Ying.Liu@freescale.com>
Cc: "'Jani Nikula'" <jani.nikula@linux.intel.com>, linux-fbdev@vger.kernel.org,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1390196846-15304-1-git-send-email-Ying.Liu@freescale.com>
 <87sisg5pfo.fsf@intel.com> <000101cf17fe$20ac79a0$62056ce0$%han@samsung.com>
 <52E0E093.1070803@freescale.com>
In-reply-to: <52E0E093.1070803@freescale.com>
Subject: Re: [PATCH v2] backlight: turn backlight on/off when necessary
Date: Fri, 24 Jan 2014 11:25:36 +0900
Message-id: <001501cf18ab$910d35b0$b327a110$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8YHTIPZbPje0PxSviQL0C4Zu4eAwAjUmfQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zI13F8w+DDBZN5rS48vU9m8Xyy+sZ
	LS4vvMRqcaLvA6vF5V1z2CzWPXzBZLF+/i02iydPTBw4PP4d7mfyeHXhDovHvJOBHve7jzN5
	9G1Zxehx/MZ2Jo/Pm+QC2KO4bFJSczLLUov07RK4Mj4cPsdacFauYsKPyUwNjGskuhg5OSQE
	TCSeTP/NAmGLSVy4t56ti5GLQ0hgGaPEyjvtTDBFvevfMEEkFjFKtG3Yyg7h/GKUuDjtGStI
	FZuAmsSXL4fZQWwRAXWJY4cXgXUwCzxklPi9bS8jSEJIYAejxK8PRiA2p4CuxNO1T8BWCAu4
	SzROO8QMYrMIqErsb3nFBmLzCthKfGibywxhC0r8mHwP7FZmAS2JzduaWCFseYnNa94C1XAA
	naou8eivLsQNRhIXTl1ihCgRkdj34h0jxDedHBINS1MgVglIfJt8iAWiVVZi0wFmiBJJiYMr
	brBMYJSYhWTxLCSLZyFZPAvJhgWMLKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQiK7bwfj
	zQPWhxiTgdZPZJYSTc4HJoa8knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cCYk3Eqqe1x56Z7AZszM7Pddj5nDvzTnfIhgn+7O8vN3zrJkft2nZr/
	82jDtWr/6EutezrXlbBEWvpp6c6ufnt3unia35zqqUyBZTcaTvOJHMhdGPeEV9xDPXXvsiMV
	nAyqNi3rVxvM0y+/XfBVYULzomSBhmvu59P57rzc5MvUsPi78XsxjjQlluKMREMt5qLiRACG
	epoxAgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jAV3F8w+DDOYvYrG48vU9m8Xyy+sZ
	LS4vvMRqcaLvA6vF5V1z2CzWPXzBZLF+/i02iydPTBw4PP4d7mfyeHXhDovHvJOBHve7jzN5
	9G1Zxehx/MZ2Jo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
	EnNTbZVcfAJ03TJzgI5SUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZ8
	OHyOteCsXMWEH5OZGhjXSHQxcnJICJhI9K5/wwRhi0lcuLeerYuRi0NIYBGjRNuGrewQzi9G
	iYvTnrGCVLEJqEl8+XKYHcQWEVCXOHZ4ERNIEbPAQ0aJ39v2MoIkhAR2MEr8+mAEYnMK6Eo8
	XfsEbIWwgLtE47RDzCA2i4CqxP6WV2wgNq+ArcSHtrnMELagxI/J91hAbGYBLYnN25pYIWx5
	ic1r3gLVcACdqi7x6K8uxA1GEhdOXWKEKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUo
	mlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnDieSe1gXNlgcYhRgINRiYd3RuDDICHWxLLiytxD
	jBIczEoivAkzgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xqeSXxhsYmZkaWRmYWRibm
	5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAeHjLmakv7p44wfuRad8tBYaHLHb/Nib9
	in/8ONB86okN+RPj3x3i6w2tnWo65XSA4/YFEzTfOPfZaF2Q4V3XJ9TF2JdSdDGgsJBX8vyU
	7MNVi+WK+V8+uCHIuvjWvxClpn/TguWr656yNB7Zdkhkxyyx7/lTl4RZzROvk7t5yfa6+JzT
	v7+FOCuxFGckGmoxFxUnAgC3n/eXYAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 23, 2014 6:28 PM, Liu Ying wrote:
> On 01/23/2014 01:44 PM, Jingoo Han wrote:
> > On Wednesday, January 22, 2014 6:36 PM, Jani Nikula wrote:
> >> On Mon, 20 Jan 2014, Liu Ying <Ying.Liu@freescale.com> wrote:
> >>> We don't have to turn backlight on/off everytime a blanking
> >>> or unblanking event comes because the backlight status may
> >>> have already been what we want. Another thought is that one
> >>> backlight device may be shared by multiple framebuffers. We
> >>> don't hope blanking one of the framebuffers may turn the
> >>> backlight off for all the other framebuffers, since they are
> >>> likely being active to display something. This patch adds
> >>> some logics to record each framebuffer's backlight usage to
> >>> determine the backlight device use count and whether the
> >>> backlight should be turned on or off. To be more specific,
> >>> only one unblank operation on a certain blanked framebuffer
> >>> may increase the backlight device's use count by one, while
> >>> one blank operation on a certain unblanked framebuffer may
> >>> decrease the use count by one, because the userspace is
> >>> likely to unblank a unblanked framebuffer or blank a blanked
> >>> framebuffer.
> >>>
> >>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> >>> ---
> >>> v1 can be found at https://lkml.org/lkml/2013/5/30/139
> >>>
> >>> v1->v2:
> >>> * Make the commit message be more specific about the condition
> >>>   in which backlight device use count can be increased/decreased.
> >>> * Correct the setting for bd->props.fb_blank.
> >>>
> >>>  drivers/video/backlight/backlight.c |   28 +++++++++++++++++++++-------
> >>>  include/linux/backlight.h           |    6 ++++++
> >>>  2 files changed, 27 insertions(+), 7 deletions(-)
> >>>
> >
> > [.....]
> >>
> >> Anything backlight worries me a little, and there are actually three
> >> changes bundled into one patch here:
> >>
> >> 1. Changing bd->props.state and bd->props.fb_blank only when use_count
> >>    changes from 0->1 or 1->0.
> >>
> >> 2. Calling backlight_update_status() only with the above change, and not
> >>    on all notifier callbacks.
> >>
> >> 3. Setting bd->props.fb_blank always to either FB_BLANK_UNBLANK or
> >>    FB_BLANK_POWERDOWN instead of *(int *)evdata->data.
> 
> Since I have already post v3(https://lkml.org/lkml/2014/1/22/126)
> to change the setting for bd->props.fb_blank, the idea of the 3rd point
> is not very appropriate any more.

OK, I see.

> 
> >>
> >> The rationale in the commit message seems plausible, and AFAICT the code
> >> does what it says on the box, so for that (and for that alone) you can
> >> have my
> >>
> >> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> >>
> >> *BUT* it would be laborous to figure out whether this change in
> >> behaviour might regress some drivers. I'm just punting on that. And that
> >> brings us back to the three changes above - in a bisect POV it might be
> >> helpful to split the patch up. Up to the maintainers.
> >
> > I agree with Jani Nikula's opinion.
> > Please split this patch into three patches as above mentioned.
> >
> 
> I am open to split the patch up.
> However, IMHO, this patch is somewhat self-contained.
> For example, if we try to create 2 patches for the 1st point and
>  the 2nd point Jani mentioned, one patch would invent the use_count
>  and call backlight_update_status() on all notifier callbacks(just
> ignore the use_count).
> Do you think this is a good patch?

The calling backlight_update_status() regardless the use_count
Will make the critical side effect? I don't think so.
Also, these two patches will be merged at the same time.
Please, split the patch into two patches. It would be clearer.

One more thing, please keep the indent using "Enter", when
sending your reply mail.

Best regards,
Jingoo Han

