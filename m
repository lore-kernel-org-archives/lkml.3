Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3EOHM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:12:27 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46181 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3EOHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:12:26 -0400
X-AuditID: 9c930197-b7b76ae000003523-5a-51933556ed7e
Date: Wed, 15 May 2013 16:12:20 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC 4/4] mm: free reclaimed pages instantly without depending
 next reclaim
Message-ID: <20130515071220.GA19110@blaptop>
References: <1368411048-3753-1-git-send-email-minchan@kernel.org>
 <1368411048-3753-5-git-send-email-minchan@kernel.org>
 <51927531.8010507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51927531.8010507@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rik,

On Tue, May 14, 2013 at 01:32:33PM -0400, Rik van Riel wrote:
> On 05/12/2013 10:10 PM, Minchan Kim wrote:
> >Normally, file I/O for reclaiming is asynchronous so that
> >when page writeback is completed, reclaimed page will be
> >rotated into LRU tail for fast reclaiming in next turn.
> >But it makes unnecessary CPU overhead and more iteration with higher
> >priority of reclaim could reclaim too many pages than needed
> >pages.
> >
> >This patch frees reclaimed pages by paging out instantly without
> >rotating back them into LRU's tail when the I/O is completed so
> >that we can get out of reclaim loop as soon as poosbile and avoid
> >unnecessary CPU overhead for moving them.
> >
> >Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> I like this approach and am looking forward to your v2 series,
> with the reworked patch 3/4.

I will do it after I finish more urgent works. :)
I am looking forward to seeing your review, then.

Thanks for the interest.

-- 
Kind regards,
Minchan Kim
