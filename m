Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbbAGOhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:37:14 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:64252 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbbAGOhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:37:10 -0500
MIME-Version: 1.0
In-Reply-To: <2975078.sXsfBJkaoi@wuerfel>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
	<1420460348-20302-2-git-send-email-m.szyprowski@samsung.com>
	<2975078.sXsfBJkaoi@wuerfel>
Date: Wed, 7 Jan 2015 23:37:09 +0900
Message-ID: <CA+Ln22ECR_rCLz8VW0WYDNqa3xb0b-b4Em-8156wNR60GvB1cQ@mail.gmail.com>
Subject: Re: [PATCH v11 1/9] ARM: OMAP2+: use common l2cache initialization code
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Nishanth Menon <nm@ti.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Drake <drake@endlessm.com>, Jon Loeliger <loeliger@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Laura Abbott <lauraa@codeaurora.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-06 5:25 GMT+09:00 Arnd Bergmann <arnd@arndb.de>:
> On Monday 05 January 2015 13:19:00 Marek Szyprowski wrote:
>>  DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
>> +       .l2c_aux_val    = OMAP_L2C_AUX_CTRL,
>> +       .l2c_aux_mask   = 0xcf9fffff,
>> +       .l2c_write_sec  = omap4_l2c310_write_sec,
>>         .reserve        = omap_reserve,
>>         .smp            = smp_ops(omap4_smp_ops),
>>         .map_io         = omap4_map_io,
>>
>
> Could we also get those values into the dts files? Clearly we
> can't remove them here without breaking compatibility with old
> dtbs, but it would be nice to have all new dtbs do the right thing.

Sounds like a good next step after merging this series. :)

Best regards,
Tomasz
