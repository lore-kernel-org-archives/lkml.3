Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaKQRsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:48:03 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56997 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKQRsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:48:01 -0500
Message-ID: <546A34CD.1080203@gmail.com>
Date: Mon, 17 Nov 2014 18:47:57 +0100
From: Corentin LABBE <clabbe.montjoie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Terence Eden <terence.eden@gmail.com>, herbert@gondor.apana.org.au
CC: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        edent <github.com@shkspr.mobi>
Subject: Re: [PATCH] "its" == "something belong to it". "it's" == "it is",
 "it has", "it was", etc. Sorry - just bugged me as I was reading the code.
References: <1416243964-9790-1-git-send-email-terence.eden@gmail.com>
In-Reply-To: <1416243964-9790-1-git-send-email-terence.eden@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17/11/2014 18:06, Terence Eden a écrit :
> From: edent <github.com@shkspr.mobi>
> 
> Signed-off-by: edent <github.com@shkspr.mobi>
> ---
>  crypto/ahash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index f6a36a5..ffbcda3 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -271,7 +271,7 @@ static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
>  	/*
>  	 * WARNING: We do not backup req->priv here! The req->priv
>  	 *          is for internal use of the Crypto API and the
> -	 *          user must _NOT_ _EVER_ depend on it's content!
> +	 *          user must _NOT_ _EVER_ depend on its content!
>  	 */
>  
>  	req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
> 

Hello

Please sign off with your real name.
Your subject line is wrong, you need to add the subsystem "crypto:" and the subject must be simplier; but you could keep the actual subject as a commit message

<example>
[PATCH] crypto: Fix a typo in ahash.c

"its" == "something belong to it". "it's" == "it is", "it has", "it was", etc. Sorry - just bugged me as I was reading the code.
</example>

Regards

LABBE Corentin

