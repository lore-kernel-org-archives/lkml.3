Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbaFYNr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:47:57 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:34280 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbaFYNr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:47:56 -0400
Date: Wed, 25 Jun 2014 21:47:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, alexandru.porosanu@freescale.com,
        horia.geanta@freescale.com, grant.likely@linaro.org,
        NiteshNarayanLal@freescale.com, thierry.reding@gmail.com,
        rob.herring@calxeda.com, kim.phillips@freescale.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH][v4] crypto: caam - Correct definition of registers in
 memory map
Message-ID: <20140625134744.GA10379@gondor.apana.org.au>
References: <1403516308-22009-1-git-send-email-ruchika.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403516308-22009-1-git-send-email-ruchika.gupta@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 03:08:28PM +0530, Ruchika Gupta wrote:
> Some registers like SECVID, CHAVID, CHA Revision Number,
> CTPR were defined as 64 bit resgisters.  The IP provides
> a DWT bit(Double word Transpose) to transpose the two words when
> a double word register is accessed. However setting this bit
> would also affect the operation of job descriptors as well as
> other registers which are truly double word in nature.
> So, for the IP to work correctly on big-endian as well as
> little-endian SoC's, change is required to access all 32 bit
> registers as 32 bit quantities.
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
