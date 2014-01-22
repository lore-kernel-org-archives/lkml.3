Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaAVFJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:09:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26900 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaAVFJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:09:47 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-14-52df529a4f4b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Liu Ying'" <Ying.Liu@freescale.com>
Cc: linux-fbdev@vger.kernel.org,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'DRI mailing list'" <dri-devel@lists.freedesktop.org>,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1390196846-15304-1-git-send-email-Ying.Liu@freescale.com>
 <CA+8Hj810rwNCaiF8vEp9QXGufLp3=AdgF60gcTNfkd7C7pawgw@mail.gmail.com>
 <52DF5125.3040909@freescale.com>
In-reply-to: <52DF5125.3040909@freescale.com>
Subject: Re: [PATCH v2] backlight: turn backlight on/off when necessary
Date: Wed, 22 Jan 2014 14:09:45 +0900
Message-id: <000501cf1730$2ac77ee0$80567ca0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8XLxde/kfv+ccARLG4JtP1aR7ERwAAIK2A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zQ91ZQfeDDJ5vE7S48vU9m8XlhZdY
	LU70fWC1uLxrDpvFuocvmCzWz7/FZvHkiYkDu8e/w/1MHq8u3GHxuN99nMmjb8sqRo/jN7Yz
	eXzeJBfAFsVlk5Kak1mWWqRvl8CVsfNfA2NBl07F0UmrWBoYj8h2MXJySAiYSDRM+sgKYYtJ
	XLi3nq2LkYtDSGAZo8SjPzNZYIp6V/1hgUhMZ5SYffI6M4Tzi1Gi/UQXE0gVm4CaxJcvh9lB
	bBEBdYljhxcxgRQxC9xilLi/oAeqfQOjxOpXG4AWcnBwCuhKPL6RDdIgLOAu0TjtEDOIzSKg
	KrH1xlM2EJtXwFZizvFbULagxI/J98BOYhbQkli/8zgThC0vsXnNW2aQkRJAix/91YW4wUji
	3Jq3UCUiEvtevGMEOUFC4Cu7xIMPh1ghdglIfJt8iAWiV1Zi0wFmiI8lJQ6uuMEygVFiFpLN
	s5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECInk3h2Mtw9YH2JMBlo/
	kVlKNDkfmAjySuINjc2MLExNTI2NzC3NSBNWEudNepgUJCSQnliSmp2aWpBaFF9UmpNafIiR
	iYNTqoFR12ib7L0bwt8rKncvXfFEJjEtvWdVTL7y0bgza2Y7vtB7e122LS901v9t/Jas+36w
	2RVanZjDkR6+jtdlmtXqr6Znj226Lun29HLzmfPBfRGLHk1sm8vJs+FE1OM3LnlTC4qdQmdq
	n9Xo7wj+03BqX7e04DOB8JTVwf2BX19IerHGL5/Hd26ZEktxRqKhFnNRcSIAlrcVk/oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jQd1ZQfeDDG5v57G48vU9m8XlhZdY
	LU70fWC1uLxrDpvFuocvmCzWz7/FZvHkiYkDu8e/w/1MHq8u3GHxuN99nMmjb8sqRo/jN7Yz
	eXzeJBfAFtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPnvwbGgi6diqOT
	VrE0MB6R7WLk5JAQMJHoXfWHBcIWk7hwbz1bFyMXh5DAdEaJ2SevM0M4vxgl2k90MYFUsQmo
	SXz5cpgdxBYRUJc4dngRE0gRs8AtRon7C3pYIDo2MEqsfrWBtYuRg4NTQFfi8Y1skAZhAXeJ
	xmmHmEFsFgFVia03nrKB2LwCthJzjt+CsgUlfky+B3YSs4CWxPqdx5kgbHmJzWveMoOMlABa
	/OivLsQNRhLn1ryFKhGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFec
	mFtcmpeul5yfu4kRnCaeSe9gXNVgcYhRgINRiYc3YNe9ICHWxLLiytxDjBIczEoivIeeAYV4
	UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5jC8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBMULdf55w8/uIC23lWcKVFlVXt2juKWxjZ569srDUdhF/xGZl
	l1ltiS7/t1ne1hQoD/CZfbjg6YyyKaHXbMtCOHdvabvSuPDsqTPOYiKNy55lvjzqsmCuocGH
	e52/fFh01hvZ7fm47p2CROG1/L3TF0UdM355aVeDVfmT6IXclxX/TWjbtm5urxJLcUaioRZz
	UXEiAAkeYFVXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 22, 2014 2:04 PM, Liu Ying wrote:
