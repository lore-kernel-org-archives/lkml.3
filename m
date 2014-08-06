Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaHFHSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 03:18:11 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44969 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaHFHSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 03:18:10 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 6 Aug 2014 16:25:29 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        Peter Zijlstra <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] fix freepage count problems in memory isolation
Message-ID: <20140806072529.GA3371@js1304-P5Q-DELUXE>
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 04:18:26PM +0900, Joonsoo Kim wrote:
> Joonsoo Kim (8):
>   mm/page_alloc: correct to clear guard attribute in DEBUG_PAGEALLOC
>   mm/isolation: remove unstable check for isolated page
>   mm/page_alloc: fix pcp high, batch management
>   mm/isolation: close the two race problems related to pageblock
>     isolation
>   mm/isolation: change pageblock isolation logic to fix freepage
>     counting bugs
>   mm/isolation: factor out pre/post logic on
>     set/unset_migratetype_isolate()
>   mm/isolation: fix freepage counting bug on
>     start/undo_isolat_page_range()
>   mm/isolation: remove useless race handling related to pageblock
>     isolation
> 
>  include/linux/page-isolation.h |    2 +
>  mm/internal.h                  |    5 +
>  mm/page_alloc.c                |  223 +++++++++++++++++-------------
>  mm/page_isolation.c            |  292 +++++++++++++++++++++++++++++++---------
>  4 files changed, 368 insertions(+), 154 deletions(-)
> 

Sorry, Peter and Vlastimil.

I missed you two on CC due to typo, so manually add on CC of
cover-letter. I will do better next time. :)

Thanks.
