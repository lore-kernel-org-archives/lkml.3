Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbaJaJgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:36:20 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:43118 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351AbaJaJgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:36:19 -0400
Date: Fri, 31 Oct 2014 17:36:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: pseries - port to new read API and fix stack
 corruption
Message-ID: <20141031093609.GA8454@gondor.apana.org.au>
References: <20141031063233.1884.86309.stgit@bahia.local>
 <1414738812.21815.5.camel@concordia>
 <20141031103141.7b91c647@bahia.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031103141.7b91c647@bahia.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 10:31:41AM +0100, Greg Kurz wrote:
>
> > > Cc'ing stable as I could reproduce back to 3.15.10
> > 
> > The right way to CC stable for a patch that isn't yet in upstream is to add:
> > 
> > CC: stable@vger.kernel.org
> > 
> > Before your Signed-off-by. They will then pick it up once it's merged into
> > Linus' tree. See Documentation/stable_kernel_rules.txt
> > 
> > cheers
> > 
> 
> Oops... should I repost then ?

Don't worry, I can fix this up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
