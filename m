Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaJOH1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:27:37 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54817 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaJOH1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <d978829094e6a287415dc1baeabb0aed2799aafc.1411731755.git.stefan@agner.ch>
References: <cover.1411731755.git.stefan@agner.ch>
	<d978829094e6a287415dc1baeabb0aed2799aafc.1411731755.git.stefan@agner.ch>
Date: Wed, 15 Oct 2014 09:27:35 +0200
Message-ID: <CACRpkdY2m+rvKzHGcZ8b=JMBCWQfjj_Bfucu4hFNGpianz4TJw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] gpio: vf610: add gpiolib/IRQ chip driver for Vybrid
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Shawn Guo <shawn.guo@freescale.com>, Alexandre Courbot <gnurou@gmail.com>,
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

On Fri, Sep 26, 2014 at 1:57 PM, Stefan Agner <stefan@agner.ch> wrote:

> Add a gpiolib and IRQ chip driver for Vybrid ARM SoC using the
> Vybrid's GPIO and PORT module. The driver is instanced once per
> each GPIO/PORT module pair and handles 32 GPIO's.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Acked-by: Shawn Guo <shawn.guo@freescale.com>

I'd like to apply this after the merge window, can you
please rebase it to my GPIO tree on the "devel" branch
or use Torvalds' HEAD?

Yours,
Linus Walleij
