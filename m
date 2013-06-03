Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3FCOVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:21:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47715 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178Ab3FCOVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:21:13 -0400
Message-ID: <51ACA629.3060505@ti.com>
Date: Mon, 3 Jun 2013 16:20:25 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>
CC: <florian.vaussard@epfl.ch>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] ARM: dts: omap4-panda: Update the twl6040 gpio to
 macro definition
References: <1370015122-26792-1-git-send-email-dmurphy@ti.com> <51A8CC08.6090305@epfl.ch>
In-Reply-To: <51A8CC08.6090305@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On 05/31/2013 06:12 PM, Florian Vaussard wrote:
> Hello Dan,
> 
> On 05/31/2013 05:45 PM, Dan Murphy wrote:
>> Update the dt property ti,audpwron-gpio to use the
>> gpio macro definition for GPIO_ACTIVE_HIGH.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   arch/arm/boot/dts/omap4-panda-common.dtsi |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi
>> b/arch/arm/boot/dts/omap4-panda-common.dtsi
>> index 800fa4e..00cbaa5 100644
>> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
>> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
>> @@ -190,7 +190,7 @@
>>           /* IRQ# = 119 */
>>           interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>; /*
>> IRQ_SYS_2N cascaded to gic */
>>           interrupt-parent = <&gic>;
>> -        ti,audpwron-gpio = <&gpio4 31 0>;  /* gpio line 127 */
>> +        ti,audpwron-gpio = <&gpio4 31 GPIO_ACTIVE_HIGH>;  /* gpio
>> line 127 */
>>
>>           vio-supply = <&v1v8>;
>>           v2v1-supply = <&v2v1>;
>>
> 
> I missed it during the conversion, thank you.
> 
> Reviewed-by: Florian Vaussard <florian.vaussard@epfl.ch>

I've just applied it with Florian's Reviewed-by.

Thanks,
Benoit

