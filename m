Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3FDKui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:50:38 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45655 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3FDKuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:50:35 -0400
MIME-Version: 1.0
In-Reply-To: <1370267175-8117-1-git-send-email-lee.jones@linaro.org>
References: <1370267175-8117-1-git-send-email-lee.jones@linaro.org>
Date: Tue, 4 Jun 2013 12:50:29 +0200
Message-ID: <CACRpkdYE75qwqjaFGNgyJB+JuUFHf8rtRePW=sasi3jsX79jww@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Remove SSP AUXDATA pertaining to DMA bindings
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 3:46 PM, Lee Jones <lee.jones@linaro.org> wrote:

> These are now cared for from the Device Tree.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

These are not only used for the DMA bindings, so
the clock patches need to be finalized before this
patch I think...

git grep ssp0 drivers/clk/ux500/
drivers/clk/ux500/u8500_clk.c:  clk_register_clkdev(clk, "apb_pclk", "ssp0");
drivers/clk/ux500/u8500_clk.c:  clk =
clk_reg_prcc_kclk("p3_ssp0_kclk", "sspclk",
drivers/clk/ux500/u8500_clk.c:  clk_register_clkdev(clk, NULL, "ssp0");

Yours,
Linus Walleij
