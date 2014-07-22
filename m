Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaGVNyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaGVNyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:54:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bcrl@kvack.org, axboe@kernel.dk, akpm@linux-foundation.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] aio: remove the needless registration of ring file's private_data
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Jul 2014 09:53:59 -0400
In-Reply-To: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com> (Gu
	Zheng's message of "Tue, 22 Jul 2014 10:40:01 +0800")
Message-ID: <x49zjg17b48.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

> Remove the registration of ring file's private_data, we do not use
> it.
>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

> ---
>  fs/aio.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 955947e..ad35876 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -192,7 +192,6 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
>  	}
>  
>  	file->f_flags = O_RDWR;
> -	file->private_data = ctx;
>  	return file;
>  }
