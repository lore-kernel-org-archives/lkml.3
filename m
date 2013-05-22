Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3EVKu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:50:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab3EVKuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:50:25 -0400
Date: Wed, 22 May 2013 12:50:23 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/pageblock: remove get/set_pageblock_flags
Message-ID: <20130522105023.GD19989@dhcp22.suse.cz>
References: <1369214970-1526-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1369214970-1526-2-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369214970-1526-2-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 22-05-13 17:29:28, Wanpeng Li wrote:
> get_pageblock_flags and set_pageblock_flags are not used any 
> more, this patch remove them.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Yes, git grep agrees
Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/linux/pageblock-flags.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
> index be655e4..2ee8cd2 100644
> --- a/include/linux/pageblock-flags.h
> +++ b/include/linux/pageblock-flags.h
> @@ -80,10 +80,4 @@ void set_pageblock_flags_group(struct page *page, unsigned long flags,
>  							PB_migrate_skip)
>  #endif /* CONFIG_COMPACTION */
>  
> -#define get_pageblock_flags(page) \
> -			get_pageblock_flags_group(page, 0, PB_migrate_end)
> -#define set_pageblock_flags(page, flags) \
> -			set_pageblock_flags_group(page, flags,	\
> -						  0, PB_migrate_end)
> -
>  #endif	/* PAGEBLOCK_FLAGS_H */
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
