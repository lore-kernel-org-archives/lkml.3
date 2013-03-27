Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3C0MUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:20:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab3C0MUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:20:38 -0400
Date: Wed, 27 Mar 2013 13:20:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Fix typo "CONFIG_CGROUP_CGROUP_MEMCG_SWAP"
In-Reply-To: <1364252356.1390.303.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1303271320120.23442@pobox.suse.cz>
References: <1364252356.1390.303.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  Documentation/cgroups/memory.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 8b8c28b..17b91e0 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -194,7 +194,7 @@ the cgroup that brought it in -- this will happen on memory pressure).
>  But see section 8.2: when moving a task to another cgroup, its pages may
>  be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
>  
> -Exception: If CONFIG_CGROUP_CGROUP_MEMCG_SWAP is not used.
> +Exception: If CONFIG_MEMCG_SWAP is not used.
>  When you do swapoff and make swapped-out pages of shmem(tmpfs) to
>  be backed into memory in force, charges for pages are accounted against the
>  caller of swapoff rather than the users of shmem.

While you are at it, how about updating various defconfigs which have the 
bogus name in there as well?

Thanks,

-- 
Jiri Kosina
SUSE Labs
