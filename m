Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaKLORI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:17:08 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:39055 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaKLORG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:17:06 -0500
Date: Wed, 12 Nov 2014 22:17:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "'Sandy Harris'" <sandyinchina@gmail.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: zeroization of buffers
Message-ID: <20141112141700.GA28442@gondor.apana.org.au>
References: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 05:36:16AM +0100, Stephan Mueller wrote:
> Hi Herbert,
> 
> as discussed, these patches use the memzero_explicit function that is
> yet to be integrated into the cryptodev-2.6 tree.
> 
> Stephan Mueller (2):
>   crypto: AF_ALG - zeroize message digest buffer
>   crypto: AF_ALG - zeroize IV buffer
> 
>  crypto/algif_hash.c     | 2 ++
>  crypto/algif_skcipher.c | 1 +
>  2 files changed, 3 insertions(+)

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
