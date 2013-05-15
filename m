Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab3EOQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:56:24 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33221 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759541Ab3EOQ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:56:20 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-9-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-9-git-send-email-lee.jones@linaro.org>
Date: Wed, 15 May 2013 18:56:05 +0200
Message-ID: <CACRpkdZpx3=8dhGaZ9xW7vXTmvhi=OVE5vFCAW66-AnwV_i=rQ@mail.gmail.com>
Subject: Re: [PATCH 08/39] dmaengine: ste_dma40: Remove redundant address
 fetching function
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

> Addresses are now stored in local data structures and are easy to
> obtain, thus a specialist function used to fetch them is now surplus
> to requirement.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch tentatively applied, waiting for Vinod's ACK.

Yours,
Linus Walleij
