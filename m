Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbbAVFsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:48:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbbAVFsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:48:25 -0500
Date: Wed, 21 Jan 2015 21:48:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Michal Hocko <mhocko@suse.cz>,
        Krzysztof =?UTF-8?Q?Koz=C5=82owski?= <k.kozlowski.k@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm:
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch is
 causing preemptible splats
Message-Id: <20150121214807.dcaa205b.akpm@linux-foundation.org>
In-Reply-To: <20150122161402.3330eabf@canb.auug.org.au>
References: <20150121132308.GB23700@dhcp22.suse.cz>
	<CAJKOXPdgSsd8cr7ctKOGCwFTRMxcq71k7Pb5mQgYy--tGW8+_w@mail.gmail.com>
	<20150121141138.GC23700@dhcp22.suse.cz>
	<20150121142107.e26d5ebf3340aa91759fef1f@linux-foundation.org>
	<20150122015123.GB21444@js1304-P5Q-DELUXE>
	<20150121193411.44f96b6c.akpm@linux-foundation.org>
	<20150122161402.3330eabf@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 16:14:02 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Wed, 21 Jan 2015 19:34:11 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Thu, 22 Jan 2015 10:51:23 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > 
> > > > The most recent -mmotm was a bit of a trainwreck.  I'm scrambling to
> > > > get the holes plugged so I can get another mmotm out today.
> > > 
> > > Another mmotm will fix many issues from me. :/
> > 
> > I hit a wont-boot-cant-find-init in linux-next so I get to spend
> > tomorrow bisecting that :(
> 
> There has been a long discussion about something like that already.
> Subject "Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to
> mount root fs"

ah, thanks.  You might have saved me a ton of effort there.

And oolookitat, a fix.  I love it when viro says "Oh, fuck".

