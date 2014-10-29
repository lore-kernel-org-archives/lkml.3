Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131AbaJ2Prn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:47:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934072AbaJ2Pl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:41:59 -0400
Date: Wed, 29 Oct 2014 16:41:18 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikael Svantesson <mikael@distopic.net>
Cc: Jason Cooper <jason@lakedaemon.net>, Jake Edge <jake@lwn.net>,
        Anton Saraev <antonysaraev@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: skein: skein_api.c: removed space before ','
Message-ID: <20141029084118.GB5333@kroah.com>
References: <544FF764.7090003@distopic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544FF764.7090003@distopic.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:07:00PM +0100, Mikael Svantesson wrote:
> Signed-off-by: Mikael Svantesson <mikael@distopic.net>
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

Still corrupted, what added the extra ' ' before the '-'?

