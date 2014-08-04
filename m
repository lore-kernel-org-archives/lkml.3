Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaHDPW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:22:57 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:58027 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaHDPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:22:54 -0400
Date: Mon, 4 Aug 2014 11:22:51 -0400
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Matt Mackall <mpm@selenic.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Jens Axboe <axboe@fb.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: kernel: smp: WARNING at kernel/smp.c:673
Message-ID: <20140804152251.GF26230@htj.dyndns.org>
References: <53DEF67E.8090004@oracle.com>
 <alpine.DEB.2.11.1408041000040.8248@gentwo.org>
 <20140804150356.GE26230@htj.dyndns.org>
 <alpine.DEB.2.11.1408041020590.9249@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408041020590.9249@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 10:21:47AM -0500, Christoph Lameter wrote:
> On Mon, 4 Aug 2014, Tejun Heo wrote:
> 
> > On Mon, Aug 04, 2014 at 10:00:39AM -0500, Christoph Lameter wrote:
> > > On Sun, 3 Aug 2014, Sasha Levin wrote:
> > >
> > > > While fuzzing with trinity inside a KVM tools guest running the latest -next
> > > > kernel, I've stumbled on the following spew:
> > >
> > > Hmmm... Is this the new cpuset code that calling kmem_cache_shrink from
> > > the cpu notifier?
> >
> > Hah?  I don't see anything cpuset related there.
> 
> Yuck. I meant cgroup code. There were some patches that were suggesting a
> shrink operation when taking down a cgroup. Does that also apply to per
> cpu downing?

Heh, I have no idea what you're talking about.  cgroup currently
doesn't do anything like that.  It doesn't even make use of the cpu
hotplug hooks.

Thanks.

-- 
tejun