> 
> Ping...
> 
> Regards,
> Liu Ying

Please, don't send the ping within 2 days.
It is not a good practice. You sent the v1 patch 6 months ago.
However, why I should review the patch within 2 days?
Please wait.

Best regards,
Jingoo Han

> 
> On 01/20/2014 12:52 PM, Liu Ying wrote:
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
> > diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> > index 5d05555..42044be 100644
> > --- a/drivers/video/backlight/backlight.c
> > +++ b/drivers/video/backlight/backlight.c
> > @@ -34,13 +34,15 @@ static const char *const backlight_types[] = {
> >                            defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
> >  /* This callback gets called when something important happens inside a
> >   * framebuffer driver. We're looking if that important event is blanking,
> > - * and if it is, we're switching backlight power as well ...
> > + * and if it is and necessary, we're switching backlight power as well ...
> >   */
> >  static int fb_notifier_callback(struct notifier_block *self,
> >                                 unsigned long event, void *data)
> >  {
> >         struct backlight_device *bd;
> >         struct fb_event *evdata = data;
> > +       int node = evdata->info->node;
> > +       int fb_blank = 0;
> >
> >         /* If we aren't interested in this event, skip it immediately ... */
> >         if (event != FB_EVENT_BLANK && event != FB_EVENT_CONBLANK)
> > @@ -51,12 +53,24 @@ static int fb_notifier_callback(struct notifier_block *self,
> >         if (bd->ops)
> >                 if (!bd->ops->check_fb ||
> >                     bd->ops->check_fb(bd, evdata->info)) {
> > -                       bd->props.fb_blank = *(int *)evdata->data;
> > -                       if (bd->props.fb_blank == FB_BLANK_UNBLANK)
> > -                               bd->props.state &= ~BL_CORE_FBBLANK;
> > -                       else
> > -                               bd->props.state |= BL_CORE_FBBLANK;
> > -                       backlight_update_status(bd);
> > +                       fb_blank = *(int *)evdata->data;
> > +                       if (fb_blank == FB_BLANK_UNBLANK &&
> > +                           !bd->fb_bl_on[node]) {
> > +                               bd->fb_bl_on[node] = true;
> > +                               if (!bd->use_count++) {
> > +                                       bd->props.state &= ~BL_CORE_FBBLANK;
> > +                                       bd->props.fb_blank = FB_BLANK_UNBLANK;
> > +                                       backlight_update_status(bd);
> > +                               }
> > +                       } else if (fb_blank != FB_BLANK_UNBLANK &&
> > +                                  bd->fb_bl_on[node]) {
> > +                               bd->fb_bl_on[node] = false;
> > +                               if (!(--bd->use_count)) {
> > +                                       bd->props.state |= BL_CORE_FBBLANK;
> > +                                       bd->props.fb_blank = FB_BLANK_POWERDOWN;
> > +                                       backlight_update_status(bd);
> > +                               }
> > +                       }
> >                 }
> >         mutex_unlock(&bd->ops_lock);
> >         return 0;
> > diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> > index 5f9cd96..7264742 100644
> > --- a/include/linux/backlight.h
> > +++ b/include/linux/backlight.h
> > @@ -9,6 +9,7 @@
> >  #define _LINUX_BACKLIGHT_H
> >
> >  #include <linux/device.h>
> > +#include <linux/fb.h>
> >  #include <linux/mutex.h>
> >  #include <linux/notifier.h>
> >
> > @@ -104,6 +105,11 @@ struct backlight_device {
> >         struct list_head entry;
> >
> >         struct device dev;
> > +
> > +       /* Multiple framebuffers may share one backlight device */
> > +       bool fb_bl_on[FB_MAX];
> > +
> > +       int use_count;
> >  };
> >
> >  static inline void backlight_update_status(struct backlight_device *bd)
> > --
> > 1.7.9.5

