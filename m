Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaKQPJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:09:34 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:35176 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaKQPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:09:31 -0500
Date: Mon, 17 Nov 2014 23:09:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] crypto: prefix module autoloading with "crypto-"
Message-ID: <20141117150926.GA1968@gondor.apana.org.au>
References: <20141114213459.GA3832@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141114213459.GA3832@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 01:34:59PM -0800, Kees Cook wrote:
> This prefixes all crypto module loading with "crypto-" so we never run
> the risk of exposing module auto-loading to userspace via a crypto API,
> as demonstrated by Mathias Krause:
> 
> https://lkml.org/lkml/2013/3/4/70
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Sorry but this doesn't build for me:

  CC [M]  drivers/crypto/qat/qat_common/adf_ctl_drv.o
drivers/crypto/qat/qat_common/adf_ctl_drv.c:490:21: error: expected declaration specifiers or ‘...’ before string constant
make[3]: *** [drivers/crypto/qat/qat_common/adf_ctl_drv.o] Error 1
make[2]: *** [drivers/crypto/qat/qat_common] Error 2
make[1]: *** [drivers/crypto/qat] Error 2
make[1]: *** Waiting for unfinished jobs....

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
