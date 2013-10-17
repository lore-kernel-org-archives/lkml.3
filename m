Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762987Ab3JQWDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:03:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762289Ab3JQWDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:03:08 -0400
Date: Fri, 18 Oct 2013 00:03:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Siddharth Goel <siddharth98391@gmail.com>
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [CRYPTO] kconfig: Corrected a typo
In-Reply-To: <1382024351-23743-1-git-send-email-siddharth98391@gmail.com>
Message-ID: <alpine.LNX.2.00.1310180002350.12405@pobox.suse.cz>
References: <1382024351-23743-1-git-send-email-siddharth98391@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013, Siddharth Goel wrote:

> Corrected a typo in option description in Kconfig
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=60848
> 
> Signed-off-by: Siddharth Goel <siddharth98391@gmail.com>
> ---
>  crypto/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 69ce573..84698cf 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1084,7 +1084,7 @@ config CRYPTO_SERPENT
>  
>  	  Keys are allowed to be from 0 to 256 bits in length, in steps
>  	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
> -	  variant of Serpent for compatibility with old kerneli.org code.
> +	  variant of Serpent for compatibility with old kernel.org code.

Automatic conversion of kerneli -> kernel is not correct, it's not a typo. 
Please google for "kerneli" in LKML archives.

-- 
Jiri Kosina
SUSE Labs
