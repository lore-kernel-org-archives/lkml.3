Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaGNKKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:10:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbaGNKKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:10:24 -0400
Date: Mon, 14 Jul 2014 12:10:20 +0200
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/quota: kernel-doc warning fixes
Message-ID: <20140714101020.GC30550@quack.suse.cz>
References: <1404503065-32385-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404503065-32385-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 04-07-14 21:44:25, Fabian Frederick wrote:
> type and id were removed and qid added to quota_send_warning in commit
> 
> 431f19744d15
> ("userns: Convert quota netlink aka quota_send_warning")
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
  Thanks, I've merged the patch into my tree.

								Honza

> ---
>  fs/quota/kqid.c    | 2 +-
>  fs/quota/netlink.c | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/quota/kqid.c b/fs/quota/kqid.c
> index 2f97b0e..ebc5e62 100644
> --- a/fs/quota/kqid.c
> +++ b/fs/quota/kqid.c
> @@ -55,7 +55,7 @@ EXPORT_SYMBOL(qid_lt);
>  /**
>   *	from_kqid - Create a qid from a kqid user-namespace pair.
>   *	@targ: The user namespace we want a qid in.
> - *	@kuid: The kernel internal quota identifier to start with.
> + *	@kqid: The kernel internal quota identifier to start with.
>   *
>   *	Map @kqid into the user-namespace specified by @targ and
>   *	return the resulting qid.
> diff --git a/fs/quota/netlink.c b/fs/quota/netlink.c
> index 72d2917..bb2869f 100644
> --- a/fs/quota/netlink.c
> +++ b/fs/quota/netlink.c
> @@ -32,8 +32,7 @@ static struct genl_family quota_genl_family = {
>  
>  /**
>   * quota_send_warning - Send warning to userspace about exceeded quota
> - * @type: The quota type: USRQQUOTA, GRPQUOTA,...
> - * @id: The user or group id of the quota that was exceeded
> + * @qid: The kernel internal quota identifier.
>   * @dev: The device on which the fs is mounted (sb->s_dev)
>   * @warntype: The type of the warning: QUOTA_NL_...
>   *
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
