Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3BEI3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:29:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34774 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab3BEI3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:29:53 -0500
Message-ID: <5110C2E6.30504@ti.com>
Date: Tue, 5 Feb 2013 13:59:26 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <s-guiriec@ti.com>, <gg@slimlogic.co.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/6] ARM: dts: omap5: add dwc3 omap dt data
References: <1359112312-6918-1-git-send-email-kishon@ti.com> <1359112312-6918-5-git-send-email-kishon@ti.com> <510432BF.80808@mvista.com>
In-Reply-To: <510432BF.80808@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2013 01:17 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 25-01-2013 15:11, Kishon Vijay Abraham I wrote:
>
>> Add dwc3 omap glue data to the omap5 dt data file. The information about
>> the dt node added here is available @
>> Documentation/devicetree/bindings/usb/omap-usb.txt
>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   arch/arm/boot/dts/omap5.dtsi |   11 +++++++++++
>>   1 file changed, 11 insertions(+)
>
>> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
>> index 5f59bf2..1703a72 100644
>> --- a/arch/arm/boot/dts/omap5.dtsi
>> +++ b/arch/arm/boot/dts/omap5.dtsi
>> @@ -513,6 +513,17 @@
>>               ti,type = <2>;
>>           };
>>
>> +        omap_dwc3@4a020000 {
>> +            compatible = "ti,dwc3";
>> +            ti,hwmods = "usb_otg_ss";
>> +            reg = <0x4a020000 0x1ff>;
>
>     Shoudn't the "reg" length be 0x200 here? It's length, not limit.

I think 0x1ff is correct. I got the data from hwmod data.

Thanks
Kishon
