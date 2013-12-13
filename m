Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3LMSJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:09:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49784 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3LMSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:09:51 -0500
Date: Fri, 13 Dec 2013 19:09:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 1/4] sched/numa: drop
 sysctl_numa_balancing_settle_count sysctl
Message-ID: <20131213180933.GS21999@twins.programming.kicks-ass.net>
References: <1386833006-6600-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386833006-6600-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 03:23:23PM +0800, Wanpeng Li wrote:
> Changelog:
>  v7 -> v8:
>   * remove references to it in Documentation/sysctl/kernel.txt 

Please do not put such bits in the changelog proper, but put them below
the --- line, that way they disappear automagically.

Applied all 4, thanks!
