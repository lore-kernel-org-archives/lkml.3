Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaGRMuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:50:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaGRMuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:50:24 -0400
Date: Fri, 18 Jul 2014 13:50:18 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: vmscan: rework compaction-ready signaling in
 direct reclaim fix
Message-ID: <20140718125018.GO10819@suse.de>
References: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org>
 <1405344049-19868-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1405344049-19868-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:20:47AM -0400, Johannes Weiner wrote:
> As per Mel, replace out label with breaks from the loop.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
