Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab3FFUfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:35:23 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:62858 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3FFUfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:35:08 -0400
MIME-Version: 1.0
In-Reply-To: <201306062111.06694.heiko@sntech.de>
References: <201306062107.58875.heiko@sntech.de>
	<201306062111.06694.heiko@sntech.de>
Date: Thu, 6 Jun 2013 23:35:07 +0300
Message-ID: <CAHp75VdTYuXBu0Xu_BKZiBW9afjYprMBtBhSnNYjws-7b6hYmw@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] mmc: dw_mmc-pltfm: add Rockchip variant
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 10:11 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Cortex-A9 SoCs from Rockchip use a slightly modified variant of dw_mmc
> controllers that seems to require the SDMMC_CMD_USE_HOLD_REG bit to
> always be set.
>
> There also seem to be no other modifications (additional register etc)
> present, so to keep the footprint low, add this small variant to the
> pltfm driver.

My comments against v1 of this patch are still valid.

--
With Best Regards,
Andy Shevchenko
