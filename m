Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab3E0Dos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 23:44:48 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:57898 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756175Ab3E0Doq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 23:44:46 -0400
Date: Mon, 27 May 2013 11:44:43 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the crypto tree
Message-ID: <20130527034443.GA16425@gondor.apana.org.au>
References: <20130521114548.a7bc47b2247f39ec40c44e33@canb.auug.org.au>
 <20130524095715.GA1410@gondor.apana.org.au>
 <20130527021917.GA16087@gondor.apana.org.au>
 <20130527134301.f5dcfe3a17ac9914e35fe2ca@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130527134301.f5dcfe3a17ac9914e35fe2ca@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 01:43:01PM +1000, Stephen Rothwell wrote:
> Hi Herbert,
> 
> On Mon, 27 May 2013 10:19:18 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Hi Stephen, did you get a chance to switch back to the current
> > cryptodev tree?
> 
> Not quite sure what you mean?  I fetch your tree every morning (that I
> build linux-next) so I got an update from you this morning.  I haven't
> got to merging and building it yet, but it looks good.

Great!

The reason I asked is because I got a build failure from the
kbuild robot over the weekend that was using a two-week old
version of cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
