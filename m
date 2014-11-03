Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaKCOtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:49:45 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:36147 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaKCOtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:49:43 -0500
Date: Mon, 3 Nov 2014 22:49:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Jonathan Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level
 spec
Message-ID: <20141103144925.GA31688@gondor.apana.org.au>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
 <4163724.RCMDlx8dmE@tachyon.chronox.de>
 <20141103083439.635f5cb6@lwn.net>
 <4303532.NGaUQ44sQJ@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4303532.NGaUQ44sQJ@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 03:18:29PM +0100, Stephan Mueller wrote:
>
> > > + * CRYPTO_ALG_TYPE_DIGEST	Raw message digest
> > > + * CRYPTO_ALG_TYPE_HASH		Alias for CRYPTO_ALG_TYPE_DIGEST
> > > + * CRYPTO_ALG_TYPE_SHASH	Synchronous multi-block hash
> > > + * CRYPTO_ALG_TYPE_AHASH	Asynchronous multi-block hash
> > > + * CRYPTO_ALG_TYPE_RNG		Random Number Generation
> > > + * CRYPTO_ALG_TYPE_PCOMPRESS
> > 
> > What's that last one?
> 
> Same here.

pcompress is an enhanced version of compress allowing for piece-meal
compression/decompression rather than having to shove everything in
all at once.

Eventually pcompress should replace the compress interface once
everything is converted across.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
