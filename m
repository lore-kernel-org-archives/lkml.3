Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3FJNAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:00:42 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45956 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3FJNAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:00:41 -0400
MIME-Version: 1.0
In-Reply-To: <201306090201.17739.heiko@sntech.de>
References: <201306090159.05383.heiko@sntech.de>
	<201306090201.17739.heiko@sntech.de>
Date: Mon, 10 Jun 2013 15:00:41 +0200
Message-ID: <CACRpkdaEcZZ3NZzwKOhUPjvFg+bSZ=UbpyPT2EBcAfVv1-EsKA@mail.gmail.com>
Subject: Re: [EXAMPLE PATCH] pinctrl: add pinctrl driver for Rockchip SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 9, 2013 at 2:01 AM, Heiko Stübner <heiko@sntech.de> wrote:

(...)
> +#include <linux/irqchip/chained_irq.h>
> +#include <linux/clk-provider.h>
> +#include <dt-bindings/pinctrl/rockchip.h>

Hm I don't know if we're supposed to do things like this actually.

It depends on whether the <dt-bindings/*> hierarchy is supposed
to stay in the kernel after the device trees are moved out to a
separate repo.

Grant/Rob, shall we do this in drivers?

Yours,
Linus Walleij
