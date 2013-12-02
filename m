Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab3LBVBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:01:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab3LBVBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:01:43 -0500
Message-ID: <529CF4ED.6040108@redhat.com>
Date: Mon, 02 Dec 2013 16:00:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] fs: cachefiles: use add_to_page_cache_lru()
References: <1386012108-21006-1-git-send-email-hannes@cmpxchg.org> <1386012108-21006-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1386012108-21006-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 02:21 PM, Johannes Weiner wrote:
> This code used to have its own lru cache pagevec up until a0b8cab3
> ("mm: remove lru parameter from __pagevec_lru_add and remove parts of
> pagevec API").  Now it's just add_to_page_cache() followed by
> lru_cache_add(), might as well use add_to_page_cache_lru() directly.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
