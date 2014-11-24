Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaKXOsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:48:36 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:58090 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaKXOse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:48:34 -0500
Date: Mon, 24 Nov 2014 22:48:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: user - add MODULE_ALIAS
Message-ID: <20141124144827.GB31900@gondor.apana.org.au>
References: <1886949.maJD8yZxl6@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1886949.maJD8yZxl6@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 06:47:03AM +0100, Stephan Mueller wrote:
> To allow automatic loading of the crypto_user kernel module, the netlink
> MODULE_ALIAS is added.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Please resend your patches with a cc to the crypto mailing list.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
