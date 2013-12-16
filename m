Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3LPURH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:17:07 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:50181 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab3LPURG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:17:06 -0500
Date: Mon, 16 Dec 2013 15:16:55 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] mm: page_alloc: Break out zone page aging
 distribution into its own helper
Message-ID: <20131216201655.GY21724@cmpxchg.org>
References: <1386943807-29601-1-git-send-email-mgorman@suse.de>
 <1386943807-29601-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386943807-29601-3-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 02:10:02PM +0000, Mel Gorman wrote:
> This patch moves the decision on whether to round-robin allocations between
> zones and nodes into its own helper functions. It'll make some later patches
> easier to understand and it will be automatically inlined.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
