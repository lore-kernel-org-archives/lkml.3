Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbbANNP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:15:26 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58848 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbANNPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:15:24 -0500
MIME-Version: 1.0
In-Reply-To: <1421057279-16081-3-git-send-email-geert+renesas@glider.be>
References: <1421057279-16081-1-git-send-email-geert+renesas@glider.be>
	<1421057279-16081-3-git-send-email-geert+renesas@glider.be>
Date: Wed, 14 Jan 2015 14:15:23 +0100
Message-ID: <CACRpkdY8HEtm_t2h7vAAZNPZMxxhfSum9TrKTD3TnRRuTUS_7w@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: rcar: Switch to use gpiolib irqchip helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Alexandre Courbot <gnurou@gmail.com>, Magnus Damm <magnus.damm@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 11:07 AM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:

> Switch the R-Car Gen2 GPIO driver to use the gpiolib irqchip helpers.
>
> While doing this also make sure that gpiochip_irqchip_add() is called
> after the gpiochip itself is registered, as required.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Love it. Patch applied.

Yours,
Linus Walleij
