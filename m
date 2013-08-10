Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965972Ab3HJQ0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:26:03 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:64834
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964914Ab3HJQ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:26:00 -0400
X-IronPort-AV: E=Sophos;i="4.89,852,1367964000"; 
   d="scan'208";a="23673382"
Date: Sat, 10 Aug 2013 18:25:54 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 2/5] crypto/camellia_generic.c: convert comma to
 semicolon
In-Reply-To: <1376151557.2083.35.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1308101825220.2076@localhost6.localdomain6>
References: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>  <1376149225-3997-3-git-send-email-Julia.Lawall@lip6.fr> <1376151557.2083.35.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Aug 2013, Joe Perches wrote:

> On Sat, 2013-08-10 at 17:40 +0200, Julia Lawall wrote:
> > Replace a comma between expression statements by a semicolon.
> []
> > This patch is separate from the others because the code appears to be
> > machine-generated.
> 
> It may have once been machine generated, but it's not now.
> It's been modified several times by human generated patches.
> 
> > diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
> []
> > @@ -388,7 +388,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
> []
> > -	dw = subL[1] & subL[9],
> > +	dw = subL[1] & subL[9];
> >  		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl2) */
> 
> Perhaps you can (auto?) fix the indentation
> on the next line too?

OK, I'll take care of it.

julia
