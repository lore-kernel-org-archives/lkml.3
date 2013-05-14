Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab3ENSdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:33:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20831 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3ENSdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:33:47 -0400
Date: Tue, 14 May 2013 21:33:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nathan Zimmer <nzimmer@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbtree: remove unneeded include
Message-ID: <20130514183333.GK1360@mwanda>
References: <1368556069-194880-1-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368556069-194880-1-git-send-email-nzimmer@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These go through Andrew Morton.  He's the only person who reads LKML
so he might notice this patch, but I have added him to the CC list
just in case.

regards,
dan carpenter

On Tue, May 14, 2013 at 01:27:49PM -0500, Nathan Zimmer wrote:
> Remove an unnecessary include to kernel.h
> 
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> ---
>  include/linux/rbtree.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
> index 0022c1b..d2fdc6d 100644
> --- a/include/linux/rbtree.h
> +++ b/include/linux/rbtree.h
> @@ -29,7 +29,6 @@
>  #ifndef	_LINUX_RBTREE_H
>  #define	_LINUX_RBTREE_H
>  
> -#include <linux/kernel.h>
>  #include <linux/stddef.h>
>  
>  struct rb_node {
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
