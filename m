Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab3HNKou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:44:50 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:56748 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759794Ab3HNKos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:44:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,876,1367964000"; 
   d="scan'208";a="29336924"
Date: Wed, 14 Aug 2013 12:44:28 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH 1/2] arch/x86/crypto/camellia_glue.c: adjust code
 alignment
In-Reply-To: <20130814104122.GA12970@gondor.apana.org.au>
Message-ID: <alpine.DEB.2.02.1308141243520.2257@hadrien>
References: <1376156077-6208-1-git-send-email-Julia.Lawall@lip6.fr> <1376156077-6208-2-git-send-email-Julia.Lawall@lip6.fr> <20130814104122.GA12970@gondor.apana.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Aug 2013, Herbert Xu wrote:

> On Sat, Aug 10, 2013 at 07:34:36PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Adjust alignment in automatically generated code.  If this code
> > will not be regenerated in the future, it may as well look nice.
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> > This patch was generated from the result of the previous one, which
> > replaced commas by semicolons.
>
> Please fold this patch into the original one.

OK, I will do that.  There is a second patch for another camellia file
that is in the same situation.  I will send new versions of both.

thanks,
julia
