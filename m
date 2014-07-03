Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165AbaGCOaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:30:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928AbaGCOaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:30:15 -0400
Message-ID: <53B568DB.8010600@redhat.com>
Date: Thu, 03 Jul 2014 15:29:47 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: cluster-devel@redhat.com
Subject: Re: [PATCH 1/1] fs/gfs2/rgrp.c: kernel-doc warning fixes
References: <1404331527-4068-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1404331527-4068-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This and the seq_puts patch are now both in the -nmw tree. Thanks,

Steve.

On 02/07/14 21:05, Fabian Frederick wrote:
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   fs/gfs2/rgrp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
> index db629d1..f4cb9c0 100644
> --- a/fs/gfs2/rgrp.c
> +++ b/fs/gfs2/rgrp.c
> @@ -337,7 +337,7 @@ static bool gfs2_unaligned_extlen(struct gfs2_rbm *rbm, u32 n_unaligned, u32 *le
>   
>   /**
>    * gfs2_free_extlen - Return extent length of free blocks
> - * @rbm: Starting position
> + * @rrbm: Starting position
>    * @len: Max length to check
>    *
>    * Starting at the block specified by the rbm, see how many free blocks
> @@ -2522,7 +2522,7 @@ void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state)
>   
>   /**
>    * gfs2_rlist_free - free a resource group list
> - * @list: the list of resource groups
> + * @rlist: the list of resource groups
>    *
>    */
>   

