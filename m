Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab3ECVMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:12:54 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41439 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934198Ab3ECVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-31-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-31-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 23:12:52 +0200
Message-ID: <CACRpkdbX_L_KAZqWWeGp1eVvUGBHgPX0cfr=zggsak+X3WNFzg@mail.gmail.com>
Subject: Re: [PATCH 30/63] ARM: ux500: Move SDI (MMC) and UART devices under
 more descriptive heading
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

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Now DMA DT bindings exist and are in use by he MMC and UART drivers, it
> should be possible to remove them from the auxdata structure. However,
> after doing so the drivers fail. Common clk is still reliant on the
> dev_name() call to do device name matching, which will fail due to the
> fact that Device Tree naming differs somewhat do the more traditional
> conventions.
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Can't apply this because of dependencies on the two previous
patches which also have dependencies.

Yours,
Linus Walleij
