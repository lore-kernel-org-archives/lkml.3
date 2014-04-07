Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbaDGXfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:35:24 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58471 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbaDGXfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:35:23 -0400
Date: Mon, 7 Apr 2014 19:35:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: Disable zone_reclaim_mode by default
Message-ID: <20140407233511.GO4407@cmpxchg.org>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
 <1396910068-11637-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396910068-11637-2-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 11:34:27PM +0100, Mel Gorman wrote:
> zone_reclaim_mode causes processes to prefer reclaiming memory from local
> node instead of spilling over to other nodes. This made sense initially when
> NUMA machines were almost exclusively HPC and the workload was partitioned
> into nodes. The NUMA penalties were sufficiently high to justify reclaiming
> the memory. On current machines and workloads it is often the case that
> zone_reclaim_mode destroys performance but not all users know how to detect
> this. Favour the common case and disable it by default. Users that are
> sophisticated enough to know they need zone_reclaim_mode will detect it.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
