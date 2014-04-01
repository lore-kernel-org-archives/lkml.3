Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaDAViu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:38:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaDAVis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:38:48 -0400
Date: Tue, 1 Apr 2014 23:38:46 +0200
From: Jan Kara <jack@suse.cz>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ext2: acl: remove unneeded include of
 linux/capability.h
Message-ID: <20140401213846.GA31099@quack.suse.cz>
References: <1395645684-26512-1-git-send-email-jsitnicki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395645684-26512-1-git-send-email-jsitnicki@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 24-03-14 08:21:24, Jakub Sitnicki wrote:
> acl.c has not been (directly) using the interface defined by
> linux/capability.h header since commit 3bd858ab1c451725c07a
> ("Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid
> check"). Remove it.
  Thanks. I've merged the patch.

								Honza
> 
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>  fs/ext2/acl.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
> index 1b8001b..27695e6 100644
> --- a/fs/ext2/acl.c
> +++ b/fs/ext2/acl.c
> @@ -4,7 +4,6 @@
>   * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
>   */
>  
> -#include <linux/capability.h>
>  #include <linux/init.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
