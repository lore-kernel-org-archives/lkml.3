Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329Ab3ECUCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:02:21 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42250 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3ECUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-12-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-12-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:02:19 +0200
Message-ID: <CACRpkdZ4ufprKp4P9p+Np-omi1on8BDTO0q9DONHtk7gGxczMw@mail.gmail.com>
Subject: Re: [PATCH 11/63] ARM: ux500: Strip out duplicate USB DMA configuration
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

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> For the moment at least, the TX and RX channels for DB8500 USB are
> identical, so this patch generalises them into a single structure
> and passes it twice. Once as the TX and again for the RX configuration.
> We're keeping the infrastructure the same i.e. passing the TX and RX
> separately in case they start to differ on latter incarnations of the
> platform.
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my ux500-dma40 branch.

Thanks!
Linus Walleij
