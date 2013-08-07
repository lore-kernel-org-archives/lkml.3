Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab3HGOU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:20:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565Ab3HGOUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:20:25 -0400
Date: Wed, 7 Aug 2013 15:20:21 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2 2/3] mm: page_alloc: rearrange watermark checking in
 get_page_from_freelist
Message-ID: <20130807142021.GP2296@suse.de>
References: <1375457846-21521-1-git-send-email-hannes@cmpxchg.org>
 <1375457846-21521-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1375457846-21521-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 11:37:25AM -0400, Johannes Weiner wrote:
> Allocations that do not have to respect the watermarks are rare
> high-priority events.  Reorder the code such that per-zone dirty
> limits and future checks important only to regular page allocations
> are ignored in these extraordinary situations.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
