Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422882Ab3FUM7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:59:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161416Ab3FUM7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:59:20 -0400
Date: Fri, 21 Jun 2013 14:59:17 +0200
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [Trivial PATCH 24/33] quota: Convert use of typedef ctl_table to
 struct ctl_table
Message-ID: <20130621125917.GL13932@quack.suse.cz>
References: <cover.1371177118.git.joe@perches.com>
 <4d5b25cd28ef11bd395be57955a431b945e1ac80.1371177118.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d5b25cd28ef11bd395be57955a431b945e1ac80.1371177118.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-06-13 19:37:49, Joe Perches wrote:
> This typedef is unnecessary and should just be removed.
  Thanks. I've merged the patch into my tree and will push it in the next
merge window.

								Honza

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/quota/dquot.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index b3d1ac9..017eaea 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2577,7 +2577,7 @@ static int do_proc_dqstats(struct ctl_table *table, int write,
>  	return proc_dointvec(table, write, buffer, lenp, ppos);
>  }
>  
> -static ctl_table fs_dqstats_table[] = {
> +static struct ctl_table fs_dqstats_table[] = {
>  	{
>  		.procname	= "lookups",
>  		.data		= &dqstats.stat[DQST_LOOKUPS],
> @@ -2646,7 +2646,7 @@ static ctl_table fs_dqstats_table[] = {
>  	{ },
>  };
>  
> -static ctl_table fs_table[] = {
> +static struct ctl_table fs_table[] = {
>  	{
>  		.procname	= "quota",
>  		.mode		= 0555,
> @@ -2655,7 +2655,7 @@ static ctl_table fs_table[] = {
>  	{ },
>  };
>  
> -static ctl_table sys_table[] = {
> +static struct ctl_table sys_table[] = {
>  	{
>  		.procname	= "fs",
>  		.mode		= 0555,
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
