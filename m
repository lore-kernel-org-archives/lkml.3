Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3GTWYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 18:24:34 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:62261 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3GTWYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 18:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130719041952.GA29001@dev.danweeks.net>
References: <20130719041952.GA29001@dev.danweeks.net>
Date: Sun, 21 Jul 2013 00:24:32 +0200
Message-ID: <CACRpkdaGThdLU_1yN7NEBVtA=os8_nJaQ2n66HdY7t=CrrOjJA@mail.gmail.com>
Subject: Re: [PATCH] gpio-mcp23s08: i2c: auto-select base if no DT match or
 platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: "Daniel M. Weeks" <dan@danweeks.net>, Peter Korsgaard <jacmet@sunsite.dk>,
        Lars Poeschel <poeschel@lemonage.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 6:19 AM, Daniel M. Weeks <dan@danweeks.net> wrote:

> The call to gpiochip_add made by this driver is capable of auto-selecting a
> base if one is not provided. However, it was not called unless there was
> already a DT entry or platform data. This patch calls it even if the base is
> not already known so that gpiochip_add can attempt to find a usable base.
>
> Signed-off-by: Daniel M. Weeks <dan@danweeks.net>

Peter, Lars: you also contribute to this driver so can you folks have
a look at each others patches, e.g it'd be nice to have an ACK on this.

Yours,
Linus Walleij
