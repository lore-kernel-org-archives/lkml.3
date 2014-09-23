Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaIWPTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:19:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaIWPTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:19:12 -0400
Date: Tue, 23 Sep 2014 17:18:55 +0200
From: Jan Kara <jack@suse.cz>
To: Tommy Kurby <tommykurby91@gmail.com>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fs: Ext2: xip.h: fixed coding style issues
Message-ID: <20140923151855.GA18189@quack.suse.cz>
References: <1411429600-4148-1-git-send-email-tommykurby91@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411429600-4148-1-git-send-email-tommykurby91@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-09-14 01:46:40, Tommy Kurby wrote:
> Fixed coding style issues.
> 
> Signed-off-by: Tommy Kurby <tommykurby91@gmail.com>
  Hum, I think Matthew Wilcox's patches change this area as well and they
actually also do something useful. So I prefer not to merge this trivial
cleanup to not make Matthew's life unnecesarily harder.

								Honza
> ---
>  fs/ext2/xip.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/xip.h b/fs/ext2/xip.h
> index 18b34d2..57b479b 100644
> --- a/fs/ext2/xip.h
> +++ b/fs/ext2/xip.h
> @@ -6,12 +6,13 @@
>   */
>  
>  #ifdef CONFIG_EXT2_FS_XIP
> -extern void ext2_xip_verify_sb (struct super_block *);
> -extern int ext2_clear_xip_target (struct inode *, sector_t);
> +extern void ext2_xip_verify_sb(struct super_block *);
> +extern int ext2_clear_xip_target(struct inode *, sector_t);
>  
> -static inline int ext2_use_xip (struct super_block *sb)
> +static inline int ext2_use_xip(struct super_block *sb)
>  {
>  	struct ext2_sb_info *sbi = EXT2_SB(sb);
> +
>  	return (sbi->s_mount_opt & EXT2_MOUNT_XIP);
>  }
>  int ext2_get_xip_mem(struct address_space *, pgoff_t, int,
> -- 
> 2.1.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
