Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3DYJAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:00:25 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61497 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3DYJAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:00:23 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-13-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-13-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 11:00:22 +0200
Message-ID: <CACRpkdbu-e75rz+BgbfFH7nXMWMTzpFT=k2yhA80jJKv9jpzkQ@mail.gmail.com>
Subject: Re: [PATCH 12/32] ARM: ux500: Remove superfluous 'psize' attribute
 from Audio platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Ola LILJA2 <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> 'psize' is used to calculate the maximum DMA burst size. However it
> is only taken into consideration when editing the DMA channel's
> configuration. The Audio DMA platform data is only used to allocate
> a channel, not configure it. That will be done at a later date within
> the MSP driver.
>
> We're also removing comments which are no longer required, as
> 'data_width' is no longer set in any device's platform data period.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Pls CC patches like this to Ola LILJA.

So if I understand correctly this is now handled by
dmaengine_pcm.c, os that right?

Yours,
Linus Walleij
