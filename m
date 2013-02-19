Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab3BSLA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:00:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42130 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab3BSLAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:00:24 -0500
Message-ID: <51235B7C.8080008@ti.com>
Date: Tue, 19 Feb 2013 16:31:16 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Afzal Mohammed <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 5/8] ARM: OMAP2+: am43: Kconfig
References: <cover.1361186097.git.afzal@ti.com> <5951ba90110b97fb494743e1aedf26aaa92b97a9.1361186097.git.afzal@ti.com> <5123537B.8050709@ti.com> <20130219105633.GN23197@arwen.pp.htv.fi>
In-Reply-To: <20130219105633.GN23197@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2013 04:26 PM, Felipe Balbi wrote:
> On Tue, Feb 19, 2013 at 03:57:07PM +0530, Santosh Shilimkar wrote:
>> On Monday 18 February 2013 05:08 PM, Afzal Mohammed wrote:
>>> Add Kconfig option for AM43 family of SoC's, these are ARM Cortex A9
>>> based (SMP configuration with 1 core).
>>>
>>> Signed-off-by: Afzal Mohammed <afzal@ti.com>
>>> ---
>>>   arch/arm/mach-omap2/Kconfig | 11 +++++++++++
>>>   1 file changed, 11 insertions(+)
>>>
>>> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
>>> index 49ac3df..683fbaa 100644
>>> --- a/arch/arm/mach-omap2/Kconfig
>>> +++ b/arch/arm/mach-omap2/Kconfig
>>> @@ -141,6 +141,17 @@ config SOC_AM33XX
>>>   	select MULTI_IRQ_HANDLER
>>>   	select COMMON_CLK
>>>
>>> +config SOC_AM43
>>> +	bool "TI AM43"
>>> +	depends on ARCH_OMAP2PLUS
>>> +	default y
>>> +	select CPU_V7
>>> +	select HAVE_SMP
>> You don't need this
>
> actually, this is needed for CONFIG_SMP_ON_UP
>
Ahh.. I missed that. Thanks Felipe for pointing it
out.

Regards,
Santosh
