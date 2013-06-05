Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3FEIyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:54:41 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:33299 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752687Ab3FEIyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:54:39 -0400
Date: Wed, 5 Jun 2013 16:54:35 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hw_rng: nomadik: use clk_prepare_enable()
Message-ID: <20130605085435.GG12202@gondor.apana.org.au>
References: <1370217729-13699-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370217729-13699-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 02:02:09AM +0200, Linus Walleij wrote:
> The Nomadik HW RNG driver has seen some rust and is not preparing
> the clock before use. Fix this up so we get rid of runtime
> complaints from the clock subsystem.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
