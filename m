Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3H1Uae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:30:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab3H1Uad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:30:33 -0400
Date: Wed, 28 Aug 2013 16:30:23 -0400
From: Dave Jones <davej@redhat.com>
To: David Airlie <airlied@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.10rc6] /proc/dri/0/vma broken on nouveau.
Message-ID: <20130828203023.GA22866@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Airlie <airlied@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, bskeggs@redhat.com,
	dri-devel@lists.freedesktop.org
References: <20130618013602.GC2200@redhat.com>
 <1257782958.19234314.1371520167209.JavaMail.root@redhat.com>
 <20130730005335.GA6836@redhat.com>
 <20130805074033.GX22035@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805074033.GX22035@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 09:40:33AM +0200, Daniel Vetter wrote:
 > On Mon, Jul 29, 2013 at 08:53:35PM -0400, Dave Jones wrote:
 > > On Mon, Jun 17, 2013 at 09:49:27PM -0400, David Airlie wrote:
 > >  > 
 > >  > > Reading /proc/dri/0/vma causes bad things to happen on a box with nouveau
 > >  > > loaded.
 > >  > > (Note, no X running on that box)
 > >  > > 
 > >  > > Trace below shows trinity, but I can reproduce it with just cat
 > >  > > /proc/dri/0/vma
 > >  > 
 > >  > How about this, lets just rip it all out.
 > > 
 > > No-one objected, and this is still around in 3.11-rc3 in the same
 > > easily oopsable state.. I vote we kill it with fire.
 > 
 > Can we make it burn brighter while at it?
 > 
 > http://cgit.freedesktop.org/~danvet/drm/commit/?h=for-dvdhrm&id=151591c2828e18fde1eb8447874704f3422168b0

This went kinda quiet, what's the plan here ?

	Dave

