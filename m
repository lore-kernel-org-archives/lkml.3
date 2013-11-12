Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3KLRAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:00:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41825 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab3KLQ77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:59:59 -0500
Date: Tue, 12 Nov 2013 17:59:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 3.13
Message-ID: <20131112165934.GA13441@pd.tnic>
References: <20110520235409.GA1722@gondor.apana.org.au>
 <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20131112164151.GA22645@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131112164151.GA22645@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 12:41:52AM +0800, Herbert Xu wrote:
> Hi Linus:
> 
> Here is the crypto update for 3.13:
> 
> * Made x86 ablk_helper generic for ARM.
> * Phase out chainiv in favour of eseqiv (affects IPsec).
> * Fixed aes-cbc IV corruption on s390.
> * Added constant-time crypto_memneq which replaces memcmp.
> 
> * Fixed aes-ctr in omap-aes.
> * Added OMAP3 ROM RNG support.
> * Add PRNG support for MSM SoC's
> * Add and use Job Ring API in caam.
> 
> * Misc fixes.

Maybe add this one to that:

http://marc.info/?l=linux-kernel&m=138078878205385&w=2

?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
