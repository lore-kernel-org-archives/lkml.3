Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaIZIwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:52:41 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:47396 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaIZIwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:52:38 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1411662961.git.stefan@agner.ch>
References: <cover.1411662961.git.stefan@agner.ch>
Date: Fri, 26 Sep 2014 10:52:37 +0200
Message-ID: <CACRpkdaOZ-mN3LrGKWzmtm0+SJaWdaz5LG5H9UYi_e9GQRvaDg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] vf610: Add GPIO support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bpringlemeir@nbsps.com, Lucas Stach <l.stach@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 6:37 PM, Stefan Agner <stefan@agner.ch> wrote:

> This 3rd version of the GPIO support for Vybrid now also includes
> the wakeup support which was part of the suspend/resume patchset
> I sent earlier this week.
>
> Changes in v3:

I've already applied patch 1/5.

However I had to fix conflicts against the development branch and
from patch 2/5 and onward there are even more conflicts, the most
obvious is that the driver is moved to drivers/pinctrl/freescale, but
there are other conflicts as well.

Can you please rebase patches 2-5 onto my "devel" branch from
the pin control tree and resend, also collect ACKs.
https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-pinctrl.git/log/?h=devel

I saw there was still discussion on 2/5 as well, but I'm ready
to merge anything ACKed by Shawn.

Yours,
Linus Walleij
