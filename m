Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaCYQ0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:26:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbaCYQ0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:26:45 -0400
Message-ID: <5331AE40.5040903@suse.com>
Date: Tue, 25 Mar 2014 12:26:40 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: reiserfs-devel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/reiserfs/super.c: add __init to init_inodecache
References: <20140321171626.d835c81af6c795cb3ae2fb6a@skynet.be>
In-Reply-To: <20140321171626.d835c81af6c795cb3ae2fb6a@skynet.be>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/14, 12:16 PM, Fabian Frederick wrote:
> init_inodecache is only called by __init init_reiserfs_fs.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/reiserfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index 2c80335..7035087 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -597,7 +597,7 @@ static void init_once(void *foo)
>  	inode_init_once(&ei->vfs_inode);
>  }
>  
> -static int init_inodecache(void)
> +static int __init init_inodecache(void)
>  {
>  	reiserfs_inode_cachep = kmem_cache_create("reiser_inode_cache",
>  						  sizeof(struct
> 


-- 
Jeff Mahoney
SUSE Labs
