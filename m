Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaKZMKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:10:25 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:50115 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaKZMKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:10:24 -0500
Date: Wed, 26 Nov 2014 20:10:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org,
        linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: user - add MODULE_ALIAS
Message-ID: <20141126121011.GA16424@gondor.apana.org.au>
References: <2012632.fnfABE5hEY@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2012632.fnfABE5hEY@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 05:12:45PM +0100, Stephan Mueller wrote:
> To allow automatic loading of the crypto_user kernel module, the netlink
> MODULE_ALIAS is added.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
