Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaAWFoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:44:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53150 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaAWFoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:44:07 -0500
X-AuditID: cbfee68f-b7f156d00000276c-b2-52e0ac253ee8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Liu Ying'" <Ying.Liu@freescale.com>
Cc: "'Jani Nikula'" <jani.nikula@linux.intel.com>, linux-fbdev@vger.kernel.org,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1390196846-15304-1-git-send-email-Ying.Liu@freescale.com>
 <87sisg5pfo.fsf@intel.com>
In-reply-to: <87sisg5pfo.fsf@intel.com>
Subject: Re: [PATCH v2] backlight: turn backlight on/off when necessary
Date: Thu, 23 Jan 2014 14:44:05 +0900
Message-id: <000101cf17fe$20ac79a0$62056ce0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8XVOVggoTiojvgRpazGCv+ACet/wAqNhgA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zY13VNQ+CDM726lhc+fqezWL55fWM
	FpcXXmK1ONH3gdXi8q45bBbrHr5gslg//xabxZMnJg4cHv8O9zN5vLpwh8Vj3slAj/vdx5k8
	+rasYvQ4fmM7k8fnTXIB7FFcNimpOZllqUX6dglcGddabzMWHBOtOHVlE1sDY59gFyMnh4SA
	icTkpfPYIGwxiQv31gPZXBxCAssYJa62bWCCKfq9+w4jRGI6o8SehZuhnF+MEifn3AZrZxNQ
	k/jy5TA7iC0ioC5x7PAiJpAiZoGHjBK/t+0F6uAA6kiW+LTDH6SGE6jm1bVZjCC2sIC7ROO0
	Q8wgNouAqsSpnf/A5vAK2EqseX+JCcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMIOMlgGY+
	+qsLcYKRxLI9L5ghSkQk9r14B3azhEArh0TTwkPsELsEJL5NPsQC0SsrsekAM8TDkhIHV9xg
	mcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoREdv8OxrsH
	rA8xJgOtn8gsJZqcD0wMeSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBMcvhyo6l18/nb2BxPPLP7EzLXWXHmlcy2i9CmfZyPi+PT/NpSvxsPX/3
	xqIfYbcu9y47krX0EPN+t7J7/bs1Lp6+wn7J8ivPvNNRlUof+pY9iVicL3OsxOLypZPPQzdt
	02Q5lqbMsfaH3J5ZRv5vlRh9zRK5OA7539/7b3rRtNA9lnfuGea01CmxFGckGmoxFxUnAgD6
	WG5+AgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQV3VNQ+CDI7OUre48vU9m8Xyy+sZ
	LS4vvMRqcaLvA6vF5V1z2CzWPXzBZLF+/i02iydPTBw4PP4d7mfyeHXhDovHvJOBHve7jzN5
	9G1Zxehx/MZ2Jo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
	EnNTbZVcfAJ03TJzgI5SUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZc
	a73NWHBMtOLUlU1sDYx9gl2MnBwSAiYSv3ffYYSwxSQu3FvP1sXIxSEkMJ1RYs/CzYwQzi9G
	iZNzbrOBVLEJqEl8+XKYHcQWEVCXOHZ4ERNIEbPAQ0aJ39v2AnVwAHUkS3za4Q9SwwlU8+ra
	LLANwgLuEo3TDjGD2CwCqhKndv4Dm8MrYCux5v0lJghbUOLH5HssIDazgJbE+p3HmSBseYnN
	a94yg4yXAJr56K8uxAlGEsv2vGCGKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQ
	XFCclJ5rpFecmFtcmpeul5yfu4kRnDaeSe9gXNVgcYhRgINRiYc34cv9ICHWxLLiytxDjBIc
	zEoivC3THgQJ8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4wpeWVxBsam5gZWRqZWRiZmJuT
	Jqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2Oe6Vdnhr22M05b/Jiz70xJ3fzeosNCzF03
	V0rxrOGSSZgsNfVE50+lB+ZSk6O87he+7BGYHM21fuOqrdcl+OeEin4z+eAw57z8zjs8+6uZ
	xYIWRM1//4bpjOdM6emf/nrLyjdPU+leedtP6/LLuX1FLDIX0zaGzD+8YDGbMt+VV4/l9yxM
	bO1XYinOSDTUYi4qTgQA2kAV/V8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 22, 2014 6:36 PM, Jani Nikula wrote:
> On Mon, 20 Jan 2014, Liu Ying <Ying.Liu@freescale.com> wrote:
> > We don't have to turn backlight on/off everytime a blanking
> > or unblanking event comes because the backlight status may
> > have already been what we want. Another thought is that one
> > backlight device may be shared by multiple framebuffers. We
> > don't hope blanking one of the framebuffers may turn the
> > backlight off for all the other framebuffers, since they are
> > likely being active to display something. This patch adds
> > some logics to record each framebuffer's backlight usage to
> > determine the backlight device use count and whether the
> > backlight should be turned on or off. To be more specific,
> > only one unblank operation on a certain blanked framebuffer
> > may increase the backlight device's use count by one, while
> > one blank operation on a certain unblanked framebuffer may
> > decrease the use count by one, because the userspace is
> > likely to unblank a unblanked framebuffer or blank a blanked
> > framebuffer.
> >
> > Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> > ---
> > v1 can be found at https://lkml.org/lkml/2013/5/30/139
> >
> > v1->v2:
> > * Make the commit message be more specific about the condition
> >   in which backlight device use count can be increased/decreased.
> > * Correct the setting for bd->props.fb_blank.
> >
> >  drivers/video/backlight/backlight.c |   28 +++++++++++++++++++++-------
> >  include/linux/backlight.h           |    6 ++++++
> >  2 files changed, 27 insertions(+), 7 deletions(-)
> >

[.....]
> 
> Anything backlight worries me a little, and there are actually three
> changes bundled into one patch here:
> 
> 1. Changing bd->props.state and bd->props.fb_blank only when use_count
>    changes from 0->1 or 1->0.
> 
> 2. Calling backlight_update_status() only with the above change, and not
>    on all notifier callbacks.
> 
> 3. Setting bd->props.fb_blank always to either FB_BLANK_UNBLANK or
>    FB_BLANK_POWERDOWN instead of *(int *)evdata->data.
> 
> The rationale in the commit message seems plausible, and AFAICT the code
> does what it says on the box, so for that (and for that alone) you can
> have my
> 
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> 
> *BUT* it would be laborous to figure out whether this change in
> behaviour might regress some drivers. I'm just punting on that. And that
> brings us back to the three changes above - in a bisect POV it might be
> helpful to split the patch up. Up to the maintainers.

I agree with Jani Nikula's opinion.
Please split this patch into three patches as above mentioned.

Best regards,
Jingoo Han

