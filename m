Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaBCX4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:56:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbaBCX4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:56:17 -0500
Date: Tue, 4 Feb 2014 00:56:14 +0100
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] ext2: Add __init macro to init_inodecache
Message-ID: <20140203235614.GG2542@quack.suse.cz>
References: <20140201160202.a3ac96c613754013300b462d@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140201160202.a3ac96c613754013300b462d@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 01-02-14 16:02:02, Fabian Frederick wrote:
> init_inodecache is only called by __init init_ext2_fs.
  Thanks added to my tree.

							Honza

> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/ext2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 20d6697..73d80da 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -192,7 +192,7 @@ static void init_once(void *foo)
>  	inode_init_once(&ei->vfs_inode);
>  }
>  
> -static int init_inodecache(void)
> +static int __init init_inodecache(void)
>  {
>  	ext2_inode_cachep = kmem_cache_create("ext2_inode_cache",
>  					     sizeof(struct ext2_inode_info),
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
