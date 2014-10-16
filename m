Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaJPMaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:30:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaJPMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:30:04 -0400
Date: Thu, 16 Oct 2014 14:30:02 +0200
From: Jan Kara <jack@suse.cz>
To: Masanari Iida <standby24x7@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] quota: Fix spelling typo in module description in
 quota_tree.c
Message-ID: <20141016123002.GJ6085@quack.suse.cz>
References: <1413461412-19263-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413461412-19263-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-10-14 21:10:12, Masanari Iida wrote:
> This patch fix spelling typo in module description.
> "Quota trie support" should be "Quota tree support",
> since the file name is quota_tree.c
  Thanks for the patch but actually this is not a typo. Trie is a name of
the specific type of the tree (http://en.wikipedia.org/wiki/Trie) which
this module implements.  I agree the name of the file and the description
mismatch which is somewhat confusing but I don't think it's really worth
fixing...

								Honza
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  fs/quota/quota_tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
> index d65877f..60ecc39 100644
> --- a/fs/quota/quota_tree.c
> +++ b/fs/quota/quota_tree.c
> @@ -17,7 +17,7 @@
>  #include "quota_tree.h"
>  
>  MODULE_AUTHOR("Jan Kara");
> -MODULE_DESCRIPTION("Quota trie support");
> +MODULE_DESCRIPTION("Quota tree support");
>  MODULE_LICENSE("GPL");
>  
>  #define __QUOTA_QT_PARANOIA
> -- 
> 2.1.2.443.g670a3c1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
