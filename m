Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab3JGTUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:20:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274Ab3JGTUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:20:20 -0400
Message-ID: <52530013.2000300@redhat.com>
Date: Mon, 07 Oct 2013 14:40:19 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 23/63] sched: Resist moving tasks towards nodes with fewer
 hinting faults
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-24-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-24-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> Just as "sched: Favour moving tasks towards the preferred node" favours
> moving tasks towards nodes with a higher number of recorded NUMA hinting
> faults, this patch resists moving tasks towards nodes with lower faults.
> 
> [mgorman@suse.de: changelog]
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
