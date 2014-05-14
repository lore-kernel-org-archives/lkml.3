Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaENFVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:21:17 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33115 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaENFVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:21:14 -0400
Date: Tue, 13 May 2014 22:19:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Yong-Taek Lee <ytk.lee@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 2/2] mm/page_alloc: DEBUG_VM checks for free_list placement
 of CMA and RESERVE pages
In-Reply-To: <5372E766.9040005@oracle.com>
Message-ID: <alpine.LSU.2.11.1405132216560.4875@eggly.anvils>
References: <533D8015.1000106@suse.cz> <1396539618-31362-1-git-send-email-vbabka@suse.cz> <1396539618-31362-2-git-send-email-vbabka@suse.cz> <53616F39.2070001@oracle.com> <53638ADA.5040200@suse.cz> <5367A1E5.2020903@oracle.com> <5367B356.1030403@suse.cz>
 <5372E766.9040005@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Sasha Levin wrote:
> On 05/05/2014 11:50 AM, Vlastimil Babka wrote:
> > So in the end this VM_DEBUG check probably cannot work anymore for MIGRATE_RESERVE, only for CMA. I'm not sure if it's worth keeping it only for CMA, what are the CMA guys' opinions on that?
> 
> The way I understood it is that this patch is wrong, but it's still
> alive in -mm. Should it still be there?

I agree that it should be dropped.  I did not follow the discussion,
but mmotm soon gives me BUG at mm/page_alloc.c:1242 under swapping load.

Hugh
