Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab3EORDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:03:14 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:41133 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab3EORDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:03:11 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-10-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-10-git-send-email-lee.jones@linaro.org>
Date: Wed, 15 May 2013 19:03:10 +0200
Message-ID: <CACRpkdasU0a_T5rwvRah0VpddrOGardLQkNCMRngUdxOUnSH7A@mail.gmail.com>
Subject: Re: [PATCH 09/39] ARM: ux500: Remove DMA address look-up table
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
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> DMA addresses are now passed as part of the dmaengine API by invoking
> dmaengine_slave_config(). So there's no requirement for the DMA40
> driver to look them up in a table provided by platform data. This
> method does not fit in well using Device Tree either.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Good riddance. Patch tentatively applied.
Awaiting Vinod's ACK for include/platform_data/*.

Yours,
Linus Walleij
