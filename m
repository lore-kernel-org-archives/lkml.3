Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3EXG0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 02:26:06 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50820 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3EXG0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 02:26:04 -0400
MIME-Version: 1.0
In-Reply-To: <1368703646-26418-6-git-send-email-lee.jones@linaro.org>
References: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
	<1368703646-26418-6-git-send-email-lee.jones@linaro.org>
Date: Fri, 24 May 2013 08:26:04 +0200
Message-ID: <CACRpkdbfCyUNevTWzW5JzPoOY83j2vPgcPNg_hU=SDMp1GX-0g@mail.gmail.com>
Subject: Re: [PATCH 5/6] crypto: ux500/cryp - Enable DT probing of the driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 1:27 PM, Lee Jones <lee.jones@linaro.org> wrote:

> By providing an OF match table with a suitable compatible string, we
> can ensure the ux500-crypt driver is probed by supplying an associated
> DT node in a given platform's Device Tree.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/crypto/ux500/cryp/cryp_core.c |    6 ++++++

W00t! No binding document?

OK I guess it's just reg, irq ... but still it's compulsory,
right?

Yours,
Linus Walleij
