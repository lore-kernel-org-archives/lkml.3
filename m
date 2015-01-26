Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbbAZC4G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:56:06 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:46207 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbbAZC4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:56:02 -0500
Date: Mon, 26 Jan 2015 13:55:50 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Cristian Stoica <cristian.stoica@freescale.com>
Cc: Kim Phillips <kim.phillips@freescale.com>,
        Tudor Ambarus <tudor.ambarus@freescale.com>,
        linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, Horia Geanta <horia.geanta@freescale.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - don't emit ICV check failures to dmesg
Message-ID: <20150126025550.GD19796@gondor.apana.org.au>
References: <1414686811-6527-1-git-send-email-tudor.ambarus@freescale.com>
 <1414688107-8196-1-git-send-email-tudor.ambarus@freescale.com>
 <20141106151714.GE4544@gondor.apana.org.au>
 <20141204182245.f352ea22dc61ea6f65d85c62@freescale.com>
 <20141211193018.2465016d545334a76c0f4bab@freescale.com>
 <20150120124310.ba1dd7a6454f65255c1ed713@freescale.com>
 <54BF69FC.9040607@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BF69FC.9040607@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:57:32AM +0200, Cristian Stoica wrote:
> Hi Kim,
> 
> On 01/20/2015 08:43 PM, Kim Phillips wrote:
> > ICV check failures are part of normal operation;
> > leave user notification up to the higher levels,
> > as is done in s/w algorithm implementations.
> > 
> 
> Tested on P4080DS.
> 
> Tested-by: Cristian Stoica <cristian.stoica@freescale.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
