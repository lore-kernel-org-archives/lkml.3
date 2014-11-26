Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaKZMKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:10:39 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57435 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaKZMKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:10:37 -0500
Date: Wed, 26 Nov 2014 20:10:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: drbg - use MODULE_ALIAS_CRYPTO
Message-ID: <20141126121034.GC16424@gondor.apana.org.au>
References: <1959971.EZA1ZTEOoi@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1959971.EZA1ZTEOoi@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 09:28:43AM +0100, Stephan Mueller wrote:
> Use the crypto- prefix for the DRBG implementations.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
