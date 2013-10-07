Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3JGTH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:07:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab3JGTHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:07:55 -0400
Message-ID: <5253067A.2040607@redhat.com>
Date: Mon, 07 Oct 2013 15:07:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 40/63] sched: numa: Favor placing a task on the preferred
 node
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-41-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-41-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> A tasks preferred node is selected based on the number of faults
> recorded for a node but the actual task_numa_migate() conducts a global
> search regardless of the preferred nid. This patch checks if the
> preferred nid has capacity and if so, searches for a CPU within that
> node. This avoids a global search when the preferred node is not
> overloaded.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
