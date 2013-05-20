Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3ETMBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:01:19 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:50299 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3ETMBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:01:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130516105959.GI3269@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-3-git-send-email-lee.jones@linaro.org>
	<20130516063546.GD14863@intel.com>
	<20130516072557.GD3269@gmail.com>
	<20130516094014.GJ14863@intel.com>
	<20130516105959.GI3269@gmail.com>
Date: Mon, 20 May 2013 14:01:06 +0200
Message-ID: <CACRpkdabfNb_KeRqNgQQ2fVpS-_8q26k697cFOwamDLugExrhA@mail.gmail.com>
Subject: Re: [PATCH 02/39] dmaengine: ste_dma40: Remove unnecessary call to d40_phy_cfg()
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
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

On Thu, May 16, 2013 at 12:59 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 16 May 2013, Vinod Koul wrote:
>
>> On Thu, May 16, 2013 at 08:25:57AM +0100, Lee Jones wrote:
>> > On Thu, 16 May 2013, Vinod Koul wrote:
>> >
>> > > On Wed, May 15, 2013 at 10:51:25AM +0100, Lee Jones wrote:
>> > > > All configuration left in d40_phy_cfg() is runtime configurable and
>> > > > there is already a call into it from d40_runtime_config(), so let's
>> > > > rely on that.
>> > > >
>> > > > Acked-by: Vinod Koul <vnod.koul@intel.com>
>> > > That needs up update!
>> >
>> > Ah, where did I get that from that?
>> >
>> > Was that my mistake, or was this in the MAINTAINERS file?
>> Certainly not in MAINTAINERS file :)
>
> My bad then, sorry.
>
> Linus,
>
> Would you be kind enough to fix it please, as it's in your tree now.

I've fixed it up!

Yours,
Linus Walleij
