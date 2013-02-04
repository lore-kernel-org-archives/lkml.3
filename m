Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3BDNVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:21:30 -0500
Received: from sting.hengli.com.au ([178.18.18.71]:41277 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754143Ab3BDNV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:21:28 -0500
Date: Mon, 4 Feb 2013 21:21:21 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Miller <davem@davemloft.net>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/15] drivers/crypto/atmel-aes.c: adjust duplicate test
Message-ID: <20130204132121.GA21627@gondor.apana.org.au>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
 <1358773378-4700-8-git-send-email-Julia.Lawall@lip6.fr>
 <20130121.131912.602907116084738120.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121.131912.602907116084738120.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 01:19:12PM -0500, David Miller wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> Date: Mon, 21 Jan 2013 14:02:51 +0100
> 
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Delete successive tests to the same location.  The code tested the result
> > of a previous allocation, that itself was already tested.  It is changed to
> > test the result of the most recent allocation.
> > 
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
>  ...
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
