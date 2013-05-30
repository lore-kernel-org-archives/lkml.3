Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968018Ab3E3I4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:56:13 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59054 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967933Ab3E3I4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:56:08 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-33-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-33-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 10:56:07 +0200
Message-ID: <CACRpkdY1XOGPz19ftH2yZFG6-_Ww3bVqrsDvRZGk60gzuu0Maw@mail.gmail.com>
Subject: Re: [PATCH 32/39] ARM: ux500: Remove recently unused
 stedma40_xfer_dir enums
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

> We're now using the transfer direction definitions provided by the DMA
> sub-system, so the home-brew ones have become obsolete.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Tentatively applied, also missing Vinod's ACK on this, but it seems
it was implicitly ACKed in the discussion on patch 31.

Yours,
Linus Walleij
