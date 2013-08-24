Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3HXSd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 14:33:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55720 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab3HXSd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 14:33:56 -0400
Message-ID: <5218FC6C.6000002@ti.com>
Date: Sat, 24 Aug 2013 13:33:16 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Benoit Cousson <bcousson@baylibre.com>, <tony@atomide.com>,
        <devicetree@vger.kernel.org>, Matt Porter <matt@ohporter.com>,
        <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: dts: add AM33XX EDMA support
References: <1377284808-32412-1-git-send-email-bigeasy@linutronix.de> <5218F519.3040409@cogentembedded.com>
In-Reply-To: <5218F519.3040409@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating CC with Matt's current email address.

On 08/24/2013 01:02 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 08/23/2013 11:06 PM, Sebastian Andrzej Siewior wrote:
> 
>> From: Matt Porter <mdp@ti.com>
> 
>> Adds AM33XX EDMA support to the am33xx.dtsi as documented in
>> Documentation/devicetree/bindings/dma/ti-edma.txt
> 
>> Joel: Drop DT entries that are non-hardware-description for now as discussed
>> in [1]
> 
>> [1] https://patchwork.kernel.org/patch/2226761/
> 
>> Signed-off-by: Matt Porter <mporter@ti.com>
>> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> ---
>> Could someone please pick this up?
> 
>>   arch/arm/boot/dts/am33xx.dtsi | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
> 
>> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
>> index 38b446b..784f774 100644
>> --- a/arch/arm/boot/dts/am33xx.dtsi
>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>> @@ -96,6 +96,18 @@
>>               reg = <0x48200000 0x1000>;
>>           };
>>
>> +        edma: edma@49000000 {
> 
>    The node should be named "dma-controller", not "edma",according to ePAPR
> section 2.2.2:
> 
> http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

So you mean something like the following?

edma: dma-controller@49000000 {
  ...
}


Thanks,

-Joel

