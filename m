Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaENJBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:01:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbaENJBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:01:16 -0400
Message-ID: <537330D6.7040802@suse.cz>
Date: Wed, 14 May 2014 11:01:10 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Yong-Taek Lee <ytk.lee@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rik van Riel <riel@redhat.com>, Michal Nazarewicz <mina86@mina86.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 2/2] mm/page_alloc: DEBUG_VM checks for free_list placement
 of CMA and RESERVE pages
References: <533D8015.1000106@suse.cz> <1396539618-31362-1-git-send-email-vbabka@suse.cz> <1396539618-31362-2-git-send-email-vbabka@suse.cz> <53616F39.2070001@oracle.com> <53638ADA.5040200@suse.cz> <5367A1E5.2020903@oracle.com> <5367B356.1030403@suse.cz> <5372E766.9040005@oracle.com> <alpine.LSU.2.11.1405132216560.4875@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1405132216560.4875@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 07:19 AM, Hugh Dickins wrote:
> On Tue, 13 May 2014, Sasha Levin wrote:
>> On 05/05/2014 11:50 AM, Vlastimil Babka wrote:
>>> So in the end this VM_DEBUG check probably cannot work anymore for MIGRATE_RESERVE, only for CMA. I'm not sure if it's worth keeping it only for CMA, what are the CMA guys' opinions on that?
>>
>> The way I understood it is that this patch is wrong, but it's still
>> alive in -mm. Should it still be there?
>
> I agree that it should be dropped.  I did not follow the discussion,
> but mmotm soon gives me BUG at mm/page_alloc.c:1242 under swapping load.

Yes, I have already asked for dropping, and updating message of PATCH 
1/2 at http://marc.info/?l=linux-mm&m=139947475413079&w=2

Vlastimil

> Hugh
>

