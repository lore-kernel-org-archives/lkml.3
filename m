Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3KLS2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:28:00 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:40220 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753081Ab3KLS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:27:56 -0500
Date: Wed, 13 Nov 2013 02:27:46 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: Crypto Update for 3.13
Message-ID: <20131112182746.GA22711@gondor.apana.org.au>
References: <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au>
 <20120106041250.GA7759@gondor.apana.org.au>
 <20121004095357.GA11777@gondor.apana.org.au>
 <20121214103156.GA5840@gondor.apana.org.au>
 <20130223023331.GA11002@gondor.apana.org.au>
 <20130907035544.GA22658@gondor.apana.org.au>
 <20131107080131.GA32307@gondor.apana.org.au>
 <20131112164151.GA22645@gondor.apana.org.au>
 <20131112165934.GA13441@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112165934.GA13441@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 05:59:34PM +0100, Borislav Petkov wrote:
> On Wed, Nov 13, 2013 at 12:41:52AM +0800, Herbert Xu wrote:
> > Hi Linus:
> > 
> > Here is the crypto update for 3.13:
> > 
> > * Made x86 ablk_helper generic for ARM.
> > * Phase out chainiv in favour of eseqiv (affects IPsec).
> > * Fixed aes-cbc IV corruption on s390.
> > * Added constant-time crypto_memneq which replaces memcmp.
> > 
> > * Fixed aes-ctr in omap-aes.
> > * Added OMAP3 ROM RNG support.
> > * Add PRNG support for MSM SoC's
> > * Add and use Job Ring API in caam.
> > 
> > * Misc fixes.
> 
> Maybe add this one to that:
> 
> http://marc.info/?l=linux-kernel&m=138078878205385&w=2
> 
> ?

I think this should probably go through James Morris's tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
