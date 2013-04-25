Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab3DYL5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:57:54 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58224 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab3DYL5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130419122226.GB3432@gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-5-git-send-email-lee.jones@linaro.org>
	<20130419122226.GB3432@gmail.com>
Date: Thu, 25 Apr 2013 13:57:50 +0200
Message-ID: <CACRpkdZT-XFyDExKVppWi4NEN7XptSex10LCtAHOpZD71nom3g@mail.gmail.com>
Subject: Re: [PATCH 4/9 v2] crypto: ux500/cryp - Prepare clock before enabling it
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
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 2:22 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Slight change of plan for v2.
>
> Now we're doing a seperate clk_prepare(), as the clk_enable() in the
> previous patch turned out to be called inside a spin_lock().
>
> Arnd, can you confirm your Ack please?
>
> ----
>
> crypto: ux500/cryp - Prepare clock before enabling it
>
> If we fail to prepare the ux500-cryp clock before enabling it the
> platform will fail to boot. Here we insure this happens.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Same formatting problems as the other prepare/enable
patch. Include Ulf Hansson.

(Apart from this it looks OK.)

Yours,
Linus Walleij
