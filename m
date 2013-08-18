Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3HRQzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 12:55:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50868 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab3HRQzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 12:55:49 -0400
Message-ID: <5210FC71.3010600@ti.com>
Date: Sun, 18 Aug 2013 22:25:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 1/2] ARM: davinci: da850: add DT node for ethernet
References: <1376662262-21795-1-git-send-email-prabhakar.csengg@gmail.com> <1376662262-21795-2-git-send-email-prabhakar.csengg@gmail.com> <520E7377.1080808@cogentembedded.com>
In-Reply-To: <520E7377.1080808@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/2013 12:16 AM, Sergei Shtylyov wrote:
> Hello.
> 
> On 08/16/2013 06:11 PM, Lad, Prabhakar wrote:
> 
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
>> Add ethernet device tree node information and pinmux for mii to da850 by
>> providing interrupt details and local mac address.
> 
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>   arch/arm/boot/dts/da850-evm.dts |    5 +++++
>>   arch/arm/boot/dts/da850.dtsi    |   30 ++++++++++++++++++++++++++++++
>>   2 files changed, 35 insertions(+)
> 
>> diff --git a/arch/arm/boot/dts/da850-evm.dts
>> b/arch/arm/boot/dts/da850-evm.dts
>> index 1f8cfdd..44f3fbc 100644
>> --- a/arch/arm/boot/dts/da850-evm.dts
>> +++ b/arch/arm/boot/dts/da850-evm.dts
>> @@ -96,6 +96,11 @@
>>               pinctrl-0 = <&mdio_pins>;
>>               bus_freq = <2200000>;
>>           };
>> +        ethernet: emac@1e20000 {
> 
>    Why label the node in the board file too?

May be not required, but all other entries in da850-evm.dts have labels
too. Other .dts files like am335x-bone.dts use labels too (even though
they are never used in references). So I am inclined to let this be like
this and if needed have all the labels removed through a separate patch
- at least we remain consistent within the file that way.

Prabhakar,

Please mind the new e-mail address of the devicetree list.

Thanks,
Sekhar
