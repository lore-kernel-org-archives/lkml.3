Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbaKTOoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:44:25 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:40536 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbaKTOoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:44:22 -0500
Date: Thu, 20 Nov 2014 22:43:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mpm@selenic.com, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, peter@korsgaard.com
Subject: Re: [PATCH RESEND v2 0/4] hwrng: atmel: add DT support
Message-ID: <20141120144349.GC32061@gondor.apana.org.au>
References: <cover.1416475860.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1416475860.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:43:21AM +0100, Nicolas Ferre wrote:
> This is the patch series that Boris sent yesterday. I've just collected
> "Acked-by" tags and resend it with updated cover letter.
> 
> This series adds DT support for the TRNG (True Random Generator) block and adds
> missing trng nodes to at91sam9g45 dtsi files.
> 
> Herbert,
> As you said that you can take this series, here is the latest vertion ready for you to
> pick it up. Thanks for your help.
> 
> Bye,
> 
> Boris Brezillon (4):
>   hwrng: atmel: use clk_prepapre_enable/_disable_unprepare
>   hwrng: atmel: add DT support
>   hwrng: atmel: Add TRNG DT binding doc
>   ARM: at91/dt: add trng node to at91sam9g45

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
