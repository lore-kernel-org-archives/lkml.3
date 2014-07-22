Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaGVOMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:12:22 -0400
Received: from kanga.kvack.org ([205.233.56.17]:35539 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaGVOMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:12:21 -0400
Date: Tue, 22 Jul 2014 10:12:20 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] aio: fix some comments
Message-ID: <20140722141220.GD26030@kvack.org>
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com> <1405996804-8262-3-git-send-email-guz.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405996804-8262-3-git-send-email-guz.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 10:40:03AM +0800, Gu Zheng wrote:
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Again, you're missing a commit message here.  Please resubmit with a commit 
message.

		-ben

> ---
>  fs/aio.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 1dc6158..0cd0479 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1037,7 +1037,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
>  }
>  EXPORT_SYMBOL(aio_complete);
>  
> -/* aio_read_events
> +/* aio_read_events_ring
>   *	Pull an event off of the ioctx's event ring.  Returns the number of
>   *	events fetched
>   */
> @@ -1289,9 +1289,8 @@ static ssize_t aio_setup_single_vector(struct kiocb *kiocb,
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
