Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaGWNyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:54:52 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:50596 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaGWNyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:54:50 -0400
Date: Wed, 23 Jul 2014 21:54:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk, davem@davemloft.net,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 3/3] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20140723135412.GA30046@gondor.apana.org.au>
References: <1405169953-13695-1-git-send-email-clabbe.montjoie@gmail.com>
 <1405169953-13695-4-git-send-email-clabbe.montjoie@gmail.com>
 <20140723131620.GC29178@gondor.apana.org.au>
 <20140723134857.GO20328@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723134857.GO20328@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 03:48:57PM +0200, Maxime Ripard wrote:
>
> The exact opposite has been asked for during v1's review...

Indeed but unfortunately it was bogus advice.  The async interface
brings with it a lot of complexity which should be avoided unless
you actually need it.

Even if you use the sync interface your driver will still be
available to all async users.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
