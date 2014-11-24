Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaKXOrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:47:41 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59320 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKXOrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:47:40 -0500
Date: Mon, 24 Nov 2014 22:47:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v3] crypto: prefix module autoloading with "crypto-"
Message-ID: <20141124144734.GA31900@gondor.apana.org.au>
References: <20141121010553.GA5959@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121010553.GA5959@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:05:53PM -0800, Kees Cook wrote:
> This prefixes all crypto module loading with "crypto-" so we never run
> the risk of exposing module auto-loading to userspace via a crypto API,
> as demonstrated by Mathias Krause:
> 
> https://lkml.org/lkml/2013/3/4/70
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied.

For the template issue please create a patch on top of this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
