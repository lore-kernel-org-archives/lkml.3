Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab3FSBRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:17:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58516 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644Ab3FSBRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:17:41 -0400
Message-ID: <51C1053F.7030607@ti.com>
Date: Tue, 18 Jun 2013 20:11:27 -0500
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <tony@atomide.com>, <grant.likely@linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/6] arm: dts: add bandgap entry for OMAP4460 devices
References: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com> <1370637968-23299-5-git-send-email-eduardo.valentin@ti.com> <51C0C014.2000402@ti.com>
In-Reply-To: <51C0C014.2000402@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On 06/18/2013 03:16 PM, Eduardo Valentin wrote:
> Benoit
>
> On 07-06-2013 16:46, Eduardo Valentin wrote:
>> Include bandgap devices for OMAP4460 devices.
>>
>> Cc: "Benoît Cousson" <b-cousson@ti.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: linux-omap@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>
> Could you please have a look on patch 3 and 4 of this series? I have
> changed this one accordingly to your recommendation on v2. If nothing
> else, please let me know if they can still be queued for 3.11.

I've just applied both of them in my tree for 3.11. I'll send the pull 
request to Tony tomorrow.

Regards,
Benoit

>
> I would need to rebase patch 01 to refresh on top of the thermal tree.
>
> Thanks.
>
>>   arch/arm/boot/dts/omap4460.dtsi | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
>> index 2cf227c..ea97201 100644
>> --- a/arch/arm/boot/dts/omap4460.dtsi
>> +++ b/arch/arm/boot/dts/omap4460.dtsi
>> @@ -29,4 +29,13 @@
>>   			     <0 55 0x4>;
>>   		ti,hwmods = "debugss";
>>   	};
>> +
>> +	bandgap {
>> +		reg = <0x4a002260 0x4
>> +			0x4a00232C 0x4
>> +			0x4a002378 0x18>;
>> +		compatible = "ti,omap4460-bandgap";
>> +		interrupts = <0 126 4>; /* talert */
>> +		gpios = <&gpio3 22 0>; /* tshut */
>> +	};
>>   };
>>
>
>

