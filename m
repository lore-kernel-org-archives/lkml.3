Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbaKTQUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:20:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKTQUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:20:09 -0500
Date: Thu, 20 Nov 2014 08:20:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.14 102/122] mm + fs: prepare for non-page entries in
 page cache radix trees
Message-ID: <20141120162007.GA32617@kroah.com>
References: <20141119205208.812884198@linuxfoundation.org>
 <20141119205212.209198738@linuxfoundation.org>
 <20141120154937.GA325@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120154937.GA325@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:49:37AM -0500, Johannes Weiner wrote:
> On Wed, Nov 19, 2014 at 12:52:32PM -0800, Greg Kroah-Hartman wrote:
> > 3.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > commit 0cd6144aadd2afd19d1aca880153530c52957604 upstream.
> > 
> > shmem mappings already contain exceptional entries where swap slot
> > information is remembered.
> > 
> > To be able to store eviction information for regular page cache, prepare
> > every site dealing with the radix trees directly to handle entries other
> > than pages.
> 
> I don't see the rest of the thrash-detection patches in this series.
> Without anybody actually planting "entries other than pages" in the
> radix trees, why is this needed in -stable?

What specific patches are you referring to?  I still have 31 pending
patches that Mel has backported that I have not applied to the
3.14-stable kernel for his big series of performance improvements.  I've
been slowly feeding them into releases to catch any possible problems
earlier.

So perhaps they have yet to be applied?  Or they are later on in this
patch series (there are 20 more patches in this series after this
patch...)

thanks,

greg k-h
