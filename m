Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaLEQB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:01:58 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:58250 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaLEQBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:01:55 -0500
Date: Sat, 6 Dec 2014 00:01:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 1/5] crypto: AF_ALG: add user space interface for AEAD
Message-ID: <20141205160147.GA30388@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de>
 <4746255.Vltg6sM4x3@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4746255.Vltg6sM4x3@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 08:55:42PM +0100, Stephan Mueller wrote:
> AEAD requires the caller to specify the following information separate
> from the data stream. This information allows the AEAD interface handler
> to identify the AAD, ciphertext/plaintext and the authentication tag:
> 
>         * Associated authentication data of arbitrary length and
>           length
> 
>         * Length of authentication tag for encryption
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
