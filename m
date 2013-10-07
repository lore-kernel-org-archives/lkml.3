Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab3JGRZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:25:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364Ab3JGRZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:25:03 -0400
Message-ID: <5252EE60.7030806@redhat.com>
Date: Mon, 07 Oct 2013 13:24:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/63] sched: numa: Continue PTE scanning even if migrate
 rate limited
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-15-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-15-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Avoiding marking PTEs pte_numa because a particular NUMA node is migrate rate
> limited sees like a bad idea. Even if this node can't migrate anymore other
> nodes might and we want up-to-date information to do balance decisions.
> We already rate limit the actual migrations, this should leave enough
> bandwidth to allow the non-migrating scanning. I think its important we
> keep up-to-date information if we're going to do placement based on it.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
