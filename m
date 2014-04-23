Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaDWWFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:05:01 -0400
Received: from mail001.aei.ca ([206.123.6.130]:40413 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaDWWE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:04:59 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [git pull] drm fixes
Date: Wed, 23 Apr 2014 18:04:50 -0400
Message-ID: <2963840.VTDy2Dfbed@grover>
Organization: me
User-Agent: KMail/4.13 (Linux/3.15.0-1-git; KDE/4.13.0; x86_64; ; )
In-Reply-To: <CAPM=9tyHwYJ4CTFPZD4zLNFQyct8A_UmoyUMgR_bBZR5bJB+Pw@mail.gmail.com>
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie> <CA+55aFwbOQCcd1qsW0rA+bQxN2Vgm9x832ZKmB7fndFX7DBE3w@mail.gmail.com> <CAPM=9tyHwYJ4CTFPZD4zLNFQyct8A_UmoyUMgR_bBZR5bJB+Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014 07:54:17 Dave Airlie wrote:
> On Wed, Apr 23, 2014 at 1:59 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Dave, mind sending me a pull request for drm fixes?
> >
> > There's now at least these two:
> >
> >  - "drm/radeon/aux: fix hpd assignment for aux bus"
> >  - "drm/radeon: use fixed PPL ref divider if needed"
> >
> > that look like fairly fatal regressions when they affect somebody.
> >
> > The fact that we already had *two* independent bugs be reported within
> > days of that last out-of-merge-window pull request makes me very
> > unhappy with the state of drm pulls.
> >
> > So please make sure that future fixes really are *fixes*. For
> > regressions only. No more games like this.
> 
> The pll fallout is fixes for the initial feature that was in the merge window,
> Tuning plls for monitors is always a pain in the ass, the previous algorithm
> took a couple of kernels a few years back to get where it was, unfortunately
> HDMI came along and showed up a bunch of its shortcomings. I'm happy
> Alex and Christian are on top of things in terms of tracking regressions
> and making sure they get fixed,
> 
> the AUX fix yes I'm a bit pissed off about myself, but I missed a pull
> from a few
> weeks ago, felt guilty, and maybe should have chosen the other path and let it
> wait a merge,
> 
> Christian just sent me a -fixes pull with all of these in it and I'll
> send it on to you
> in a few mins.

Hi

Given the fun I had with rc1 I decided to try this pull before rc2 and its working fine here.

Thanks!

Ed Tomlinson
