Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab3DYMD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:03:59 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:33143 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3DYMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:03:58 -0400
MIME-Version: 1.0
In-Reply-To: <1366280825-31136-9-git-send-email-lee.jones@linaro.org>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-9-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 14:03:57 +0200
Message-ID: <CACRpkdYLQtdqCmJ_tt=1DtNeeZVWkL+S6tBG74Li9kOkU25b4A@mail.gmail.com>
Subject: Re: [PATCH 8/9] crypto: ux500/[cryp|hash] - Show successful start-up
 in the bootlog
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

On Thu, Apr 18, 2013 at 12:27 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The Cryp driver is currently silent and the Hash driver prints the
> name of its probe function unnecessarily. Let's just put a nice
> descriptive one-liner there instead.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
