Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaGVNyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbaGVNyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:54:36 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bcrl@kvack.org, axboe@kernel.dk, akpm@linux-foundation.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] aio: use the macro rather than the inline magic number
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com>
	<1405996804-8262-2-git-send-email-guz.fnst@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Jul 2014 09:54:18 -0400
In-Reply-To: <1405996804-8262-2-git-send-email-guz.fnst@cn.fujitsu.com> (Gu
	Zheng's message of "Tue, 22 Jul 2014 10:40:02 +0800")
Message-ID: <x49vbqp7b3p.fsf@segfault.boston.devel.redhat.com>
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
