Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3K2CHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:07:07 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:54046 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3K2CHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:07:02 -0500
Date: Fri, 29 Nov 2013 10:06:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Cristian Stoica <cristian.stoica@freescale.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: remove unnecessary includes
Message-ID: <20131129020657.GA5650@gondor.apana.org.au>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 07:16:27PM +0200, Cristian Stoica wrote:
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  crypto/authenc.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/crypto/authenc.c b/crypto/authenc.c
> index 1875e70..7d4bfaa 100644
> --- a/crypto/authenc.c
> +++ b/crypto/authenc.c
> @@ -17,11 +17,8 @@
>  #include <crypto/scatterwalk.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
> -#include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/rtnetlink.h>
> -#include <linux/slab.h>
> -#include <linux/spinlock.h>
>  
>  typedef u8 *(*authenc_ahash_t)(struct aead_request *req, unsigned int flags);

Why are these includes unnecessary?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
