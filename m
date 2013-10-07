Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3JGS6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087Ab3JGS6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:58:34 -0400
Message-ID: <5253044C.9090000@redhat.com>
Date: Mon, 07 Oct 2013 14:58:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 33/63] sched: Retry migration of tasks to CPU on a preferred
 node
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-34-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-34-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> When a preferred node is selected for a tasks there is an attempt to migrate
> the task to a CPU there. This may fail in which case the task will only
> migrate if the active load balancer takes action. This may never happen if
> the conditions are not right. This patch will check at NUMA hinting fault
> time if another attempt should be made to migrate the task. It will only
> make an attempt once every five seconds.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
