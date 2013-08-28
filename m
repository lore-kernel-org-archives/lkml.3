Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3H1UfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:35:25 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:62778 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3H1UfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130828203023.GA22866@redhat.com>
References: <20130618013602.GC2200@redhat.com>
	<1257782958.19234314.1371520167209.JavaMail.root@redhat.com>
	<20130730005335.GA6836@redhat.com>
	<20130805074033.GX22035@phenom.ffwll.local>
	<20130828203023.GA22866@redhat.com>
Date: Thu, 29 Aug 2013 06:35:22 +1000
Message-ID: <CAPM=9twByvO7Ok6TaPa0g3ptHoC_19QU37_jBk1BRQsipOFJ=A@mail.gmail.com>
Subject: Re: [3.10rc6] /proc/dri/0/vma broken on nouveau.
From: Dave Airlie <airlied@gmail.com>
To: Dave Jones <davej@redhat.com>, David Airlie <airlied@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 6:30 AM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Aug 05, 2013 at 09:40:33AM +0200, Daniel Vetter wrote:
>  > On Mon, Jul 29, 2013 at 08:53:35PM -0400, Dave Jones wrote:
>  > > On Mon, Jun 17, 2013 at 09:49:27PM -0400, David Airlie wrote:
>  > >  >
>  > >  > > Reading /proc/dri/0/vma causes bad things to happen on a box with nouveau
>  > >  > > loaded.
>  > >  > > (Note, no X running on that box)
>  > >  > >
>  > >  > > Trace below shows trinity, but I can reproduce it with just cat
>  > >  > > /proc/dri/0/vma
>  > >  >
>  > >  > How about this, lets just rip it all out.
>  > >
>  > > No-one objected, and this is still around in 3.11-rc3 in the same
>  > > easily oopsable state.. I vote we kill it with fire.
>  >
>  > Can we make it burn brighter while at it?
>  >
>  > http://cgit.freedesktop.org/~danvet/drm/commit/?h=for-dvdhrm&id=151591c2828e18fde1eb8447874704f3422168b0
>
> This went kinda quiet, what's the plan here ?

We nuked it from orbit in drm-next.

Dave.
