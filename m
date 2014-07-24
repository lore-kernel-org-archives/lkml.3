Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbaGXPzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:55:50 -0400
Received: from kanga.kvack.org ([205.233.56.17]:37750 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759499AbaGXPzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:55:47 -0400
Date: Thu, 24 Jul 2014 11:55:46 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, jmoyer@redhat.com,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/4] aio: remove the needless registration of ring file's private_data
Message-ID: <20140724155546.GB22390@kvack.org>
References: <1406109834-4414-1-git-send-email-guz.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406109834-4414-1-git-send-email-guz.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 06:03:51PM +0800, Gu Zheng wrote:
> Remove the registration of ring file's private_data, we do not use
> it.

Thanks Gu -- applied to my aio-next tree at 
git://git.kvack.org/~bcrl/aio-next.git .

		-ben

> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/aio.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 1c9c5f0..94546ab 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -192,7 +192,6 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
>  	}
>  
>  	file->f_flags = O_RDWR;
> -	file->private_data = ctx;
>  	return file;
>  }
>  
> -- 
> 1.7.7

-- 
"Thought is the essence of where you are now."
