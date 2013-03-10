Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3CJKOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:14:46 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:36370 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732Ab3CJKOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:14:44 -0400
Date: Sun, 10 Mar 2013 18:14:32 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Nicolas Royer <nicolas@eukrea.com>
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, plagnioj@jcrosoft.com, eric@eukrea.com
Subject: Re: [PATCH 1/4 v4] ARM: AT91SAM9G45: same platform data structure
 for all crypto peripherals
Message-ID: <20130310101432.GA10910@gondor.apana.org.au>
References: <1361376626-28987-1-git-send-email-nicolas@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1361376626-28987-1-git-send-email-nicolas@eukrea.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 05:10:23PM +0100, Nicolas Royer wrote:
> Only AES use DMA in AT91SAM9G45 (TDES and SHA use PDC).
> 
> However latest Atmel TDES and SHA IP releases use DMA instead of PDC.
>   --> Atmel TDES and SHA drivers need DMA platform data for those IP releases.
> 
> Goal of this patch is to use the same platform data structure for all Atmel
> crypto peripherals. This structure contains information about DMA interface.
> 
> Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Eric Bénard <eric@eukrea.com>
> Tested-by: Eric Bénard <eric@eukrea.com>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
