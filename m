Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3H1Uj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab3H1Uj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:39:27 -0400
Date: Wed, 28 Aug 2013 16:39:18 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: David Airlie <airlied@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [3.10rc6] /proc/dri/0/vma broken on nouveau.
Message-ID: <20130828203918.GB22866@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Airlie <airlied@gmail.com>, David Airlie <airlied@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ben Skeggs <bskeggs@redhat.com>,
	dri-devel <dri-devel@lists.freedesktop.org>
References: <20130618013602.GC2200@redhat.com>
 <1257782958.19234314.1371520167209.JavaMail.root@redhat.com>
 <20130730005335.GA6836@redhat.com>
 <20130805074033.GX22035@phenom.ffwll.local>
 <20130828203023.GA22866@redhat.com>
 <CAPM=9twByvO7Ok6TaPa0g3ptHoC_19QU37_jBk1BRQsipOFJ=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9twByvO7Ok6TaPa0g3ptHoC_19QU37_jBk1BRQsipOFJ=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 06:35:22AM +1000, Dave Airlie wrote:
 > On Thu, Aug 29, 2013 at 6:30 AM, Dave Jones <davej@redhat.com> wrote:
 > > On Mon, Aug 05, 2013 at 09:40:33AM +0200, Daniel Vetter wrote:
 > >  > On Mon, Jul 29, 2013 at 08:53:35PM -0400, Dave Jones wrote:
 > >  > > On Mon, Jun 17, 2013 at 09:49:27PM -0400, David Airlie wrote:
 > >  > >  >
 > >  > >  > > Reading /proc/dri/0/vma causes bad things to happen on a box with nouveau
 > >  > >  > > loaded.
 > >  > >  > > (Note, no X running on that box)
 > >  > >  > >
 > >  > >  > > Trace below shows trinity, but I can reproduce it with just cat
 > >  > >  > > /proc/dri/0/vma
 > >  > >  >
 > >  > >  > How about this, lets just rip it all out.
 > >  > >
 > >  > > No-one objected, and this is still around in 3.11-rc3 in the same
 > >  > > easily oopsable state.. I vote we kill it with fire.
 > >  >
 > >  > Can we make it burn brighter while at it?
 > >  >
 > >  > http://cgit.freedesktop.org/~danvet/drm/commit/?h=for-dvdhrm&id=151591c2828e18fde1eb8447874704f3422168b0
 > >
 > > This went kinda quiet, what's the plan here ?
 > 
 > We nuked it from orbit in drm-next.

Awesome. Looks like that missed a Cc: -stable tag btw.

	Dave

