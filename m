Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaEZNpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:45:23 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:42711 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaEZNpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:45:20 -0400
Message-ID: <53834578.9090305@mm-sol.com>
Date: Mon, 26 May 2014 16:45:28 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, sboyd@codeaurora.org,
        rvaswani@codeaurora.org, davidb@codeaurora.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] ARM: debug: qcom: add UART addresses to Kconfig
 help
References: <1400857952-6963-1-git-send-email-gdjakov@mm-sol.com>	<1400857952-6963-5-git-send-email-gdjakov@mm-sol.com> <CABuKBe+B_Ga-w4aA4dApDTa26rCuhetRTJku27Madm+fHtDcLA@mail.gmail.com>
In-Reply-To: <CABuKBe+B_Ga-w4aA4dApDTa26rCuhetRTJku27Madm+fHtDcLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.14, 19:39, Matthias Brugger wrote:
> 2014-05-23 17:12 GMT+02:00 Georgi Djakov <gdjakov@mm-sol.com>:
>> Add information about the APQ8084 debug UART physical and virtual
>> addresses in the DEBUG_QCOM_UARTDM Kconfig help section.
>> Requires: https://lkml.org/lkml/2014/4/14/312
>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>> ---
>>  arch/arm/Kconfig.debug |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index 40ee328..e71723d 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -376,6 +376,7 @@ choice
>>                   their output to the serial port on Qualcomm devices.
>>
>>                   ARCH      DEBUG_UART_PHYS   DEBUG_UART_BASE
>> +                 APQ8084   0xf995e000        0xfa75e000
>>                   MSM8X60   0x19c40000        0xf0040000
>>                   MSM8960   0x16440000        0xf0040000
>>                   MSM8974   0xf991e000        0xfa71e000
>
> You don't have any uart defined in your dts. You should add them
> before any adding low level debug support.
> Otherwise there might be problems in booting a multi-platform kernel.
>

Thanks for the comment! As the uart depends on clocks, i am adding it to 
the dts as part of my global clock controller patchset [1].
In this patch i am just adding some information to the help section.
Do you see any problem with this?

[1] https://lkml.org/lkml/2014/5/22/422

Thanks,
Georgi
