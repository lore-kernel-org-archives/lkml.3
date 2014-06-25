Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbaFYNsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:48:14 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:40627 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbaFYNsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:48:11 -0400
Date: Wed, 25 Jun 2014 21:48:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, alexandru.porosanu@freescale.com,
        horia.geanta@freescale.com, grant.likely@linaro.org,
        NiteshNarayanLal@freescale.com, thierry.reding@gmail.com,
        rob.herring@calxeda.com, kim.phillips@freescale.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] crypto:caam - Configuration for platforms with
 virtualization enabled in CAAM
Message-ID: <20140625134808.GB10379@gondor.apana.org.au>
References: <1403525553-17170-1-git-send-email-ruchika.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403525553-17170-1-git-send-email-ruchika.gupta@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 05:42:33PM +0530, Ruchika Gupta wrote:
> For platforms with virtualization enabled
> 
>     1. The job ring registers can be written to only is the job ring has been
>        started i.e STARTR bit in JRSTART register is 1
> 
>     2. For DECO's under direct software control, with virtualization enabled
>        PL, BMT, ICID and SDID values need to be provided. These are provided by
>        selecting a Job ring in start mode whose parameters would be used for the
>        DECO access programming.
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
