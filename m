Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967967Ab3E3Imy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:42:54 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:53374 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967932Ab3E3Imq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-27-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-27-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 10:42:46 +0200
Message-ID: <CACRpkdYzy-Nq5x=_tNweOTmTshkeswe0uk3c65bCOxFNCcYWZQ@mail.gmail.com>
Subject: Re: [PATCH 26/39] ARM: ux500: Add an auxdata entry for MUSB for
 clock-name look-up
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

> The recently DT:ed MUSB driver will require clock-name by device-name
> look-up capability, until common clk has is properly supported by the
> ux500 platform.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-devicetree branch.

Yours,
Linus Walleij
