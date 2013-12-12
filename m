Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3LLGlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 01:41:55 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:52746 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3LLGlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 01:41:51 -0500
Date: Wed, 11 Dec 2013 22:41:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 1/4] sched/numa: drop sysctl_numa_balancing_settle_count
 sysctl
In-Reply-To: <1386807143-15994-2-git-send-email-liwanp@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1312112241080.11740@chino.kir.corp.google.com>
References: <1386807143-15994-1-git-send-email-liwanp@linux.vnet.ibm.com> <1386807143-15994-2-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013, Wanpeng Li wrote:

> commit 887c290e (sched/numa: Decide whether to favour task or group weights
> based on swap candidate relationships) drop the check against
> sysctl_numa_balancing_settle_count, this patch remove the sysctl.
> 

What about the references to it in Documentation/sysctl/kernel.txt?
