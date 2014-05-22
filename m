Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaEVOeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:34:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59772 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaEVOd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:33:59 -0400
Message-ID: <537E0A87.5010408@ti.com>
Date: Thu, 22 May 2014 17:32:39 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <santosh.shilimkar@ti.com>,
        <arnd@arndb.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <linux@arm.linux.org.uk>, <sergei.shtylyov@cogentembedded.com>,
        <linux-doc@vger.kernel.org>, <w-kwok2@ti.com>, <rdunlap@infradead.org>,
        <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <m-karicheri2@ti.com>, <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch v5 3/7] mfd: ti-keystone-devctrl: add bindings for device
 state control
References: <1400766516-14537-1-git-send-email-ivan.khoronzhuk@ti.com> <1400766516-14537-4-git-send-email-ivan.khoronzhuk@ti.com> <20140522141432.GA19747@lee--X1>
In-Reply-To: <20140522141432.GA19747@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/22/2014 05:14 PM, Lee Jones wrote:
> Why do I only have this patch?  Where is the rest of the set?  Also,
> it's on v5 and I don't recall seeing the other 4 versions?

It's strange I've sent whole series on

linux-kernel@vger.kernel.org
linux-arm-kernel@lists.infradead.org
linux-doc@vger.kernel.org
devicetree@vger.kernel.org

v4 is also was sent to lists in question:
https://lkml.org/lkml/2014/5/21/359

>> The Keystone II devices have a set of registers that are used to control
>> the status of its peripherals. This node is intended to allow access to
>> this functionality.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>   .../devicetree/bindings/mfd/ti-keystone-devctrl.txt   | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt b/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
>> new file mode 100644
>> index 0000000..35f7a66
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/ti-keystone-devctrl.txt
>> @@ -0,0 +1,19 @@
>> +* Device tree bindings for Texas Instruments keystone device state control
>> +
>> +The Keystone II devices have a set of registers that are used to control
>> +the status of its peripherals. This node is intended to allow access to
>> +this functionality.
>> +
>> +Required properties:
>> +
>> +- compatible:		"ti,keystone-devctrl", "syscon"
>> +
>> +- reg:			contains offset/length value for pll controller
>> +			registers space.
> Why have you tabbed out all that way?

I'll correct

>
>> +Example:
>> +
>> +devctrl: device-state-control {
> This node needs an address:
>
> devctrl: device-state-control@02620000 {

Thanks!
I will correct

>> +	compatible = "ti,keystone-devctrl", "syscon";
>> +	reg = <0x02620000 0x1000>;
>> +};

-- 
Regards,
Ivan Khoronzhuk

