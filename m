Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaGDLcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:32:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaGDLcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:32:13 -0400
Message-ID: <53B690B9.2090906@suse.de>
Date: Fri, 04 Jul 2014 13:32:09 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
CC: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "ARM/SAMSUNG ARM A..." <linux-arm-kernel@lists.infradead.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: exynos5410: Fill in CPU clock-frequency
References: <1403466596-3347-1-git-send-email-afaerber@suse.de> <53A7DCF8.4090108@samsung.com>
In-Reply-To: <53A7DCF8.4090108@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.06.2014 09:53, schrieb Tarek Dakhran:
> On 06/22/2014 11:49 PM, Andreas Färber wrote:
>> It's 1.6 GHz for the Cortex-A15.
>>
>> Avoids warnings like "/cpus/cpu@0 missing clock-frequency property".
>>
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>> ---
>>   arch/arm/boot/dts/exynos5410.dtsi | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos5410.dtsi
>> b/arch/arm/boot/dts/exynos5410.dtsi
>> index 3839c26..9d0b8cc 100644
>> --- a/arch/arm/boot/dts/exynos5410.dtsi
>> +++ b/arch/arm/boot/dts/exynos5410.dtsi
>> @@ -28,24 +28,28 @@
>>               device_type = "cpu";
>>               compatible = "arm,cortex-a15";
>>               reg = <0x0>;
>> +            clock-frequency = <1600000000>;
>>   
> 
> Reviewed-by: Tarek Dakhran<t.dakhran@samsung.com>

Ping? Seems really trivial...

Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
