Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbaLVMEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 07:04:49 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:34792 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaLVMEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:04:47 -0500
Date: Mon, 22 Dec 2014 23:04:43 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [RESEND][PATCH] crypto: drbg - panic on continuous self test
 error
Message-ID: <20141222120443.GB21045@gondor.apana.org.au>
References: <1565261.ENnvzOKNx0@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565261.ENnvzOKNx0@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:40:21PM +0100, Stephan Mueller wrote:
> This patch adds a panic if the FIPS 140-2 self test error failed.
> Note, that entire code is only executed with fips_enabled (i.e. when the
> kernel is booted with fips=1. It is therefore not executed for 99.9% of
> all user base.
> 
> As mathematically such failure cannot occur, this panic should never be
> triggered. But to comply with NISTs current requirements, an endless
> loop must be replaced with the panic.
> 
> When the new version of FIPS 140 will be released, this entire
> continuous self test function will be ripped out as it will not be
> needed any more.
> 
> This patch is functionally equivalent as implemented in ansi_cprng.c and drivers/char/random.c.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
