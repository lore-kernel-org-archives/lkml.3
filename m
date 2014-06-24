Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaFXJZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:25:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaFXJZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:25:15 -0400
Date: Tue, 24 Jun 2014 11:25:11 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Lei Li <lilei@linux.vnet.ibm.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: remove remove_from_page_cache note
Message-ID: <20140624092511.GC15337@dhcp22.suse.cz>
References: <1403601462-32167-1-git-send-email-lilei@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403601462-32167-1-git-send-email-lilei@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 24-06-14 17:17:42, Lei Li wrote:
> Remove this note as remove_from_page_cache has been renamed to
> delete_from_page_cache since Commit 702cfbf9 ("mm: goodbye
> remove_from_page_cache()"), and it doesn't serve any useful
> purpose.
> 
> Signed-off-by: Lei Li <lilei@linux.vnet.ibm.com>

I am not sure how up-to-date the file is but this small clean up will
not hurt.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  Documentation/cgroups/memcg_test.txt | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
> index 8870b02..67c11a3 100644
> --- a/Documentation/cgroups/memcg_test.txt
> +++ b/Documentation/cgroups/memcg_test.txt
> @@ -82,8 +82,6 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
>  	- add_to_page_cache_locked().
>  
>  	The logic is very clear. (About migration, see below)
> -	Note: __remove_from_page_cache() is called by remove_from_page_cache()
> -	and __remove_mapping().
>  
>  6. Shmem(tmpfs) Page Cache
>  	The best way to understand shmem's page state transition is to read
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
