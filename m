Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaEVN73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:59:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59219 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbaEVN71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:59:27 -0400
Message-ID: <537E027E.6040602@ti.com>
Date: Thu, 22 May 2014 16:58:22 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>, <rdunlap@infradead.org>,
        <linux@arm.linux.org.uk>, <grygorii.strashko@ti.com>, <olof@lixom.net>,
        <w-kwok2@ti.com>, <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>
Subject: Re: [Patch v5 0/7] Introduce keystone reset driver
References: <1400766516-14537-1-git-send-email-ivan.khoronzhuk@ti.com> <537E011B.9090902@ti.com> <5069120.YZWxxyxdrl@wuerfel>
In-Reply-To: <5069120.YZWxxyxdrl@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/22/2014 04:54 PM, Arnd Bergmann wrote:
> On Thursday 22 May 2014 09:52:27 Santosh Shilimkar wrote:
>> On Thursday 22 May 2014 09:48 AM, Ivan Khoronzhuk wrote:
>>> These patches introduce keystone reset driver.
>>>
>>> The keystone SoC can be rebooted in several ways. By external reset
>>> pin, by soft and by watchdogs. This driver allows software reset and reset
>>> by one of the watchdogs. Also added opportunity to set soft/hard reset type.
>>>
>>> Based on linux-next/master
>>>
>>> v5..v4
>>>    power: reset: keystone-reset: introduce keystone reset driver
>>>        - changed to get rsmux and rspll offsets from DT
>>>    clock: keystone-pllctrl: add bindings for keystone pll controller
>>>        - new patch
>>>    mfd: ti-keystone-devctrl: add bindings for device state control
>>>        - new patch
>>>    power: reset: add bindings for keystone reset driver
>>>        - corrected description of "ti,syscon-pll", "ti,syscon-dev" properties
>>>        - corrected examples
>>>    ARM: dts: keystone: update reset node to work with reset driver
>>>        - added nodes for pll-controller and device-state-controll
>>>        - added offsets to "ti,syscon-pll", "ti,syscon-dev" properties
>>>
>> Looks like you haven't collected Arnd's Reviewed-by tag on the patches.
>> Can be added later as well while applying.
>>
>>
> I was going to comment the same. Anyway here you have it for the remaining
> patches:
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

-- 
Regards,
Ivan Khoronzhuk

