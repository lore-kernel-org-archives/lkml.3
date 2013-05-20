Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3ETM32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:29:28 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49915 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3ETM30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-24-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-24-git-send-email-lee.jones@linaro.org>
Date: Mon, 20 May 2013 14:29:26 +0200
Message-ID: <CACRpkdZQityADLQTcyLBzDsTNA18ij3c94qiFYFXKBQDQNFasQ@mail.gmail.com>
Subject: Re: [PATCH 23/63] dmaengine: ste_dma40: Also report the number of
 logical channels
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

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Now we know the total of physical and logical channels, we may as
> well report them within the information log.
>
> Before:
> dma40 dma40.0: hardware revision: 3 @ 0x801c0000 with 8 physical channels
>
> After:
> <as above ...> and 256 logical channels
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I'm missing Vinod's ACK on this before I can proceed with my
branch to ARM SoC.

Vinod?

Yours,
Linus Walleij
