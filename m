Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaBXN3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:29:37 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41714 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaBXN3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:29:35 -0500
MIME-Version: 1.0
In-Reply-To: <1392049357-13225-1-git-send-email-wens@csie.org>
References: <1392049357-13225-1-git-send-email-wens@csie.org>
Date: Mon, 24 Feb 2014 14:29:35 +0100
Message-ID: <CACRpkdZXQMBTy4fW1R0pwSh40QJr=XkhwMp4nf_c0Rie16e0=w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sunxi: use chained_irq_{enter, exit} for GIC compatibility
From: Linus Walleij <linus.walleij@linaro.org>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Lanzendoerfer <david.lanzendoerfer@o2s.ch>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 5:22 PM, Chen-Yu Tsai <wens@csie.org> wrote:

> On tha Allwinner A20 SoC, the external interrupts on the pin controller
> device are connected to the GIC. Without chained_irq_{enter, exit},
> external GPIO interrupts, such as used by mmc core card detect, cause
> the system to hang.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Patch applied for fixes with Maxime's ACK.

Yours,
Linus Walleij
