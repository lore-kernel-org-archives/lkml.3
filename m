Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaCGBSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:18:13 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63548 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaCGBSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:18:11 -0500
MIME-Version: 1.0
In-Reply-To: <CANk1AXTZFKH45qmGip8sc5KYxHNwfZqogrPfXOzz+sz-xyuosw@mail.gmail.com>
References: <1393369261-17469-1-git-send-email-delicious.quinoa@gmail.com>
	<20140306135019.GF18529@joshc.qualcomm.com>
	<CANk1AXTZFKH45qmGip8sc5KYxHNwfZqogrPfXOzz+sz-xyuosw@mail.gmail.com>
Date: Fri, 7 Mar 2014 09:18:10 +0800
Message-ID: <CACRpkdZNLtdRjQ1bgQR7MULtovY0awOC+CuFF26NHcFtMc71xw@mail.gmail.com>
Subject: Re: [PATCH v12] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: delicious quinoa <delicious.quinoa@gmail.com>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
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

On Thu, Mar 6, 2014 at 11:58 PM, delicious quinoa
<delicious.quinoa@gmail.com> wrote:

> The fix is:
>
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 9979017..0e524d7 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -132,7 +132,7 @@ config GPIO_DWAPB
>         tristate "Synopsys DesignWare APB GPIO driver"
>         select GPIO_GENERIC
>         select GENERIC_IRQ_CHIP
> -       depends on OF_GPIO && IRQ_DOMAIN
> +       depends on OF_GPIO
>         help
>           Say Y or M here to build support for the Synopsys DesignWare APB
>           GPIO block.

OK I got this as a patch from Alan so it's fixed now.

Yours,
Linus Walleij
