Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3FKJkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:40:47 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61772 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3FKJkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:40:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130610091724.GG20297@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-7-git-send-email-lee.jones@linaro.org>
	<CACRpkdZ=NJR3VRNJE2pSTJ8t1VCMq+wjH_s0NOi4AHko3no_KA@mail.gmail.com>
	<20130610091724.GG20297@gmail.com>
Date: Tue, 11 Jun 2013 11:40:44 +0200
Message-ID: <CACRpkdbdH1No7RJbpFSgdmCkaLOD6irbo3mC9EfaLoT_Q+JedQ@mail.gmail.com>
Subject: Re: [PATCH 06/39] ARM: ux500: Move SDI (MMC) and UART devices under
 more descriptive heading
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

On Mon, Jun 10, 2013 at 11:17 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 15 May 2013, Linus Walleij wrote:
>
>> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > Now DMA DT bindings exist and are in use by he MMC and UART drivers, it
>> > should be possible to remove them from the auxdata structure. However,
>> > after doing so the drivers fail. Common clk is still reliant on the
>> > dev_name() call to do device name matching, which will fail due to the
>> > fact that Device Tree naming differs somewhat do the more traditional
>> > conventions.
>> >
>> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> Cannot be applied due to dependency on 5/39.
>
> I think this can be applied now (if it hasn't already).

I really need a clean mergebase for this to merge ...
This patch requires both the dma40 and devicetree
branches to land in a common place before it can be
applied.

I want the DMA40 branch to be closed down now as I
have sent all pull requests on it, so pls ping me again on
this when we have something in the ARM SoC tree we
can work on.

Yours,
Linus Walleij
