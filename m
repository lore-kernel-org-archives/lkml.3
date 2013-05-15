Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729Ab3EORE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:04:29 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:37514 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610Ab3EORE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:04:28 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-11-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-11-git-send-email-lee.jones@linaro.org>
Date: Wed, 15 May 2013 19:04:27 +0200
Message-ID: <CACRpkdbQaB9adaCb6FR3XAMMK2AtDdzKfNb0WZZ8Gm5yQBiuVw@mail.gmail.com>
Subject: Re: [PATCH 10/39] dmaengine: ste_dma40: Correct copy/paste error
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

> 'struct stedma40_half_channel_info's header comment says that it's
> called 'struct stedma40_chan_cfg'. Let's straighten that out.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch tentatively applied waiting for Vinod's ACK.

Yours,
Linus Walleij
