Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbaLJUTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:19:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60340 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbaLJUTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:19:38 -0500
Date: Wed, 10 Dec 2014 21:19:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rob Clark <robdclark@gmail.com>, rui wang <ruiv.wang@gmail.com>
Cc: "airlied@redhat.com" <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, tony.luck@intel.com,
        aris@redhat.com, rui.y.wang@intel.com,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm: fb helper should avoid sleeping in panic context
Message-ID: <20141210201934.GH17053@pd.tnic>
References: <1417702295-11001-1-git-send-email-ruiv.wang@gmail.com>
 <CANVTcTaSMCoc364qW=gOM9wq9-=nrVe7AaUcxu33vCSdh=ixKQ@mail.gmail.com>
 <CAF6AEGu2gmYUux9c0pfc+J1wbCc8555pn-WD4iKDtvmD52dvWg@mail.gmail.com>
 <CANVTcTZj7xntm5OcKpdKu5GopHrOXAQ6RUPF-4brnu7afYZu4g@mail.gmail.com>
 <CAF6AEGtCXV-6r=pRgQ5Q_=2xDPb+pqiDFkMrY6Y+WHhm2hvZ7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF6AEGtCXV-6r=pRgQ5Q_=2xDPb+pqiDFkMrY6Y+WHhm2hvZ7Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 08:05:21PM -0500, Rob Clark wrote:
> oh, whoops.. gmail hiding quoted text..
> 
> yeah, that looks sane,
> 
> Reviewed-by: Rob Clark <robdclark@gmail.com>
> 
> On Tue, Dec 9, 2014 at 7:55 PM, rui wang <ruiv.wang@gmail.com> wrote:
> > Hi Rob,
> > Yes it's exactly what I'm doing. Please scroll down and review my patch.
> >
> > Thanks
> > Rui
> >
> > On 12/10/14, Rob Clark <robdclark@gmail.com> wrote:
> >> perhaps fb helpers could use __drm_modeset_lock_all() w/ trylock=true
> >> in panic context?
> >>
> >> BR,
> >> -R
> >>
> >> On Tue, Dec 9, 2014 at 7:09 PM, rui wang <ruiv.wang@gmail.com> wrote:
> >>> Hi All,
> >>>
> >>> Any comment ? Or any better idea how this should be fixed?
> >>>
> >>> Regards,
> >>> Rui
> >>>

Dear gmail-ers,

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Please stop the top-posting or use a mail client which doesn't
facilitate the idiocy.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
