Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab3DYLtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:49:10 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63152 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab3DYLtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:49:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130419122428.GC3432@gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-2-git-send-email-lee.jones@linaro.org>
	<20130419122428.GC3432@gmail.com>
Date: Thu, 25 Apr 2013 13:49:06 +0200
Message-ID: <CACRpkdYrCA6SduwMJF=7C9hyjP2Or7gxhjVFtLshdzkbYnxX1w@mail.gmail.com>
Subject: Re: [PATCH 1/9 v2] crypto: ux500/hash - Prepare clock before enabling it
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 2:24 PM, Lee Jones <lee.jones@linaro.org> wrote:
> Slight change of plan for v2.
>
> Now we're doing a seperate clk_prepare(), as the clk_enable() in the
> previous patch turned out to be called inside a spin_lock().
>
> Arnd, can you confirm your Ack please?

Do you really want letters to Arnd to be part of the commit log?

>
> ---

Note: stuff following the three dashes (---) will be *omitted*
from the change log. This seems to be turned upside-down.

>
> crypto: ux500/hash - Prepare clock before enabling it
>
> If we fail to prepare the ux500-hash clock before enabling it the
> platform will fail to boot. Here we insure this happens.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Pls include Ulf Hansson <ulf.hansson@linaro.org> on this patch.

Yours,
Linus Walleij
