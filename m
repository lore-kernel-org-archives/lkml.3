Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaG0Oy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 10:54:29 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:48731 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaG0Oy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 10:54:27 -0400
Date: Sun, 27 Jul 2014 22:52:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 3/3] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20140727145254.GA2932@gondor.apana.org.au>
References: <1405169953-13695-1-git-send-email-clabbe.montjoie@gmail.com>
 <1405169953-13695-4-git-send-email-clabbe.montjoie@gmail.com>
 <20140724060054.GA6545@gondor.apana.org.au>
 <53D0E857.8000405@gmail.com>
 <20140724133823.GA9638@gondor.apana.org.au>
 <53D3B4B6.3000100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D3B4B6.3000100@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 04:01:26PM +0200, Corentin LABBE wrote:
>
> Even if it is undocumented, the hardware seems to support it.
> Since crypto_ahash_ctx is for a tfm, does ahash_request_ctx is the good place to store data ?
> (after a call to crypto_ahash_set_reqsize in cra_init)

Yes any hash state-related data should go into the request context.

> I have also seen export/import function, does I need to use it ?

Absolutely.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
