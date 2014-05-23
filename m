Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaEWVPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:15:05 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:41614 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaEWVPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:15:03 -0400
Date: Sat, 24 May 2014 05:14:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com, joe@perches.com
Subject: Re: [PATCH v7 0/6] SP800-90A Deterministic Random Bit Generator
Message-ID: <20140523211459.GA21019@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16102625.1uoi9eJz6k@myon.chronox.de>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller <smueller@chronox.de> wrote:
> Hi,
> 
> the following set of patches implements the deterministic random bit generator
> (DRBG) specified by SP800-90A.
> 
> The DRBG implementation offers the following:
> 
>        * All three DRBG types are implemented with a derivation function.
>        * All DRBG types are available with and without prediction resistance.
>        * All SHA types of SHA-1, SHA-256, SHA-384, SHA-512 are available
>          for the HMAC and Hash DRBGs.
>        * All AES types of AES-128, AES-192 and AES-256 are available for the
>          CTR DRBG.
>        * A self test is implemented with drbg_healthcheck().
>        * The FIPS 140-2 continuous self test is implemented.
>        * Additional cipher primitives, such as Serpent or Twofish, can be
>          added to the DRBG without changing the implementation. The only
>          change necessary is to the DRBG definition given in the cores[]
>          array.

Where is the code that actually uses this?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
