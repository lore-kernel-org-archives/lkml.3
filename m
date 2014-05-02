Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaEBNsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:48:09 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60157 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbaEBNsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:48:08 -0400
Date: Fri, 2 May 2014 09:48:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/6] lib: Update the kmemleak stack trace for radix tree
 allocations
Message-ID: <20140502134804.GL23420@cmpxchg.org>
References: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
 <1399038070-1540-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399038070-1540-4-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 02:41:07PM +0100, Catalin Marinas wrote:
> Since radix_tree_preload() stack trace is not always useful for
> debugging an actual radix tree memory leak, this patch updates the
> kmemleak allocation stack trace in the radix_tree_node_alloc() function.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks Catalin!
