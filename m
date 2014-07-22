Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaGVNyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:54:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbaGVNyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:54:45 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bcrl@kvack.org, axboe@kernel.dk, akpm@linux-foundation.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] aio: fix some comments
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com>
	<1405996804-8262-3-git-send-email-guz.fnst@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Jul 2014 09:54:35 -0400
In-Reply-To: <1405996804-8262-3-git-send-email-guz.fnst@cn.fujitsu.com> (Gu
	Zheng's message of "Tue, 22 Jul 2014 10:40:03 +0800")
Message-ID: <x49r41d7b38.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

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
