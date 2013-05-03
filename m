Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539Ab3ECVAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:00:49 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:45228 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3ECVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:00:48 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaj0RcZUJ9DX8D1v-MKecFs6ZwGjqD2gqaSFvP9QCbgGA@mail.gmail.com>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-27-git-send-email-lee.jones@linaro.org>
	<CACRpkdaj0RcZUJ9DX8D1v-MKecFs6ZwGjqD2gqaSFvP9QCbgGA@mail.gmail.com>
Date: Fri, 3 May 2013 23:00:47 +0200
Message-ID: <CACRpkdbB6mN6XTyceCZO9j6rAPawdTijM11-ws-23tnamGYz5A@mail.gmail.com>
Subject: Re: [PATCH 26/63] dmaengine: ste_dma40: Supply full Device Tree
 parsing support
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 10:59 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> Using the new DMA DT bindings and API, we can register the DMA40 driver
>> as Device Tree capable. Now, when a client attempts to allocate a
>> channel using the DMA DT bindings via its own node, we are able to parse
>> the request and allocate a channel in the correct manner.
>>
>> Cc: Vinod Koul <vinod.koul@intel.com>
>> Cc: Dan Williams <djbw@fb.com>
>> Cc: Per Forlin <per.forlin@stericsson.com>
>> Cc: Rabin Vincent <rabin@rab.in>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> Applied to my ux500-dma40 branch.

But hmmm would be really nice to have Vinod's ACK on this
patch as well.

Yours,
Linus Walleij
