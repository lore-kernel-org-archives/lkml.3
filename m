Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116AbaENGcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 02:32:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaENGcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 02:32:14 -0400
Date: Wed, 14 May 2014 07:32:07 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 05/19] mm: page_alloc: Calculate classzone_idx once from
 the zonelist ref
Message-ID: <20140514063207.GX23991@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-6-git-send-email-mgorman@suse.de>
 <20140513152556.d14e3eaff8949a7010c02686@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140513152556.d14e3eaff8949a7010c02686@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:25:56PM -0700, Andrew Morton wrote:
> On Tue, 13 May 2014 10:45:36 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > There is no need to calculate zone_idx(preferred_zone) multiple times
> > or use the pgdat to figure it out.
> > 
> 
> This one falls afoul of pending mm/next changes in non-trivial ways.

No problem, I can rework this patch on top of mmotm. Thanks.

-- 
Mel Gorman
SUSE Labs
