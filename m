Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaIQSbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:31:04 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:40868 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656AbaIQSbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:31:03 -0400
Date: Wed, 17 Sep 2014 14:30:49 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linuxfoundation.org>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: Make paranoid check in move_freepages a
 VM_BUG_ON
Message-ID: <20140917183049.GB32607@cmpxchg.org>
References: <20140909145228.GB12309@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909145228.GB12309@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 03:52:28PM +0100, Mel Gorman wrote:
> Since 2.6.24 there has been a paranoid check in move_freepages that looks
> up the zone of two pages. This is a very slow path and the only time I've
> seen this bug trigger recently is when memory initialisation was broken
> during patch development. Despite the fact it's a slow path, this patch
> converts the check to a VM_BUG_ON anyway as it is served its purpose by now.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
