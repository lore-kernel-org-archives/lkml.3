Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaENPUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:20:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39188 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbaENPU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:20:27 -0400
Message-ID: <53738993.8070708@ti.com>
Date: Wed, 14 May 2014 20:49:47 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 11/17] ARM: dts: dra7xx-clocks: Add missing 32khz clocks
 used for PHY
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-12-git-send-email-kishon@ti.com> <53736E47.4070402@ti.com>
In-Reply-To: <53736E47.4070402@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 14 May 2014 06:53 PM, Roger Quadros wrote:
> Hi Kishon,
> 
> 
> On 05/06/2014 04:33 PM, Kishon Vijay Abraham I wrote:
>> Added missing 32khz clock used by PCIe PHY.
>> The documention for this node can be found @ ../bindings/clock/ti/gate.txt.
> 
> Typo in $subject
> s/clocks/clock

Will fix it.

Thanks
Kishon
> 
> --
> cheers,
> -roger
> 
>>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Rajendra Nayak <rnayak@ti.com>
>> Cc: Tero Kristo <t-kristo@ti.com>
>> Cc: Paul Walmsley <paul@pwsan.com>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  arch/arm/boot/dts/dra7xx-clocks.dtsi |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> index 44993ec..e1bd052 100644
>> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
>> @@ -1165,6 +1165,14 @@
>>  		reg = <0x021c>, <0x0220>;
>>  	};
>>  
>> +	optfclk_pciephy_32khz: optfclk_pciephy_32khz@4a0093b0 {
>> +		compatible = "ti,gate-clock";
>> +		clocks = <&sys_32k_ck>;
>> +		#clock-cells = <0>;
>> +		reg = <0x13b0>;
>> +		ti,bit-shift = <8>;
>> +	};
>> +
>>  	optfclk_pciephy_div: optfclk_pciephy_div@4a00821c {
>>  		compatible = "ti,divider-clock";
>>  		clocks = <&apll_pcie_ck>;
>>
> 
