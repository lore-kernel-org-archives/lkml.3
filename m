Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaKJOKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:10:42 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:59978 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaKJOKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:10:40 -0500
Date: Mon, 10 Nov 2014 22:10:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] crypto: ux500/cryp: Silence compiler warning for
 !CONFIG_PM
Message-ID: <20141110141034.GB9152@gondor.apana.org.au>
References: <1415280455-14056-1-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415280455-14056-1-git-send-email-ulf.hansson@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 02:27:35PM +0100, Ulf Hansson wrote:
> The system PM functions were unused when CONFIG_PM is unset. Let's move
> them inside CONFIG_PM_SLEEP to silence the compiler warning.
> 
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
