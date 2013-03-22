Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab3CVNOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:14:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab3CVNOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:14:07 -0400
Date: Fri, 22 Mar 2013 14:13:37 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 7/7] uretprobes: implemented, thus remove -ENOSYS
Message-ID: <20130322131337.GA7016@bandura.redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com>
 <1363957745-6657-8-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-8-git-send-email-anton@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  please disregard this one, not sure how it managed to hide within
  the rest ones...

sry,
Anton.

On Fri, Mar 22, 2013 at 02:09:04PM +0100, Anton Arapov wrote:
>   enclose return probes implementation
> 
> v3 changes: (the patch is introduced in v3)
>   - remove 'TODO' as return probes implemented now
> 
> Signed-off-by: Anton Arapov <anton@redhat.com>
> ---
>  kernel/events/uprobes.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 5fb7809..e13f9f8 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -840,10 +840,6 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
>  	if (!uc->handler && !uc->rp_handler)
>  		return -EINVAL;
>  
> -	/* TODO: Implement return probes */
> -	if (uc->rp_handler)
> -		return -ENOSYS;
> -
>  	/* Racy, just to catch the obvious mistakes */
>  	if (offset > i_size_read(inode))
>  		return -EINVAL;
> -- 
> 1.8.1.4
> 
