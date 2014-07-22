Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaGVOLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:11:53 -0400
Received: from kanga.kvack.org ([205.233.56.17]:35494 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaGVOLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:11:51 -0400
Date: Tue, 22 Jul 2014 10:11:50 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] aio: use the macro rather than the inline magic number
Message-ID: <20140722141150.GC26030@kvack.org>
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com> <1405996804-8262-2-git-send-email-guz.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405996804-8262-2-git-send-email-guz.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 10:40:02AM +0800, Gu Zheng wrote:
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

You're missing a commit message here.  The patch is otherwise fine.

		-ben

> ---
>  fs/aio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index ad35876..1dc6158 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -201,7 +201,7 @@ static struct dentry *aio_mount(struct file_system_type *fs_type,
>  	static const struct dentry_operations ops = {
>  		.d_dname	= simple_dname,
>  	};
> -	return mount_pseudo(fs_type, "aio:", NULL, &ops, 0xa10a10a1);
> +	return mount_pseudo(fs_type, "aio:", NULL, &ops, AIO_RING_MAGIC);
>  }
>  
>  /* aio_setup
> -- 
> 1.7.7

-- 
"Thought is the essence of where you are now."
