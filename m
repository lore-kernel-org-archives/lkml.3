Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaJ2FZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:25:30 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52457 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaJ2FZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:25:29 -0400
Date: Wed, 29 Oct 2014 10:55:17 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mikael Svantesson <mikael@distopic.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Cooper <jason@lakedaemon.net>, Jake Edge <jake@lwn.net>,
        Anton Saraev <antonysaraev@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: skein: skein_api.c: removed space before ','
Message-ID: <20141029052517.GA3556@sudip-PC>
References: <544FF764.7090003@distopic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FF764.7090003@distopic.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:07:00PM +0100, Mikael Svantesson wrote:
> Signed-off-by: Mikael Svantesson <mikael@distopic.net>
still the same problem.

ERROR: patch seems to be corrupt (line wrapped?)


> ---
>  drivers/staging/skein/skein_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/skein/skein_api.c b/drivers/staging/skein/skein_api.c
> index 6e700ee..5bfce07 100644
> --- a/drivers/staging/skein/skein_api.c
> +++ b/drivers/staging/skein/skein_api.c
> @@ -31,7 +31,7 @@ int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
>  {
>  	skein_assert_ret(ctx && size, SKEIN_FAIL);
>  -	memset(ctx , 0, sizeof(struct skein_ctx));
> +	memset(ctx, 0, sizeof(struct skein_ctx));
>  	ctx->skein_size = size;
>   	return SKEIN_SUCCESS;
> -- 
> 2.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
