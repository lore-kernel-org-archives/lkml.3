Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaCUErz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 00:47:55 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:65297 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaCUEry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 00:47:54 -0400
Date: Thu, 20 Mar 2014 21:46:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
In-Reply-To: <532AF8E8.8030101@oracle.com>
Message-ID: <alpine.LSU.2.11.1403202141310.1006@eggly.anvils>
References: <20140311171045.GA4693@redhat.com> <20140311173603.GG32390@moon> <20140311173917.GB4693@redhat.com> <alpine.LSU.2.11.1403181703470.7055@eggly.anvils> <5328F3B4.1080208@oracle.com> <20140319020602.GA29787@redhat.com> <20140319021131.GA30018@redhat.com>
 <alpine.LSU.2.11.1403181918130.3423@eggly.anvils> <20140319145200.GA4608@redhat.com> <alpine.LSU.2.11.1403192147470.971@eggly.anvils> <20140320135137.GA2263@redhat.com> <532AF8E8.8030101@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014, Sasha Levin wrote:
> On 03/20/2014 09:51 AM, Dave Jones wrote:
> > On Wed, Mar 19, 2014 at 10:00:29PM -0700, Hugh Dickins wrote:
> > 
> >   > > This might be collateral damage from the swapops thing, I guess we
> > won't know until
> >   > > that gets fixed, but I thought I'd mention that we might still have a
> > problem here.
> >   >
> >   > Yes, those Bad rss-counters could well be collateral damage from the
> >   > swapops BUG.  To which I believe I now have the answer: again untested,
> >   > but please give this a try...
> > 
> > This survived an overnight run. No swapops bug, and no bad RSS. Good job:)
> 
> Same here, swapops bug is gone!

That was welcome news, thanks guys.  I notice it has not (yet) magically
appeared in Linus's public tree like the rss one did: so to be on the
safe side, I'll just repost it now, with your Reported-and-tested-bys,
otherwise unchanged.

Hugh
