Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3FJNku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:40:50 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:44653 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3FJNkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:40:49 -0400
MIME-Version: 1.0
In-Reply-To: <201306101510.51961.heiko@sntech.de>
References: <201306090159.05383.heiko@sntech.de>
	<201306090201.17739.heiko@sntech.de>
	<CACRpkdaEcZZ3NZzwKOhUPjvFg+bSZ=UbpyPT2EBcAfVv1-EsKA@mail.gmail.com>
	<201306101510.51961.heiko@sntech.de>
Date: Mon, 10 Jun 2013 15:40:48 +0200
Message-ID: <CACRpkdY9xVWxvhQLM3AUq6XEOABNnHHPquJwtrcXRgLMVhoawA@mail.gmail.com>
Subject: Re: [EXAMPLE PATCH] pinctrl: add pinctrl driver for Rockchip SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 3:10 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Montag, 10. Juni 2013, 15:00:41 schrieb Linus Walleij:
>> On Sun, Jun 9, 2013 at 2:01 AM, Heiko Stübner <heiko@sntech.de> wrote:
>>
>> (...)
>>
>> > +#include <linux/irqchip/chained_irq.h>
>> > +#include <linux/clk-provider.h>
>> > +#include <dt-bindings/pinctrl/rockchip.h>
>>
>> Hm I don't know if we're supposed to do things like this actually.
>>
>> It depends on whether the <dt-bindings/*> hierarchy is supposed
>> to stay in the kernel after the device trees are moved out to a
>> separate repo.
>>
>> Grant/Rob, shall we do this in drivers?
>
> we can get rid of it, if it's controversial.

We'll wait and see what the others say.

There is no point in duplicating this info if it will
actually stay in the kernel.

Yours,
Linus Walleij
