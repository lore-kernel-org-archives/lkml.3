Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3BDTq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:46:56 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:46779 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3BDTqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:46:53 -0500
MIME-Version: 1.0
In-Reply-To: <1358850393-23111-7-git-send-email-mika.westerberg@linux.intel.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
	<1358850393-23111-7-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 4 Feb 2013 20:46:53 +0100
Message-ID: <CACRpkdb3w9xbLMGdJLi+XjEoTM5afMmzGc3D0oojHpUNgiXztQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/10] spi/pxa2xx: add support for DMA engine
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:26 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> To be able to use DMA with this driver on non-PXA platforms we implement
> support for the generic DMA engine API. This lets user to use different DMA
> engines with little or no modification to the driver.
>
> Request lines and channel numbers can be passed to the driver from the
> platform specific data.
>
> The DMA engine implementation will be selected by default even on PXA
> platform. User can select the legacy DMA API by enabling Kconfig option
> CONFIG_SPI_PXA2XX_PXADMA.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Linus W, there haven't been any comments from Vinod/Dan about the alignment
> thing so I added a comment 'REVISIT: ..' so that we remember to change this
> once it has been sorted out. I hope that is OK for you.

This is OK and the kernel sure looks better *after* this patch than *before*
it, so it is a big step in the right direction in either case.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
