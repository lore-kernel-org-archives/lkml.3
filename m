Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3JRP7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:59:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50030 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab3JRP7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:59:45 -0400
Message-ID: <52615AD4.7040306@ti.com>
Date: Fri, 18 Oct 2013 21:29:16 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Roger Quadros <rogerq@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc28=?= =?UTF-8?B?bg==?= 
	<bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
References: <20131010160018.GA29913@atomide.com> <CACRpkdaG-PQA39XSjKUgM9TyeD7srgm_8s+NazrDKJ0gmNLcwg@mail.gmail.com> <20131010162015.GC29913@atomide.com> <CACRpkdYF83ghUf60Wmrti53UJ1bWV30GW_P9GjWnsOcZHbsv+Q@mail.gmail.com> <5257BD3E.5000707@ti.com> <CACRpkdYJNaiAAHhYatd6g5_wVt0QEUxOvsk6nQn9o=_i5zfWrA@mail.gmail.com> <20131011154352.GO29913@atomide.com> <CACRpkdZhbadd5d4P+2B0_DktqK4CHzZPVJC8kPHZYUnp8TaxsA@mail.gmail.com> <20131011160146.GR29913@atomide.com> <5260E606.2030903@ti.com> <20131018153541.GJ15154@atomide.com>
In-Reply-To: <20131018153541.GJ15154@atomide.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 October 2013 09:05 PM, Tony Lindgren wrote:
> * Balaji T K <balajitk@ti.com> [131018 00:41]:
>>
>> Any conclusion on using regmap for omap control module non-mux registers ?
>
> I don't think anybody has even started looking into a SCM driver
> yet considering there are tons of other issues to sort out.
>
> If you're thinking about implementing the MMC PBIAS driver, I would
> just implement it as a standalone driver. It seems that the PBIAS
> interface to the MMC driver can be just regulator framework.
>
Hi Tony,

I am testing pbias regulator, Just thinking whether it should be
using regmap api or direct readl/writel


> Then when we have the SCM driver available, this driver can be
> updated to coordinate things with the core SCM driver.

Do you see regmap getting used for the SCM driver ?

Thanks and Regards,
Balaji T K

>
> Regards,
>
> Tony
>
