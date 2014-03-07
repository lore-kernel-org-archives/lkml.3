Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaCGBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:16:58 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:55490 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaCGBQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:16:55 -0500
MIME-Version: 1.0
In-Reply-To: <1394134180-23208-1-git-send-email-delicious.quinoa@gmail.com>
References: <1394134180-23208-1-git-send-email-delicious.quinoa@gmail.com>
Date: Fri, 7 Mar 2014 09:16:54 +0800
Message-ID: <CACRpkdY8tXpah5DNUKMEqHTRKY-y8U=stH6wJOEcR8hK7dpniw@mail.gmail.com>
Subject: Re: [PATCH] fix build error in gpio-dwapb patch
From: Linus Walleij <linus.walleij@linaro.org>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 3:29 AM, Alan Tull <delicious.quinoa@gmail.com> wrote:

> From: Alan Tull <atull@altera.com>
>
> fix build error with this message:
> kernel/irq/Kconfig:41:error: recursive dependency detected!
> kernel/irq/Kconfig:41:  symbol GENERIC_IRQ_CHIP is selected by GPIO_DWAPB
> drivers/gpio/Kconfig:131:       symbol GPIO_DWAPB depends on IRQ_DOMAIN
> kernel/irq/Kconfig:46:  symbol IRQ_DOMAIN is selected by GENERIC_IRQ_CHIP
>
> Signed-off-by: Alan Tull <atull@altera.com>

Patch applied, thanks a lot Alan!

Yours,
Linus Walleij
