Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3HBT05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:26:57 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51615 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab3HBT04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:26:56 -0400
Date: Fri, 2 Aug 2013 15:26:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm, page_alloc: add likely macro to help compiler
 optimization
Message-ID: <20130802192650.GU715@cmpxchg.org>
References: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 11:07:56AM +0900, Joonsoo Kim wrote:
> We rarely allocate a page with ALLOC_NO_WATERMARKS and it is used
> in slow path. For making fast path more faster, add likely macro to
> help compiler optimization.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
