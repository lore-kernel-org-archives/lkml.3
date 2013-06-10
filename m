Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3FJNyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:54:22 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:43770 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3FJNyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <1370685946-3718-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1370685946-3718-1-git-send-email-maxime.ripard@free-electrons.com>
	<1370685946-3718-3-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 10 Jun 2013 15:54:20 +0200
Message-ID: <CACRpkdbDNSGSH-Y9_P4Bfpt3HhW0JBE7OWZt7of83=oLv_op7g@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: sunxi: Add external interrupts support
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 12:05 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The port controller IP found in the Allwinner A10 and A13 can use few of
> the pins it manage as an interrupt source, called external interrupts in
> the datasheet.
>
> The number of these external interrupts are SoCs specific, but the
> current upper limit is 32. In order to work, the external interrupts'
> pins have to be muxed to a specific function to generate an interrupt.
>
> This patch adds the irqchip and the needed logic to use the PIO
> controller as an interrupt controller.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Pretty complicated but I think I understand it at last...

Patch applied.

Yours,
Linus Walleij
