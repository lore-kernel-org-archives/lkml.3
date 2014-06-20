Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967005AbaFTSlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:41:46 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:54028 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966855AbaFTSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:41:45 -0400
Date: Sat, 21 Jun 2014 02:41:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, joe@perches.com, pwalten@au1.ibm.com,
        jeremy.wayne.powell@gmail.com, clemens@ladisch.de
Subject: Re: [PATCH v9 0/6] SP800-90A Deterministic Random Bit Generator
Message-ID: <20140620184136.GF3169@gondor.apana.org.au>
References: <22272963.fKEMicLVWl@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22272963.fKEMicLVWl@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 03:43:37PM +0200, Stephan Mueller wrote:
> Hi,
> 
> the following set of patches implements the deterministic random bit generator
> (DRBG) specified by SP800-90A.
> 
> The DRBG implementation offers the following:
> 
> 	* All three DRBG types are implemented with a derivation function.
> 	* All DRBG types are available with and without prediction resistance.
> 	* All SHA types of SHA-1, SHA-256, SHA-384, SHA-512 are available
> 	  for the HMAC and Hash DRBGs.
> 	* All AES types of AES-128, AES-192 and AES-256 are available for the
> 	  CTR DRBG.
> 	* A self test is implemented with drbg_healthcheck().
> 	* The FIPS 140-2 continuous self test is implemented.
> 	* Additional cipher primitives, such as Serpent or Twofish, can be
> 	  added to the DRBG without changing the implementation. The only
> 	  change necessary is to the DRBG definition given in the cores[]
> 	  array.
> 
> As defined in SP800-131A, the ANSI X9.31 DRNG is to be sunset by the end of
> this year for official uses, including FIPS 140-2 compliance.
> 
> Additional tests including the CAVS test framework are available at [1].

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
