Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbaKTUjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:39:39 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:59511 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884AbaKTUji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:39:38 -0500
Date: Thu, 20 Nov 2014 15:39:24 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>,
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
Message-ID: <20141120203924.GA2611@phnom.home.cmpxchg.org>
References: <20141119205208.812884198@linuxfoundation.org>
 <20141119205212.209198738@linuxfoundation.org>
 <20141120154937.GA325@phnom.home.cmpxchg.org>
 <20141120162122.GS2725@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120162122.GS2725@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:21:22PM +0000, Mel Gorman wrote:
> On Thu, Nov 20, 2014 at 10:49:37AM -0500, Johannes Weiner wrote:
> > I don't see the rest of the thrash-detection patches in this series.
> > Without anybody actually planting "entries other than pages" in the
> > radix trees, why is this needed in -stable?
> 
> Patches later on in the stable series depended upon the code structure
> introduced by this patch even though the thrash-detection stuff was not
> backported. It could have been backported without it but then the
> patches would look much different from their mainline equivalent.

That makes sense.  Thanks!
