Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3JDIpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:45:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34856 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3JDIph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:45:37 -0400
Message-ID: <524E802E.2060802@codeaurora.org>
Date: Fri, 04 Oct 2013 01:45:34 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv4 2/4] ARM: msm: Add support for APQ8074 Dragonboard
References: <1380841557-2673-1-git-send-email-rvaswani@codeaurora.org>  <1380841557-2673-3-git-send-email-rvaswani@codeaurora.org> <1380875311.24031.17.camel@iivanov-dev.int.mm-sol.com>
In-Reply-To: <1380875311.24031.17.camel@iivanov-dev.int.mm-sol.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/2013 1:28 AM, Ivan T. Ivanov wrote:
> Hi Rohit,
>
> On Thu, 2013-10-03 at 16:05 -0700, Rohit Vaswani wrote:
>> This patch adds basic board support for APQ8074 Dragonboard
>> which belongs to the Snapdragon 800 family.
>> For now, just support a basic machine with device tree.
>>
>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>> ---
>>   arch/arm/boot/dts/Makefile                     |  3 ++-
>>   arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |  6 +++++
>>   arch/arm/boot/dts/qcom-msm8974.dtsi            | 35 ++++++++++++++++++++++++++
>>   arch/arm/mach-msm/Kconfig                      | 13 ++++++++++
>>   arch/arm/mach-msm/board-dt.c                   |  9 +++++++
>>   5 files changed, 65 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
>>   create mode 100644 arch/arm/boot/dts/qcom-msm8974.dtsi
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 000cf76..e71a3ec 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -102,7 +102,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
>>   	kirkwood-openblocks_a6.dtb
>>   dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
>>   dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
>> -	msm8960-cdp.dtb
>> +	msm8960-cdp.dtb \
>> +	qcom-apq8074-dragonboard.dtb
>>   dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
>>   	armada-370-mirabox.dtb \
>>   	armada-370-netgear-rn102.dtb \
>> diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
>> new file mode 100644
>> index 0000000..bb6f3c4
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
>> @@ -0,0 +1,6 @@
>> +/include/ "qcom-msm8974.dtsi"
> Please, could you replace /include/ by #include. This will allow
> us to use of #define features from C header files. Since[1] we have
> clocks indexes definitions shared between C code and DT files.

Will do.
>
> Thanks,
> Ivan
>
> [1] http://www.spinics.net/lists/arm-kernel/msg276937.html
>
>
>


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

