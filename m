Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3ETMfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:35:04 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:56915 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3ETMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-11-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-11-git-send-email-lee.jones@linaro.org>
Date: Mon, 20 May 2013 14:35:01 +0200
Message-ID: <CACRpkdai7y+LBiFyK+b-CvW6p7n+TbC1iX0+XiLyg2V_8rFL+A@mail.gmail.com>
Subject: Re: [PATCH 10/63] dmaengine: ste_dma40: Amalgamate DMA source and
 destination channel numbers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
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

Still waiting for an ACK from Vinod on this as well.

Vinod?

Yours,
Linus Walleij
