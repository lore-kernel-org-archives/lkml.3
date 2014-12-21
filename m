Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaLUIwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 03:52:13 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64672 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaLUIwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 03:52:09 -0500
Date: Sun, 21 Dec 2014 00:52:05 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
Cc: akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: fixed a space coding style issue
Message-ID: <20141221085205.GA13203@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Gangadhar Vukkesala <gangs.freelancer@gmail.com>,
	akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
	ebiederm@xmission.com, linux-kernel@vger.kernel.org
References: <1419150722-8313-1-git-send-email-gangs.freelancer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419150722-8313-1-git-send-email-gangs.freelancer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gangadhar,

On Sun, Dec 21, 2014 at 02:02:02PM +0530, Gangadhar Vukkesala wrote:
> fixed a space coding style issue in pid.c which was found when
> running checkpatch.pl on pid.c
> 
> Signed-off-by: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
> ---
>  kernel/pid.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index cd36a5e..ad9d780 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -72,7 +72,7 @@ struct pid_namespace init_pid_ns = {
>  		.refcount       = ATOMIC_INIT(2),
>  	},
>  	.pidmap = {
> -		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
> +		[0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
>  	},
>  	.last_pid = 0,
>  	.nr_hashed = PIDNS_HASH_ADDING,
> @@ -267,7 +267,7 @@ void free_pid(struct pid *pid)
>  		struct upid *upid = pid->numbers + i;
>  		struct pid_namespace *ns = upid->ns;
>  		hlist_del_rcu(&upid->pid_chain);
> -		switch(--ns->nr_hashed) {
> +		switch (--ns->nr_hashed) {
>  		case 2:
>  		case 1:
>  			/* When all that is left in the pid namespace
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

It looks reasonable.  But keep in mind that white space fixes may be
considered "code churn" [1] in some parts of the kernel.  The staging
area is much more welcoming of these sorts of changes.

  [1]: https://lkml.org/lkml/2014/6/10/819

-- 
- Jeremiah Mahler
