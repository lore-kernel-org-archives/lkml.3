Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaKFPRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:17:49 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:44182 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaKFPRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:17:45 -0500
Date: Thu, 6 Nov 2014 23:17:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Cristian Stoica <cristian.stoica@freescale.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        kim.phillips@freescale.com, linux-kernel@vger.kernel.org,
        horia.geanta@freescale.com, marex@denx.de
Subject: Re: [PATCH v2] crypto: caam: fix error reporting
Message-ID: <20141106151740.GG4544@gondor.apana.org.au>
References: <20141104105731.ccb0eedea154b9bb6ed195b3@freescale.com>
 <1415179284-19791-1-git-send-email-cristian.stoica@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415179284-19791-1-git-send-email-cristian.stoica@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 11:21:24AM +0200, Cristian Stoica wrote:
> The error code returned by hardware is four bits wide with an expected
> zero MSB. A hardware error condition where the error code can get between
> 0x8 and 0xf will trigger an out of bound array access on the error
> message table.
> This patch fixes the invalid array access following such an error and
> reports the condition.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
