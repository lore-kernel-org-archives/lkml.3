Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078Ab3ECUAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:00:37 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:51670 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3ECUAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-11-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-11-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:00:36 +0200
Message-ID: <CACRpkdYmuyj7tpnykUcdbjw4zjWvuLN3UBsnFc7dG=OpaEVfcA@mail.gmail.com>
Subject: Re: [PATCH 10/63] dmaengine: ste_dma40: Amalgamate DMA source and
 destination channel numbers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Devices which utilise DMA use the same device numbers for transmitting
> and receiving. In this patch we encode the source and destination
> information into one single attribute. We can subsequently exploit the
> direction attribute to see which of the transfer directions are being
> described. This also lessens the burden on platform data.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my ux500-dma40 branch!

Thanks,
Linus Walleij
