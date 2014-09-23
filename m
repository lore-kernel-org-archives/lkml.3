Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaIWPaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:30:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63874 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaIWPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:30:20 -0400
MIME-Version: 1.0
In-Reply-To: <1410936418-26443-1-git-send-email-anders.berg@avagotech.com>
References: <20140916183431.GX7960@sirena.org.uk>
	<1410936418-26443-1-git-send-email-anders.berg@avagotech.com>
Date: Tue, 23 Sep 2014 17:30:19 +0200
Message-ID: <CACRpkdZhhfLM027THE6Gb_QGf4+eswybH3kEun18XCznJcLH8g@mail.gmail.com>
Subject: Re: [PATCH v2] spi: pl022: Add support for chip select extension
From: Linus Walleij <linus.walleij@linaro.org>
To: Anders Berg <anders.berg@avagotech.com>
Cc: Mark Brown <broonie@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 8:46 AM, Anders Berg <anders.berg@avagotech.com> wrote:

> Add support for a extended PL022 which has an extra register for controlling up
> to five chip select signals. This controller is found on the AXM5516 SoC.
> Unfortunately the PrimeCell identification registers are identical to a
> standard ARM PL022. To work around this, the peripheral ID must be overridden
> in the device tree using the "arm,primecell-periphid" property with the value
> 0x000b6022.
>
> Signed-off-by: Anders Berg <anders.berg@avagotech.com>
> ---
>
> Adding Russell to Cc.
>
> Changelog:
>
> v2:
>     - added constant to <linux/amba/bus.h>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
