Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaKSMk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:40:29 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38258 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaKSMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:40:27 -0500
Date: Wed, 19 Nov 2014 20:40:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Terence Eden <terence.eden@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        clabbe.montjoie@gmail.com
Subject: Re: [PATCH] crypto: Fix a typo in ahash.c
Message-ID: <20141119124021.GA21828@gondor.apana.org.au>
References: <CABV2FHjqGTBWjNqT6g=v2nW1rXg4oGNrYvbAZUXxpE_Wn_UvUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABV2FHjqGTBWjNqT6g=v2nW1rXg4oGNrYvbAZUXxpE_Wn_UvUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 06:52:40PM +0000, Terence Eden wrote:
> From: Terence Eden <terence.eden@gmail.com>
> 
> "its" == "something belong to it". "it's" == "it is", "it has", "it
> was", etc. Sorry - just bugged me as I was reading the code.
> (Resubmitting - hopefully correctly!)
> 
> Signed-off-by: Terence Eden <terence.eden@gmail.com>
> ---
>  crypto/ahash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index f6a36a5..ffbcda3 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -271,7 +271,7 @@ static int ahash_save_req(struct ahash_request
> *req, crypto_completion_t cplt)
>      /*
>       * WARNING: We do not backup req->priv here! The req->priv
>       *          is for internal use of the Crypto API and the
> -     *          user must _NOT_ _EVER_ depend on it's content!
> +     *          user must _NOT_ _EVER_ depend on its content!

Sorry but your patch does not apply because you've mangled tabs
into spaces.  Please try to apply the patch that you receive via
the list yourself to ensure that you're sending something that
can be applied.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
