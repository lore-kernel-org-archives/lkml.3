Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaIEIOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:14:10 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:52938 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaIEIOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:14:07 -0400
Date: Fri, 5 Sep 2014 16:13:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] DRBG: remove check for uninitialized DRBG handle
Message-ID: <20140905081357.GA13683@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au>
 <20140827133528.GA15871@gondor.apana.org.au>
 <2837552.tiNKQxI8Xu@myon.chronox.de>
 <1461606.SUPpCYm782@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461606.SUPpCYm782@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 07:11:20AM +0200, Stephan Mueller wrote:
> The drbg_healthcheck() contained a test to call the DRBG with an
> uninitialized DRBG cipher handle. As this is an inappropriate use of the
> kernel crypto API to try to generate random numbers before
> initialization, checks verifying for an initialized DRBG have been
> removed in previous patches.
> 
> Now, the drbg_healthcheck test must also be removed.
> 
> Changes V2: Added patch marker to email subject line.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
