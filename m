Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaGJJAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:00:16 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:49602 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaGJJAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:00:13 -0400
Date: Thu, 10 Jul 2014 17:00:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Cristian Stoica <cristian.stoica@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ruchika Gupta <ruchika.gupta@freescale.com>,
        Garg Vakul-B16394 <vakul@freescale.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] crypto: caam - fix memleak in caam_jr module
Message-ID: <20140710090006.GB15621@gondor.apana.org.au>
References: <1404723161-30180-1-git-send-email-cristian.stoica@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404723161-30180-1-git-send-email-cristian.stoica@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 11:52:41AM +0300, Cristian Stoica wrote:
> This patch fixes a memory leak that appears when caam_jr module is unloaded.
> 
> Cc: <stable@vger.kernel.org> # 3.13+
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
