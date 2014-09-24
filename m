Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaIXT1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:27:18 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10716 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753696AbaIXT1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:27:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19FEgzISDzAdXXmSYt3xCf6lLe0UGolOvU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 06F1B5EB715
Date: Wed, 24 Sep 2014 15:27:13 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Mike Roocroft <mike.linux@btinternet.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Skein: skein_block: fixed 3 tab coding style
 isses
Message-ID: <20140924192712.GM23926@titan.lakedaemon.net>
References: <1411425935-867-1-git-send-email-mike.linux@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411425935-867-1-git-send-email-mike.linux@btinternet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On Mon, Sep 22, 2014 at 11:45:35PM +0100, Mike Roocroft wrote:
> Fixed a coding style issue
> 
> Signed-off-by: Mike Roocroft <mike.linux@btinternet.com>
> ---
>  drivers/staging/skein/skein_block.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
> index 04ce1d0..b969fe1 100644
> --- a/drivers/staging/skein/skein_block.c
> +++ b/drivers/staging/skein/skein_block.c
> @@ -34,7 +34,7 @@
>  
>  #ifdef SKEIN_DEBUG
>  #define debug_save_tweak(ctx) { \
> -                        ctx->h.tweak[0] = ts[0]; ctx->h.tweak[1] = ts[1]; }
> +			ctx->h.tweak[0] = ts[0]; ctx->h.tweak[1] = ts[1]; }

hmm, yes.  I somehow missed this during my original cleanup.

>  #else
>  #define debug_save_tweak(ctx)
>  #endif
> @@ -378,7 +378,7 @@ do { \
>  	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
>  } while (0)
>  
> -		for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
> +	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
>  #endif /* end of looped code definitions */
>  		{
>  #define R512_8_ROUNDS(R)  /* do 8 full rounds */  \
> @@ -657,7 +657,7 @@ do { \
>  	skein_show_r_ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
>  } while (0)
>  
> -		for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
> +	for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
>  #endif
>  		{
>  #define R1024_8_ROUNDS(R) \

ugghh.  These two changes are conceptually fine, but they have reminded
me that I need to completely rework this macro hell.

At any rate, the patch itself is fine for the staging tree.

Please re-send with my:

Acked-by: Jason Cooper <jason@lakedaemon.net>

Make sure to include the staging ml and gregkh on the resend.

thx,

Jason.
