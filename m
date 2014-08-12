Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaHLMiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:38:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45373 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaHLMiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:38:11 -0400
Message-ID: <53EA0A26.1050301@ti.com>
Date: Tue, 12 Aug 2014 18:05:50 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: <tony@atomide.com>
CC: Keerthy <j-keerthy@ti.com>, <nm@ti.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <galak@codeaurora.org>,
        Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH 0/2] ARM: dts: dra72-evm: Add i2c1 and tps65917 nodes
References: <1406528334-4415-1-git-send-email-j-keerthy@ti.com> <53D5EE21.1040000@ti.com> <53D61643.4070005@ti.com>
In-Reply-To: <53D61643.4070005@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 02:52 PM, Keerthy wrote:
> On Monday 28 July 2014 12:00 PM, Lokesh Vutla wrote:
>> On Monday 28 July 2014 11:48 AM, Keerthy wrote:
>>> The patch series adds i2c1 and tps65917 and related nodes.
>>> The patch series is boot tested on DRA72-EVM.
>>>
>>> Thanks to Lokesh <lokeshvutla@ti.com> for testing the series.
>
> Correcting the 'to' list.

Hi Tony,

If there are no comments could you please pull these two patches?

Regards,
Keerthy
>
>> For booting, this is dependent on recent hwmod fix patch series 
>> posted by me:
>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg108001.html
>>
>> Boot log for this series can be found here:
>> http://paste.ubuntu.com/7881545/
>
> Thanks Lokesh!
>
>> Thanks and regards,
>> Lokesh
>>> Keerthy J (2):
>>>    ARM: dts: dra72-evm: Enable I2C1 node
>>>    ARM: dts: dra72-evm: Add tps65917 PMIC node
>>>
>>>   arch/arm/boot/dts/dra72-evm.dts |  120 
>>> +++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 120 insertions(+)
>>>
>

