Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbbAVBug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:50:36 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:34367 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbAVBu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:50:29 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 22 Jan 2015 10:51:23 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski.k@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmotm:
 mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch is
 causing preemptible splats
Message-ID: <20150122015123.GB21444@js1304-P5Q-DELUXE>
References: <20150121132308.GB23700@dhcp22.suse.cz>
 <CAJKOXPdgSsd8cr7ctKOGCwFTRMxcq71k7Pb5mQgYy--tGW8+_w@mail.gmail.com>
 <20150121141138.GC23700@dhcp22.suse.cz>
 <20150121142107.e26d5ebf3340aa91759fef1f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121142107.e26d5ebf3340aa91759fef1f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 02:21:07PM -0800, Andrew Morton wrote:
> On Wed, 21 Jan 2015 15:11:38 +0100 Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Wed 21-01-15 15:06:03, Krzysztof Koz__owski wrote:
> > [...]
> > > Same here :) [1] . So actually only ARM seems affected (both armv7 and
> > > armv8) because it is the only one which uses smp_processor_id() in
> > > my_cpu_offset.
> > 
> > This was on x86_64 with CONFIG_DEBUG_PREEMPT so it is not only ARM
> > specific.
> >  
> 
> Hopefully
> mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch
> will fix this.

Yes, it will fix this error.

> The most recent -mmotm was a bit of a trainwreck.  I'm scrambling to
> get the holes plugged so I can get another mmotm out today.

Another mmotm will fix many issues from me. :/

Thanks.

