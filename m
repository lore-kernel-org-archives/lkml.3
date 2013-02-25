Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab3BYKfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:35:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759822Ab3BYKfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:35:37 -0500
Date: Mon, 25 Feb 2013 10:35:34 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Are there numa balancing topics scheduled for the incoming LSF?
Message-ID: <20130225103534.GC4365@suse.de>
References: <CAJd=RBBwwjiBcfCe5wMSS8Dzz1tF=EfGsGMggH+A174yTKa9PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBBwwjiBcfCe5wMSS8Dzz1tF=EfGsGMggH+A174yTKa9PA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 03:34:17PM +0800, Hillf Danton wrote:
> Hello all
> 
> On Mon, Dec 17, 2012 at 7:19 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Wed, Dec 12, 2012 at 2:03 AM, Mel Gorman <mgorman@suse.de> wrote:
> >> This is a pull request for "Automatic NUMA Balancing V11". The list
> >
> > Ok, guys, I've pulled this and pushed out. There were some conflicts
> > with both the VM changes and with the scheduler tree, but they were
> > pretty small and looked simple, so I fixed them up and hope they all
> > work.
> >
> > Anyway, hopefully we'll have a more real numa balancing for 3.9, and
> > this is still considered a reasonable base for that work.
> >
> And what is scheduled for 3.9?
> 

>From me, nothing. I spent most of this cycle handling bugs and was not
able to dedicate any time to NUMA balancing. I hope to go back to it at
some stage soon but there are some other issues that are a higher priority
for me right now unfortunately.

-- 
Mel Gorman
SUSE Labs
