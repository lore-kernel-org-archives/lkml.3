Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaBCX4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:56:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbaBCX4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:56:33 -0500
Date: Tue, 4 Feb 2014 00:56:31 +0100
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        rdunlap@infradead.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/1] udf: Add __init macro to init_inodecache
Message-ID: <20140203235631.GH2542@quack.suse.cz>
References: <20140201154518.517605f64016ed42e9786f84@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140201154518.517605f64016ed42e9786f84@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 01-02-14 15:45:18, Fabian Frederick wrote:
> init_inodecache is only called by __init init_udf_fs.
  Thanks. Added to my tree.

							Honza

> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/udf/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 3306b9f..6a14649 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -175,7 +175,7 @@ static void init_once(void *foo)
>  	inode_init_once(&ei->vfs_inode);
>  }
>  
> -static int init_inodecache(void)
> +static int __init init_inodecache(void)
>  {
>  	udf_inode_cachep = kmem_cache_create("udf_inode_cache",
>  					     sizeof(struct udf_inode_info),
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
