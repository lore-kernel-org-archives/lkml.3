Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875Ab3GEOzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:55:22 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:61308 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab3GEOzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:55:20 -0400
MIME-Version: 1.0
In-Reply-To: <201307051443.27172.heiko@sntech.de>
References: <201307051440.19428.heiko@sntech.de>
	<201307051443.27172.heiko@sntech.de>
Date: Fri, 5 Jul 2013 11:55:19 -0300
Message-ID: <CAOMZO5Af=iSZMLEQOrxGfMCSTbfs2K=7QoCvEpkHNMna1V0FfQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] ARM: rockchip: add smp bringup code
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 5, 2013 at 9:43 AM, Heiko Stübner <heiko@sntech.de> wrote:

> --- /dev/null
> +++ b/arch/arm/mach-rockchip/headsmp.S
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (c) 2013 MundoReader S.L.
> + * Author: Heiko Stuebner <heiko@sntech.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +
> +       __CPUINIT

This should go away after this commit:
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next-history.git/commit/arch/arm/common/mcpm_platsmp.c?id=c508abae89c3fa861c806ec00366d3b2f8d394cb
