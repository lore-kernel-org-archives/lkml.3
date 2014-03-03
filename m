Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaCCWIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:08:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009AbaCCWIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:08:18 -0500
Date: Mon, 3 Mar 2014 23:08:16 +0100
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, rdunlap <rdunlap@infradead.org>
Subject: Re: [RFC 1/1] fs: Quota: Refresh Kconfig
Message-ID: <20140303220816.GB15265@quack.suse.cz>
References: <20140221181531.cc488ebae498cd20124a4c32@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221181531.cc488ebae498cd20124a4c32@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-02-14 18:15:31, Fabian Frederick wrote:
> Update Kconfig with a complete list of supported filesystems.
> 
> (Other local filesystems concerned by quota and/or journaled quotas ?)
  reiserfs also supports journaled quotas. Otherwise the update looks OK.

								Honza

> ---
>  fs/quota/Kconfig | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/quota/Kconfig b/fs/quota/Kconfig
> index 880fd98..7339003 100644
> --- a/fs/quota/Kconfig
> +++ b/fs/quota/Kconfig
> @@ -8,9 +8,10 @@ config QUOTA
>  	help
>  	  If you say Y here, you will be able to set per user limits for disk
>  	  usage (also called disk quotas). Currently, it works for the
> -	  ext2, ext3, and reiserfs file system. ext3 also supports journalled
> -	  quotas for which you don't need to run quotacheck(8) after an unclean
> -	  shutdown.
> +	  ext2, ext3, ext4, jfs, ocfs2 and reiserfs file systems.
> +	  Note that gfs2 and xfs use their own quota system.
> +	  Both ext3 and ext4 also support journaled quotas for which you don't
> +	  need to run quotacheck(8) after an unclean shutdown.
>  	  For further details, read the Quota mini-HOWTO, available from
>  	  <http://www.tldp.org/docs.html#howto>, or the documentation provided
>  	  with the quota tools. Probably the quota support is only useful for
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
