Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaJPNKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:10:23 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:41683 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaJPNKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:10:19 -0400
Date: Thu, 16 Oct 2014 21:10:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] kernel crypto API interface specification
Message-ID: <20141016131007.GA11517@gondor.apana.org.au>
References: <7502136.9BkWHTZ0th@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7502136.9BkWHTZ0th@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 09:46:50PM +0200, Stephan Mueller wrote:
> The update adds a complete interface documentation of the kernel crypto
> API. All cipher types supported by the kernel crypto API are documented.
> 
> In addition, kernel and user space example code is provided. The sample
> code covers synchronous and asynchronous cipher operation, random
> number generation and performing hashing as well as encryption and
> decryption in user space.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Thanks for the patch Stephan!

Marek Vasut <marex@denx.de> has also been working on a set of
documentation for the crypto API so he might have some comments
on this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
