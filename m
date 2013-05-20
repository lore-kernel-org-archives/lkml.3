Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3ETMP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:15:26 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52486 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3ETMPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-19-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-19-git-send-email-lee.jones@linaro.org>
Date: Mon, 20 May 2013 14:15:23 +0200
Message-ID: <CACRpkdYUAFm4G1R=0u_c8rFH1ke5n67E_POf0wysQKVmX2pD7Q@mail.gmail.com>
Subject: Re: [PATCH 18/39] crypto: ux500/[cryp|hash] - Show successful
 start-up in the bootlog
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Andreas Westin <andreas.westin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The Cryp driver is currently silent and the Hash driver prints the
> name of its probe function unnecessarily. Let's just put a nice
> descriptive one-liner there instead.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied with Herbert's ACK.

Thanks,
Linus Walleij
