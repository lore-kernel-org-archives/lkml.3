Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3HAAsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:48:05 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:46316 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750773Ab3HAAsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:48:03 -0400
Date: Thu, 1 Aug 2013 10:47:59 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Cristian Stoica <cristian.stoica@freescale.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, horia.geanta@freescale.com
Subject: Re: [PATCH] crypto: remove double execution of the same test suite
Message-ID: <20130801004757.GA24286@gondor.apana.org.au>
References: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374163027-17201-1-git-send-email-cristian.stoica@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 06:57:07PM +0300, Cristian Stoica wrote:
> This patch removes redundant execution of the same test suite in cases
> where alg and driver variables are the same (e.g. when alg_test is
> called from tcrypt_test)
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Which algorithm (apart from crc* which I know and will fix) uses the
same driver name as its algorithm name? Doing this will cause issues
when an alternative implementation for that algorithm gets added.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
