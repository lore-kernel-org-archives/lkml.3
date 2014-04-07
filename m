Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbaDGXhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:37:06 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58479 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbaDGXhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:37:04 -0400
Date: Mon, 7 Apr 2014 19:36:57 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: page_alloc: Do not cache reclaim distances
Message-ID: <20140407233657.GP4407@cmpxchg.org>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
 <1396910068-11637-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396910068-11637-3-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 11:34:28PM +0100, Mel Gorman wrote:
> pgdat->reclaim_nodes tracks if a remote node is allowed to be reclaimed by
> zone_reclaim due to its distance. As it is expected that zone_reclaim_mode
> will be rarely enabled it is unreasonable for all machines to take a penalty.
> Fortunately, the zone_reclaim_mode() path is already slow and it is the path
> that takes the hit.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
