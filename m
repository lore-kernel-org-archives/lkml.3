Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaHDQAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:00:49 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:37143
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949AbaHDQAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:00:47 -0400
Date: Mon, 4 Aug 2014 11:00:44 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <htejun@gmail.com>
cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Matt Mackall <mpm@selenic.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Jens Axboe <axboe@fb.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: kernel: smp: WARNING at kernel/smp.c:673
In-Reply-To: <20140804152251.GF26230@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1408041100240.9968@gentwo.org>
References: <53DEF67E.8090004@oracle.com> <alpine.DEB.2.11.1408041000040.8248@gentwo.org> <20140804150356.GE26230@htj.dyndns.org> <alpine.DEB.2.11.1408041020590.9249@gentwo.org> <20140804152251.GF26230@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2014, Tejun Heo wrote:

> > Yuck. I meant cgroup code. There were some patches that were suggesting a
> > shrink operation when taking down a cgroup. Does that also apply to per
> > cpu downing?
>
> Heh, I have no idea what you're talking about.  cgroup currently
> doesn't do anything like that.  It doesn't even make use of the cpu
> hotplug hooks.

Something is running a kmem_cache_shrink from cpu down hooks. Thats weird.

