Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3KTLSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:18:38 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:50535 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858Ab3KTLSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:18:36 -0500
Date: Wed, 20 Nov 2013 19:18:23 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric@eukrea.com
Subject: Re: [PATCH RESEND 0/7] crypto: at91/atmel: add Device Tree support
Message-ID: <20131120111823.GA20591@gondor.apana.org.au>
References: <cover.1383922546.git.nicolas.ferre@atmel.com>
 <528C924E.50206@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528C924E.50206@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:43:26AM +0100, Nicolas Ferre wrote:
> On 08/11/2013 16:08, Nicolas Ferre :
> >This series adds Device Tree support to the Atmel crypto drivers
> >(AES/[T]DES/SHA). The Device Tree entries are very simple and only
> >declare the reg/irq values and the link to DMA.
> 
> Herbert,
> 
> ping?
> 
> Could I have your "Acked-by" for taking these patches through the
> arm-soc git tree, or do you want that we split this series so that
> you can take the driver part of it?

Sure please push them through the arm-soc tree.

You can add my ack:

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
