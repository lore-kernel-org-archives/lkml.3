Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaKXVml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:42:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:42191 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaKXVmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:42:39 -0500
Date: Mon, 24 Nov 2014 13:42:32 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Changman Lee <cm224.lee@samsung.com>, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] f2fs: Fix typos for the word "destroy" in jump labels
Message-ID: <20141124214232.GA30465@jaegeuk-mac02>
References: <54736422.90409@users.sourceforge.net>
 <547369C6.2000004@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547369C6.2000004@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

Merged.
Thank you for the patch.

On Mon, Nov 24, 2014 at 06:24:22PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 24 Nov 2014 15:52:00 +0100
> 
> Two jump labels were adjusted in the implementation of the
> create_node_manager_caches() function because these identifiers
> contained typos.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/f2fs/node.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 4537819..74f44fe 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -2057,17 +2057,17 @@ int __init create_node_manager_caches(void)
>  	free_nid_slab = f2fs_kmem_cache_create("free_nid",
>  			sizeof(struct free_nid));
>  	if (!free_nid_slab)
> -		goto destory_nat_entry;
> +		goto destroy_nat_entry;
>  
>  	nat_entry_set_slab = f2fs_kmem_cache_create("nat_entry_set",
>  			sizeof(struct nat_entry_set));
>  	if (!nat_entry_set_slab)
> -		goto destory_free_nid;
> +		goto destroy_free_nid;
>  	return 0;
>  
> -destory_free_nid:
> +destroy_free_nid:
>  	kmem_cache_destroy(free_nid_slab);
> -destory_nat_entry:
> +destroy_nat_entry:
>  	kmem_cache_destroy(nat_entry_slab);
>  fail:
>  	return -ENOMEM;
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
