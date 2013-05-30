Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967992Ab3E3IwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:52:20 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:43054 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967933Ab3E3IwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:52:13 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-31-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-31-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 10:52:13 +0200
Message-ID: <CACRpkdZfw9ACS9=Nx9NuQqca_cvrdYwNOSWfpigMU1x94goZcA@mail.gmail.com>
Subject: Re: [PATCH 30/39] ARM: ux500: Replace ST-E's home-brew DMA direction
 definition with the generic one
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> STEDMA40_*_TO_* direction definitions are identical in all but name to
> the pre-defined generic DMA_*_TO_* ones. Let's make things easy by not
> duplicating such things.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Vinod, I'm lacking your ACK on this patch, but have tentatively
queued it anyway. Maybe you missed it?

Yours,
Linus Walleij
