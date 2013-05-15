Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab3EOQyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:54:21 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:54205 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759667Ab3EOQyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:54:19 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-8-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-8-git-send-email-lee.jones@linaro.org>
Date: Wed, 15 May 2013 18:54:18 +0200
Message-ID: <CACRpkdY97uS_ckSqy=Ta0SDrXrGmtDB4eL28_ZZPN5j--emr5A@mail.gmail.com>
Subject: Re: [PATCH 07/39] dmaengine: ste_dma40: Only use addresses passed as
 configuration information
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

> Addresses are passed in from the client's driver via the invocation of
> dmaengine_slave_config(), so there's no need to fetch them from platform
> data too, hardwired or otherwise. This is a great step forward, as it
> elevates a large burden from platform data in the way of a look-up
> table.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This should be the case even without patch 5 & 6 so patch tentatively
applied.

Waiting for Vinod's ACK on this though.

Yours,
Linus Walleij
