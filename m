Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763610Ab3ECVJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:09:18 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:50003 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3ECVJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-28-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-28-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 23:09:16 +0200
Message-ID: <CACRpkdZ_cnneFWtinO1dPz0Ky=29aKG=wHW447cHoE8Hnok=xA@mail.gmail.com>
Subject: Re: [PATCH 27/63] ARM: ux500: Pass remnant platform data though to
 DMA40 driver
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

> Ironically, in order to remove lots of the auxdata assignments, we have
> to add just one more. A lot of them require DMA information to be passed
> into clients for DMA channel allocation, but we now have this capability
> in Device Tree. However, the DMA40 driver still relies on a reverse table
> look-up to obtain DMA addresses. Until all of the clients are converted,
> over to the new API, we're stuck with this.
>
> Also, now the DMA40 has been DT:ed, there's no requirement to register
> it using traditional methods, so let's remove it.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-dma40 branch.

Thanks!
Linus Walleij
