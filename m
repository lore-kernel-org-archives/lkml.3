Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbaISOdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:33:31 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:49146 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaISOda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:33:30 -0400
MIME-Version: 1.0
In-Reply-To: <1411134460.27173.8.camel@mtksdaap41>
References: <1411127306-13677-1-git-send-email-srv_hongzhou.yang@mediatek.com>
	<1411127306-13677-3-git-send-email-srv_hongzhou.yang@mediatek.com>
	<1411134460.27173.8.camel@mtksdaap41>
Date: Fri, 19 Sep 2014 16:33:28 +0200
Message-ID: <CABuKBeLF5gA7R5qVWEUdAWTxKA1feY7mSy5g98gpL18HWnvp0A@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: mediatek: Add Pinctrl/GPIO driver for mt8135.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: "Joe.C" <yingjoe.chen@mediatek.com>
Cc: srv_hongzhou.yang@mediatek.com, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        "=Sascha Hauer" <kernel@pengutronix.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-19 15:47 GMT+02:00 Joe.C <yingjoe.chen@mediatek.com>:
> On Fri, 2014-09-19 at 19:48 +0800, srv_hongzhou.yang@mediatek.com wrote:
>> +
>> +static const struct pinmux_ops mt_pmx_ops = {
>> +     .get_functions_count    = mt_pmx_get_funcs_cnt,
>> +     .get_function_name      = mt_pmx_get_func_name,
>> +     .get_function_groups    = mt_pmx_get_func_groups,
>> +     .enable                 = mt_pmx_enable,
>> +     .disable                = mt_pmx_disable,
>> +     .gpio_set_direction     = mt_pmx_gpio_set_direction,
>> +};
>> +
>
> It seems pinmux_ops.disable is removed in commit commit
> 2243a87d90b42eb38bc281957df3e57c712b5e56. So this will cause build
> error. This should be fixed in next version.

For this cases and in general it would be good to put in the patch set
description against which tree/tag the patches are build.

Thanks,
Matthias

>
> ../drivers/pinctrl/mediatek/pinctrl-mtk-common.c:566:2: error: unknown
> field 'disable' specified in initializer
> ../drivers/pinctrl/mediatek/pinctrl-mtk-common.c:566:2: warning:
> initialization from incompatible pointer type [enabled by default]
> ../drivers/pinctrl/mediatek/pinctrl-mtk-common.c:566:2: warning: (near
> initialization for 'mt_pmx_ops.gpio_request_enable') [enabled by
> default]
>
> Joe.C
>
>



-- 
motzblog.wordpress.com
