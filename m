Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaJXMVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:21:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44737 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405AbaJXMVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:21:02 -0400
MIME-Version: 1.0
In-Reply-To: <97db7732f2fc24402a5be56f5ba19f00b7e2c66a.1413488264.git.stefan@agner.ch>
References: <cover.1413488264.git.stefan@agner.ch>
	<97db7732f2fc24402a5be56f5ba19f00b7e2c66a.1413488264.git.stefan@agner.ch>
Date: Fri, 24 Oct 2014 14:21:01 +0200
Message-ID: <CACRpkdYB8MEhSXiiRBbZeMdj_+ts9XU8VFy=sYM0wbe9qJznuQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] gpio: vf610: add gpiolib/IRQ chip driver for Vybrid
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

On Thu, Oct 16, 2014 at 9:47 PM, Stefan Agner <stefan@agner.ch> wrote:

> Add a gpiolib and IRQ chip driver for Vybrid ARM SoC using the
> Vybrid's GPIO and PORT module. The driver is instanced once per
> each GPIO/PORT module pair and handles 32 GPIO's.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Acked-by: Shawn Guo <shawn.guo@freescale.com>

Patch applied to the GPIO tree.

Yours,
Linus Walleij
