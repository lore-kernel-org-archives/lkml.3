Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaFKDiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:38:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:33019 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643AbaFKDiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:38:20 -0400
X-IronPort-AV: E=Sophos;i="5.00,686,1396972800"; 
   d="scan'208";a="31742996"
Message-ID: <5397CF36.1040103@cn.fujitsu.com>
Date: Wed, 11 Jun 2014 11:38:30 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 07/10] mm: rename allocflags_to_migratetype for clarity
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz> <1402305982-6928-7-git-send-email-vbabka@suse.cz> <20140611024109.GG15630@bbox>
In-Reply-To: <20140611024109.GG15630@bbox>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 10:41 AM, Minchan Kim wrote:
> On Mon, Jun 09, 2014 at 11:26:19AM +0200, Vlastimil Babka wrote:
>> From: David Rientjes <rientjes@google.com>
>>
>> The page allocator has gfp flags (like __GFP_WAIT) and alloc flags (like
>> ALLOC_CPUSET) that have separate semantics.
>>
>> The function allocflags_to_migratetype() actually takes gfp flags, not alloc
>> flags, and returns a migratetype.  Rename it to gfpflags_to_migratetype().
>>
>> Signed-off-by: David Rientjes <rientjes@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> I was one of person who got confused sometime.

Some names in MM really make people confused. But sometimes thinking
an appropriate name is also a hard thing. Like I once wanted to change
the name of function nr_free_zone_pages() and also nr_free_buffer_pages().
But it is hard to name them, so at last Andrew suggested to add the
detailed function description to make it clear only.

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> 
> Acked-by: Minchan Kim <minchan@kernel.org>
> 


-- 
Thanks.
Zhang Yanfei
