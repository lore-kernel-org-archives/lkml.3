Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaDTGZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 02:25:59 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:45652 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaDTGYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 02:24:53 -0400
Date: Sun, 20 Apr 2014 08:24:50 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [git pull] drm fixes
Message-ID: <20140420062450.GA281@x4>
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>
 <20140419190305.GA267@x4>
 <CADnq5_M9COdOJhOu4_9yRpDoFt3bcc9HVqrvQqnYM3YuTLv15A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_M9COdOJhOu4_9yRpDoFt3bcc9HVqrvQqnYM3YuTLv15A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.04.19 at 21:21 -0400, Alex Deucher wrote:
> On Sat, Apr 19, 2014 at 3:03 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2014.04.19 at 08:19 +0100, Dave Airlie wrote:
> >>
> >> Unfortunately this contains no easter eggs, its a bit larger than I'd
> >> like, but I included a patch that just moves code from one file to another
> >> and I'd like to avoid merge conflicts with that later, so it makes it seem
> >> worse than it is,
> >
> >> Christian König (2):
> >>       drm/radeon: apply more strict limits for PLL params v2
> >>       drm/radeon: improve PLL params if we don't match exactly v2
> >
> > commit f8a2645ecede4eaf90b3d785f2805c8ecb76d43e
> > Author: Christian König <christian.koenig@amd.com>
> > Date:   Wed Apr 16 11:54:21 2014 +0200
> >
> >     drm/radeon: improve PLL params if we don't match exactly v2
> >
> > The commit above causes my monitor to just stay blank after boot.
> > No framebuffer, no Xorg, no nothing. I'm using a Radeon RS780.
> 
> Can you try the patch on:
> https://bugs.freedesktop.org/show_bug.cgi?id=77673

I did and it doesn't fix the issue.

-- 
Markus
