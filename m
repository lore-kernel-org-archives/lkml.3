Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbaH0Nfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:35:42 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:60371 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933661AbaH0Nfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:35:40 -0400
Date: Wed, 27 Aug 2014 21:35:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] DRBG: fix maximum value checks on 32 bit systems
Message-ID: <20140827133528.GA15871@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au>
 <2049245.HpByroTSUp@myon.chronox.de>
 <20140826085853.GA4646@gondor.apana.org.au>
 <1471416.zGlxQVbHUr@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471416.zGlxQVbHUr@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 11:36:54AM +0200, Stephan Mueller wrote:
>
> The max_addtllen and max_req are defined in drbg_cores[] in crypto/drbg.c for 
> each DRBG type. As size_t on a 32 bit system is 32 bit the bit shifts would 
> not work either.
> 
> Thus, I am wondering whether the just applied patch would need to go to Linus 
> tree too? I would think that the following patch would be in order:

Have you actually tested this on a 32-bit box? If so and it
actually works then I'd be happy to push it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
