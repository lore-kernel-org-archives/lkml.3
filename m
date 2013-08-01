Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3HABrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:47:15 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:41058 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690Ab3HABrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:47:14 -0400
Date: Thu, 1 Aug 2013 11:47:09 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Cc: linuxppc-dev@linux.freescale.net, "David S. Miller" <davem@davemloft.net>,
        Alex Porosanu <alexandru.porosanu@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Vakul Garg <vakul@freescale.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - RNG instantiation by directly programming
 DECO
Message-ID: <20130801014709.GB24286@gondor.apana.org.au>
References: <1372917363-25422-1-git-send-email-ruchika.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372917363-25422-1-git-send-email-ruchika.gupta@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 11:26:03AM +0530, Ruchika Gupta wrote:
> Remove the dependency of RNG instantiation on Job Ring. Now
> RNG instantiation for devices with RNG version > 4 is done
> by directly programming DECO 0.
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
