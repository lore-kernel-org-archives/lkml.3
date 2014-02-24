Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaBXLxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:53:06 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:53898 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaBXLxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:53:05 -0500
MIME-Version: 1.0
In-Reply-To: <201402241117.48617.arnd@arndb.de>
References: <CACRpkdYeaMqTNUTqBSg6vNa9=VucjpFFkx3diHJJNgZTg+iq1w@mail.gmail.com>
	<201402241117.48617.arnd@arndb.de>
Date: Mon, 24 Feb 2014 12:53:03 +0100
Message-ID: <CACRpkdbtv2ZQbt0=7QhBZSRRAdONgKeKCO9yj=UwWRAU2WOWwA@mail.gmail.com>
Subject: Re: [GIT PULL] integrator base patches for v3.15
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:17 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 13 February 2014, Linus Walleij wrote:
>>       irqchip: vic: update the base IRQ member correctly
>>       irqchip: support cascaded VICs
>>       ARM: integrator: register the IM-PD1 VIC
>
> I got a randconfig build error for CONFIG_IMPD1=m. Ok to apply this
> fix on top?

Sure sorry for missing this ...

> 8<---
>
> irqchip: VIC: export vic_init_cascaded
>
> vic_init_cascaded is called by integrator impd1 code that can
> be a loadable module, so the function has to be exported.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Can either of you pls apply this directly to the ARM SoC tree?

Yours,
Linus Walleij
