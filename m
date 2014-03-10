Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaCJMWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:22:54 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:33248 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbaCJMWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:22:52 -0400
Date: Mon, 10 Mar 2014 20:22:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng
 sources
Message-ID: <20140310122228.GH10556@gondor.apana.org.au>
References: <20140303235148.GA7601@www.outflux.net>
 <20140306125533.GA1872@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306125533.GA1872@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 07:55:33AM -0500, Jason Cooper wrote:
> On Mon, Mar 03, 2014 at 03:51:48PM -0800, Kees Cook wrote:
> > When bringing a new RNG source online, it seems like it would make sense
> > to use some of its bytes to make the system entropy pool more random,
> > as done with all sorts of other devices that contain per-device or
> > per-boot differences.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/char/hw_random/core.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> 
> fwiw,
> 
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>

Patch applied.  Thanks everyone!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
