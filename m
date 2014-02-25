Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaBYSZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:25:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbaBYSZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:25:13 -0500
Message-ID: <530CDFE0.10800@redhat.com>
Date: Tue, 25 Feb 2014 13:24:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: per-thread vma caching
References: <1393352206.2577.36.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1393352206.2577.36.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 01:16 PM, Davidlohr Bueso wrote:

> The proposed approach is to keep the current cache and adding a small, per
> thread, LRU cache. By keeping the mm->mmap_cache, 

This bit of the changelog may want updating :)

> Changes from v1 (https://lkml.org/lkml/2014/2/21/8): 
> - Removed the per-mm cache for CONFIG_MMU, only having the 
>   per thread approach.

The patch looks good.

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
