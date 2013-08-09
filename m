Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030635Ab3HISq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:46:29 -0400
Received: from shelob.surriel.com ([74.92.59.67]:50240 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968272Ab3HISq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:46:28 -0400
Message-ID: <520538D3.9000705@surriel.com>
Date: Fri, 09 Aug 2013 14:45:39 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2 3/3] mm: page_alloc: fair zone allocator policy
References: <1375457846-21521-1-git-send-email-hannes@cmpxchg.org> <1375457846-21521-4-git-send-email-hannes@cmpxchg.org> <20130807145828.GQ2296@suse.de> <20130807153743.GH715@cmpxchg.org> <20130808041623.GL1845@cmpxchg.org>
In-Reply-To: <20130808041623.GL1845@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 12:16 AM, Johannes Weiner wrote:

> Patch on top of mmotm:

Yes, please!

> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] mm: page_alloc: use vmstats for fair zone allocation batching
>
> Avoid dirtying the same cache line with every single page allocation
> by making the fair per-zone allocation batch a vmstat item, which will
> turn it into batched percpu counters on SMP.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
