Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaCJMVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:21:23 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:55195 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaCJMVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:21:22 -0400
Date: Mon, 10 Mar 2014 20:21:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Peter Korsgaard'" <jacmet@sunsite.dk>
Subject: Re: [PATCH 1/5] hwrng: atmel - Use devm_clk_get()
Message-ID: <20140310122114.GC10556@gondor.apana.org.au>
References: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 02:00:09PM +0900, Jingoo Han wrote:
> Use devm_clk_get() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
