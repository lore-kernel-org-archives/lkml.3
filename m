Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab3LKKY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:24:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51379 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LKKYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:24:23 -0500
Date: Wed, 11 Dec 2013 11:24:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 0/6] mm: sched: numa: several fixups
Message-ID: <20131211102408.GI13532@twins.programming.kicks-ass.net>
References: <1386756961-3887-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386756961-3887-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 06:15:55PM +0800, Wanpeng Li wrote:
> Hi Andrew,

You'll find kernel/sched/ has a maintainer !Andrew.

>  include/linux/sched/sysctl.h |    1 -
>  kernel/sched/debug.c         |    2 +-
>  kernel/sched/fair.c          |   17 ++++-------------
>  kernel/sysctl.c              |    7 -------
>  mm/migrate.c                 |    4 ----
>  5 files changed, 5 insertions(+), 26 deletions(-)
