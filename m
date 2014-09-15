Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaIOLq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:46:59 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:45301 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaIOLq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:46:58 -0400
Date: Mon, 15 Sep 2014 19:46:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nitesh Narayan Lal <b44382@freescale.com>
Cc: linux-crypto@vger.kernel.org, vakul@freescale.com, davem@davemloft.net,
        alexandru.porosanu@freescale.com, horia.geanta@freescale.com,
        kim.phillips@freescale.com, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org, Ruchika Gupta <r66431@freescale.com>
Subject: Re: [PATCH] crypto: caam - Dynamic allocation of addresses for
 various memory blocks in CAAM.
Message-ID: <20140915114643.GA4923@gondor.apana.org.au>
References: <1409563844-5477-1-git-send-email-b44382@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409563844-5477-1-git-send-email-b44382@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 03:00:44PM +0530, Nitesh Narayan Lal wrote:
> CAAM's memory is broken into following address blocks:
> Block           Included Registers
> 0               General Registers
> 1-4             Job ring registers
> 6               RTIC registers
> 7               QI registers
> 8               DECO and CCB
> 
> Size of the above stated blocks varies in various platforms. The block size can be 4K or 64K.
> The block size can be dynamically determined by reading CTPR register in CAAM.
> This patch initializes the block addresses dynamically based on the value read from this register.
> 
> Signed-off-by: Ruchika Gupta <r66431@freescale.com>
> Signed-off-by: Nitesh Narayan Lal <b44382@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
