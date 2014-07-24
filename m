Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbaGXP4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:56:16 -0400
Received: from kanga.kvack.org ([205.233.56.17]:37845 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759499AbaGXP4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:56:14 -0400
Date: Thu, 24 Jul 2014 11:56:14 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, jmoyer@redhat.com,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 3/4] aio: fix some comments
Message-ID: <20140724155614.GD22390@kvack.org>
References: <1406109834-4414-1-git-send-email-guz.fnst@cn.fujitsu.com> <1406109834-4414-3-git-send-email-guz.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406109834-4414-3-git-send-email-guz.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 06:03:53PM +0800, Gu Zheng wrote:
> The function comments of aio_run_iocb and aio_read_events are out of date, so
> fix them here.

Thanks Gu -- applied to my aio-next tree at   
git://git.kvack.org/~bcrl/aio-next.git .

		-ben

> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/aio.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index e0f838d..f1fede2 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1044,7 +1044,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
>  }
>  EXPORT_SYMBOL(aio_complete);
>  
> -/* aio_read_events
> +/* aio_read_events_ring
>   *	Pull an event off of the ioctx's event ring.  Returns the number of
>   *	events fetched
>   */
> @@ -1296,9 +1296,8 @@ static ssize_t aio_setup_single_vector(struct kiocb *kiocb,
>  }
>  
>  /*
> - * aio_setup_iocb:
> - *	Performs the initial checks and aio retry method
> - *	setup for the kiocb at the time of io submission.
> + * aio_run_iocb:
> + *	Performs the initial checks and io submission.
>   */
>  static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
>  			    char __user *buf, bool compat)
> -- 
> 1.7.7

-- 
"Thought is the essence of where you are now."
