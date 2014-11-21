Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbaKUCc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:32:29 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:32819 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbaKUCc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:32:27 -0500
Date: Fri, 21 Nov 2014 10:31:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: crypto: user - Allow get request with empty driver name
Message-ID: <20141121023131.GA3873@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2283056.kKnMJs7Bfg@tachyon.chronox.de>
 <20141120134029.GA31411@gondor.apana.org.au>
 <6655976.jRkjMUZ19x@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6655976.jRkjMUZ19x@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:08:42PM +0100, Stephan Mueller wrote:
> Am Donnerstag, 20. November 2014, 21:40:29 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Thu, Nov 20, 2014 at 02:10:00PM +0100, Stephan Mueller wrote:
> > > What about the following
> > > 
> > > if (p->cru_driver_name[0]
> 
> If the driver name is not empty
> > > 
> > > 	alg = crypto_alg_match(p, 1);
> 
> Do an exact match using the driver name
> > > 
> > > else
> > > 
> > > 	alg = crypto_alg_match(p, 0);
> 
> Otherise use the generic name for a fuzzy match.
> > 
> > If cru_driver_name is not empty then exact will never be used, no?
> 
> If the code suggestion does not follow my words outlined above, I want my 
> words to be considered ;-)
> 
> Yet, I am unsure where the code deviates from my words.

No I am asking how is this different from my patch?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
