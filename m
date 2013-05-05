Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab3EENes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 09:34:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3EENer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 09:34:47 -0400
Date: Sun, 5 May 2013 16:34:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Rusty Russell'" <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_blk: Add missing 'static' qualifiers
Message-ID: <20130505133436.GA6314@redhat.com>
References: <001101ce47a0$a6bfa500$f43eef00$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001101ce47a0$a6bfa500$f43eef00$%choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 10:50:55AM +0900, Jonghwan Choi wrote:
> Add missing 'static' qualifiers
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/block/virtio_blk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 6472395..5cdf88b 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -20,7 +20,7 @@ module_param(use_bio, bool, S_IRUGO);
>  static int major;
>  static DEFINE_IDA(vd_index_ida);
>  
> -struct workqueue_struct *virtblk_wq;
> +static struct workqueue_struct *virtblk_wq;
>  
>  struct virtio_blk
>  {
> -- 
> 1.7.9.5
