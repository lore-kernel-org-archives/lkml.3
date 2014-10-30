Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbaJ3FpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 01:45:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64385 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaJ3FpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 01:45:21 -0400
Date: Thu, 30 Oct 2014 11:15:14 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mikael Svantesson <mikael@distopic.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: skein_api.c: removed space before ','
Message-ID: <20141030054514.GB3519@sudip-PC>
References: <545117FC.6030704@distopic.net>
 <1414604714-13306-1-git-send-email-mikael@distopic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414604714-13306-1-git-send-email-mikael@distopic.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 06:45:14PM +0100, Mikael Svantesson wrote:
> Signed-off-by: Mikael Svantesson <mikael@distopic.net>
> ---
better to send this as a new thread and start the subject
as [PATCH v3]
and also mention a commit message.

thanks
sudip

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
>  
> -	memset(ctx , 0, sizeof(struct skein_ctx));
> +	memset(ctx, 0, sizeof(struct skein_ctx));
>  	ctx->skein_size = size;
>  
>  	return SKEIN_SUCCESS;
> -- 
> 2.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
