Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab3K3AuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 19:50:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3K3AuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 19:50:06 -0500
Date: Fri, 29 Nov 2013 16:51:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, azurit@pobox.sk,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [merged]
 mm-memcg-handle-non-error-oom-situations-more-gracefully.patch removed from
 -mm tree
Message-ID: <20131130005100.GA8387@kroah.com>
References: <526028bd.k5qPj2+MDOK1o6ii%akpm@linux-foundation.org>
 <alpine.DEB.2.02.1311271453270.13682@chino.kir.corp.google.com>
 <20131127233353.GH3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271622330.10617@chino.kir.corp.google.com>
 <20131128021809.GI3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271826001.5120@chino.kir.corp.google.com>
 <20131128031313.GK3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271914460.5120@chino.kir.corp.google.com>
 <20131128035218.GM3556@cmpxchg.org>
 <alpine.DEB.2.02.1311291546370.22413@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311291546370.22413@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 04:00:09PM -0800, David Rientjes wrote:
> On Wed, 27 Nov 2013, Johannes Weiner wrote:
> 
> > > None that I am currently aware of, I'll continue to try them out.  I'd 
> > > suggest just dropping the stable@kernel.org from the whole series though 
> > > unless there is another report of such a problem that people are running 
> > > into.
> > 
> > The series has long been merged, how do we drop stable@kernel.org from
> > it?
> > 
> 
> You said you have informed stable to not merge these patches until further 
> notice, I'd suggest simply avoid ever merging the whole series into a 
> stable kernel since the problem isn't serious enough.  Marking changes 
> that do "goto nomem" seem fine to mark for stable, though.

I'm lost.  These patches are in 3.12, so how can they not be "in
stable"?

What exactly do you want me to do here?

totally confused,

greg k-h
