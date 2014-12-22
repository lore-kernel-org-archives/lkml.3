Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaLVMFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 07:05:12 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:49608 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaLVMFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:05:10 -0500
Date: Mon, 22 Dec 2014 23:05:03 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 2/8] crypto: AF_ALG: add setsockopt for auth tag size
Message-ID: <20141222120503.GC21045@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
 <5195949.2IIqD2tWoo@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5195949.2IIqD2tWoo@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 11:21:42PM +0100, Stephan Mueller wrote:
> Use setsockopt on the tfm FD to provide the authentication tag size for
> an AEAD cipher. This is achieved by adding a callback function which is
> intended to be used by the AEAD AF_ALG implementation.
> 
> The optlen argument of the setsockopt specifies the authentication tag
> size to be used with the AEAD tfm.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
