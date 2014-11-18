Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaKROXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:23:14 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:34139 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaKROKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:19 -0500
Date: Tue, 18 Nov 2014 22:10:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 06/10] crypto: AF_ALG: make setkey optional
Message-ID: <20141118141013.GC12100@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2196615.OgfUNzPKdf@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2196615.OgfUNzPKdf@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 03:26:58AM +0100, Stephan Mueller wrote:
> The current AF_ALG implementation requires that a userspace interface
> implementation must provide a callback for setkey. Such a call is not
> appliable to random number generators.
> 
> To prepare AF_ALG for the addition of a random number generator user
> space interface, this function callback invocation is made optional.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Did you actually try this? AFAICS setkey is already optional.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
