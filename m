Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbaJXOyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:54:32 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:38528 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaJXOy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:54:26 -0400
Date: Fri, 24 Oct 2014 22:54:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: drbg - use crypto_inc
Message-ID: <20141024145422.GB21055@gondor.apana.org.au>
References: <1838543.MpsGos9GAS@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1838543.MpsGos9GAS@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 09:50:13PM +0200, Stephan Mueller wrote:
> The DRBG internal buffer addition function is replaced with crypto_inc when
> a buffer is to be incremented by one.
> 
> The function drbg_add_buf is moved to the CONFIG_CRYPTO_DRBG_HASH ifdef
> area as it is now only needed for the Hash DRBG.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
