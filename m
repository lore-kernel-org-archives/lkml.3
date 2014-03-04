Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbaCDI3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:29:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbaCDI3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:29:21 -0500
Date: Tue, 4 Mar 2014 09:29:17 +0100
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jack <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>, rdunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/1] fs/quota/Kconfig: Update filesystems
Message-ID: <20140304082917.GB22966@quack.suse.cz>
References: <20140304081107.da00303af01803f0f894728a@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304081107.da00303af01803f0f894728a@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-03-14 08:11:07, Fabian Frederick wrote:
> Update Kconfig with a complete list of supported filesystems.
  Thanks. I have added the patch to my tree.

								Honza

> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/quota/Kconfig | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/quota/Kconfig b/fs/quota/Kconfig
> index 880fd98..c51df1d 100644
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
> +	  Ext3, ext4 and reiserfs also support journaled quotas for which
> +	  you don't need to run quotacheck(8) after an unclean shutdown.
>  	  For further details, read the Quota mini-HOWTO, available from
>  	  <http://www.tldp.org/docs.html#howto>, or the documentation provided
>  	  with the quota tools. Probably the quota support is only useful for
> -- 
> 1.8.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
