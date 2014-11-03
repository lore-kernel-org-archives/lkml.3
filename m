Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaKCP2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:28:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbaKCP2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:28:50 -0500
Date: Mon, 3 Nov 2014 16:28:48 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: remove stale page_cgroup_lock comment
Message-ID: <20141103152848.GD10156@dhcp22.suse.cz>
References: <1414898060-4658-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414898060-4658-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 01-11-14 23:14:20, Johannes Weiner wrote:
> There is no cgroup-specific page lock anymore.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 38f0647a2f12..d20928597a07 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2467,10 +2467,6 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
>  	int isolated;
>  
>  	VM_BUG_ON_PAGE(pc->mem_cgroup, page);
> -	/*
> -	 * we don't need page_cgroup_lock about tail pages, becase they are not
> -	 * accessed by any other context at this point.
> -	 */
>  
>  	/*
>  	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
> -- 
> 2.1.3
> 

-- 
Michal Hocko
SUSE Labs
