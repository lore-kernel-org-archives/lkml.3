Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3JGODW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:03:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab3JGODM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:03:12 -0400
Message-ID: <5252BF13.7060103@redhat.com>
Date: Mon, 07 Oct 2013 10:02:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/63] mm: Account for a THP NUMA hinting update as one
 PTE update
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-10-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-10-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> A THP PMD update is accounted for as 512 pages updated in vmstat.  This is
> large difference when estimating the cost of automatic NUMA balancing and
> can be misleading when comparing results that had collapsed versus split
> THP. This patch addresses the accounting issue.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
