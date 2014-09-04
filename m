Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaIDRcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:32:36 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:38548 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaIDRce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:32:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140904170630.GL29327@sirena.org.uk>
References: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
	<1409576021-24828-2-git-send-email-anders.berg@avagotech.com>
	<CACRpkdby4H-fivNn_kG2uL0EjsCGAc+t6OyFi0+VcNGf2Z9NQA@mail.gmail.com>
	<20140904170630.GL29327@sirena.org.uk>
Date: Thu, 4 Sep 2014 19:32:31 +0200
Message-ID: <CACRpkdZEoBan=Lqr1T-iY41U9NfMA_MCLX3LA=juw7X4pmRvSQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: Add driver for AXM55xx SSP chip selects
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Anders Berg <anders.berg@avagotech.com>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 7:06 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Sep 04, 2014 at 07:04:44PM +0200, Linus Walleij wrote:
>> I need an ACK from Mark Brown on this before I apply.
>> The driver seems to do what it should, but I need Mark to
>> be OK with exporting the CS signals from an SSP/SPI block
>> to be exposed to Linux as GPIOs.
>>
>> (Top-posting and quoting patch verbatim so Mark gets it.)
>
> I don't see any sort of reasoning for this?

Maybe there was some earlier, but this is an excellent opportunity
to repeat it... So Anders: why do you want to do this?

Yours,
Linus Walleij
