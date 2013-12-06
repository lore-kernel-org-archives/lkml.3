Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3LFQ50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:57:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab3LFQ5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:57:25 -0500
Date: Fri, 6 Dec 2013 16:57:21 +0000
From: Mel Gorman <mgorman@suse.de>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/6] sched/numa: use wrapper function task_node to get
 node which task is on
Message-ID: <20131206165721.GT11295@suse.de>
References: <1386321136-27538-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386321136-27538-4-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1386321136-27538-4-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 05:12:14PM +0800, Wanpeng Li wrote:
> Use wrapper function task_node to get node which task is on.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
