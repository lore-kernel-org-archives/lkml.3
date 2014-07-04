Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbaGDVGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:06:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37830 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaGDVGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:06:44 -0400
Message-ID: <53B7175B.1030109@samsung.com>
Date: Sat, 05 Jul 2014 06:06:35 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ARM/SAMSUNG ARM A..." <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: dts: exynos5410: Fill in CPU clock-frequency
References: <1403466596-3347-1-git-send-email-afaerber@suse.de> <53A7DCF8.4090108@samsung.com> <53B690B9.2090906@suse.de>
In-Reply-To: <53B690B9.2090906@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/14 20:32, Andreas Färber wrote:
> Am 23.06.2014 09:53, schrieb Tarek Dakhran:
>> On 06/22/2014 11:49 PM, Andreas Färber wrote:
>>> It's 1.6 GHz for the Cortex-A15.
>>>
>>> Avoids warnings like "/cpus/cpu@0 missing clock-frequency property".
>>>
>>> Signed-off-by: Andreas afaerber@suse.de>
>>> ---
>>>    arch/arm/boot/dts/exynos5410.dtsi | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/exynos5410.dtsi
>>> b/arch/arm/boot/dts/exynos5410.dtsi
>>> index 3839c26..9d0b8cc 100644
>>> --- a/arch/arm/boot/dts/exynos5410.dtsi
>>> +++ b/arch/arm/boot/dts/exynos5410.dtsi
>>> @@ -28,24 +28,28 @@
>>>                device_type = "cpu";
>>>                compatible = "arm,cortex-a15";
>>>                reg =<0x0>;
>>> +            clock-frequency =<1600000000>;
>>>
>>
>> Reviewed-by: Tarek Dakhran<t.dakhran@samsung.com>
>
> Ping? Seems really trivial...
>
Will apply.

BTW Andreas, I can't use 'Färber' in my git tree so which one is right 
or more preferred? Farber, Faerber, Ferber? Sorry.

Thanks,
Kukjin
