Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaKCIRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:17:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:54686 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaKCIRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:17:44 -0500
Date: Mon, 3 Nov 2014 09:17:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, hughd@google.com, riel@redhat.com,
        mgorman@suse.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dbueso@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH v2 -next 00/10] mm: improve usage of the i_mmap lock
Message-ID: <20141103081739.GY23531@worktop.programming.kicks-ass.net>
References: <1414697657-1678-1-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414697657-1678-1-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:34:07PM -0700, Davidlohr Bueso wrote:
> 
> Davidlohr Bueso (10):
>   mm,fs: introduce helpers around the i_mmap_mutex
>   mm: use new helper functions around the i_mmap_mutex
>   mm: convert i_mmap_mutex to rwsem
>   mm/rmap: share the i_mmap_rwsem
>   uprobes: share the i_mmap_rwsem
>   mm/xip: share the i_mmap_rwsem
>   mm/memory-failure: share the i_mmap_rwsem
>   mm/mremap: share the i_mmap_rwsem
>   mm/nommu: share the i_mmap_rwsem
>   mm/hugetlb: share the i_mmap_rwsem
> 

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
