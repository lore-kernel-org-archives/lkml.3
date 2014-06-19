Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbaFSQZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:25:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60867 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757494AbaFSQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:25:07 -0400
Message-ID: <53A30EDA.7050407@free-electrons.com>
Date: Thu, 19 Jun 2014 18:24:58 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: mvebu: Fix missing binding documentation for Armada
 38x
References: <1403186871-28204-1-git-send-email-gregory.clement@free-electrons.com> <CAL_Jsq+JyngWXvk6ZzV8LPfGqVMDPyouJsADaokAGzgHv=gphQ@mail.gmail.com>
In-Reply-To: <CAL_Jsq+JyngWXvk6ZzV8LPfGqVMDPyouJsADaokAGzgHv=gphQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 19/06/2014 16:54, Rob Herring wrote:
> On Thu, Jun 19, 2014 at 9:07 AM, Gregory CLEMENT
> <gregory.clement@free-electrons.com> wrote:
>> For the Armada 380 and Armada 385 SoCs, the common bindings for those
>> 2 SoCs, was forgotten. This patch add the documentation for the
>> marvell,aramda38x property.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>> Hi,
>>
>> This fix should be merged in 3.16. For 3.15 I am not sure as it is not
>> a regression.
>>
>> Thanks,
>> Gregory
>>
>>  Documentation/devicetree/bindings/arm/armada-38x.txt | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/armada-38x.txt b/Documentation/devicetree/bindings/arm/armada-38x.txt
>> index 11f2330a6554..b68bcb80d2de 100644
>> --- a/Documentation/devicetree/bindings/arm/armada-38x.txt
>> +++ b/Documentation/devicetree/bindings/arm/armada-38x.txt
>> @@ -6,5 +6,9 @@ following property:
>>
>>  Required root node property:
>>
>> +compatible: must contain "marvell,armada38x"
>> +
>> +Required root node property:
>> +
>>   - compatible: must contain either "marvell,armada380" or
>>     "marvell,armada385" depending on the variant of the SoC being used.
> 
> This looks a bit strange. How about something like this:
> 
>    - compatible: must contain either "marvell,armada380" or
>      "marvell,armada385" depending on the variant of the SoC being
> used and contain "marvell,armada38x".

Indeed it will be more clear written in this way.


Thanks,

Gregory


> 
> Rob
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
