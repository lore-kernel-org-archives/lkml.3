Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3LHDDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 22:03:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab3LHDDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 22:03:20 -0500
Message-ID: <52A3E156.9090700@redhat.com>
Date: Sat, 07 Dec 2013 22:02:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/6] sched/numa: drop sysctl_numa_balancing_settle_count
 sysctl
References: <1386321136-27538-1-git-send-email-liwanp@linux.vnet.ibm.com> <1386321136-27538-3-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1386321136-27538-3-git-send-email-liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 04:12 AM, Wanpeng Li wrote:
> commit 887c290e (sched/numa: Decide whether to favour task or group weights 
> based on swap candidate relationships) drop the check against 
> sysctl_numa_balancing_settle_count, this patch remove the sysctl.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
