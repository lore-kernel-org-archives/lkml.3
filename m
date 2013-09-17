Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3IQLNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:13:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab3IQLNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:13:22 -0400
Date: Tue, 17 Sep 2013 04:13:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: baisong zhong <baisong.zhong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]    adjust the error labels to make it clear
Message-ID: <20130917111341.GA16648@kroah.com>
References: <1379409313-1917-1-git-send-email-baisong.zhong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379409313-1917-1-git-send-email-baisong.zhong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 05:15:13PM +0800, baisong zhong wrote:
> From: zhongbaisong <baisong.zhong@gmail.com>
> 
> Signed-off-by: zhongbaisong <baisong.zhong@gmail.com>

I need a changelog description in here, as to why you are making this
change, your Subject: is not descriptive at all.  What is being made
"clear"?

> ---
>  fs/sysfs/mount.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index afd8327..f6681a6 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -182,12 +182,12 @@ int __init sysfs_init(void)
>  		}
>  	} else
>  		goto out_err;
> -out:
> -	return err;
> +
>  out_err:
>  	kmem_cache_destroy(sysfs_dir_cachep);
>  	sysfs_dir_cachep = NULL;
> -	goto out;
> +out:
> +	return err;

You tested this patch right?  Are you sure?  Really really sure?

greg "I don't think you tested this" k-h
