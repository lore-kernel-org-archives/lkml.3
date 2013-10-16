Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934254Ab3JPN1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:27:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37176 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760550Ab3JPN1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:27:50 -0400
Message-ID: <525E9434.1090006@ti.com>
Date: Wed, 16 Oct 2013 08:27:16 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>
CC: <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <tony@atomide.com>,
        <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: dts: omap5-uevm: remove always_on, boot_on from
 smps10_out1
References: <1381402195-29257-1-git-send-email-kishon@ti.com> <525E9206.9010501@ti.com>
In-Reply-To: <525E9206.9010501@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 08:17 AM, Kishon Vijay Abraham I wrote:
> Benoit,
> 
> On Thursday 10 October 2013 04:19 PM, Kishon Vijay Abraham I wrote:
>> smps10 should be enabled only in the case of host mode. So stop
>> doing always_on, boot_on from smps10_out1. The driver will enable it in host
>> mode.
> 
> Can you take this patch too?

Acked-by: Nishanth Menon <nm@ti.com>
> 
> Thanks
> Kishon
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  arch/arm/boot/dts/omap5-uevm.dts |    2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
>> index d784b3a..e06a04a 100644
>> --- a/arch/arm/boot/dts/omap5-uevm.dts
>> +++ b/arch/arm/boot/dts/omap5-uevm.dts
>> @@ -334,8 +334,6 @@
>>  					regulator-name = "smps10_out1";
>>  					regulator-min-microvolt = <5000000>;
>>  					regulator-max-microvolt = <5000000>;
>> -					regulator-always-on;
>> -					regulator-boot-on;
>>  				};
>>  
>>  				ldo1_reg: ldo1 {
>>
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Regards,
Nishanth Menon
