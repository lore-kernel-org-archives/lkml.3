Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3HBSMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:12:23 -0400
Received: from shelob.surriel.com ([74.92.59.67]:45109 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3HBSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:12:22 -0400
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2013 14:12:22 EDT
Message-ID: <51FBF1BA.9030801@surriel.com>
Date: Fri, 02 Aug 2013 13:51:54 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2 3/3] mm: page_alloc: fair zone allocator policy
References: <1375457846-21521-1-git-send-email-hannes@cmpxchg.org> <1375457846-21521-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1375457846-21521-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 11:37 AM, Johannes Weiner wrote:
> Each zone that holds userspace pages of one workload must be aged at a
> speed proportional to the zone size.  Otherwise, the time an
> individual page gets to stay in memory depends on the zone it happened
> to be allocated in.  Asymmetry in the zone aging creates rather
> unpredictable aging behavior and results in the wrong pages being
> reclaimed, activated etc.


> When zone_reclaim_mode is enabled, allocations will now spread out to
> all zones on the local node, not just the first preferred zone (which
> on a 4G node might be a tiny Normal zone).
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Tested-by: Zlatko Calusic <zcalusic@bitsync.net>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed.
