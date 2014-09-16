Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaIPXPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:15:06 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:13979 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbaIPXPD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:15:03 -0400
Message-ID: <5418C471.9000807@sonymobile.com>
Date: Tue, 16 Sep 2014 16:14:57 -0700
From: Tim Bird <tim.bird@sonymobile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        =?windows-1252?Q?=22Andersson=2C_Bj=F6rn=22?= 
	<Bjorn.Andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>
Subject: Re: [PATCH] ARM: dts: Add initial DTS file for Sony Xperia Z1 phone
References: <5418C1D2.4000303@sonymobile.com> <27E278AA-EBC0-4368-B75C-DCB2DD906612@codeaurora.org>
In-Reply-To: <27E278AA-EBC0-4368-B75C-DCB2DD906612@codeaurora.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/16/2014 04:08 PM, Kumar Gala wrote:
> 
> On Sep 16, 2014, at 4:03 PM, Tim Bird <tim.bird@sonymobile.com> wrote:
> 
>> This DTS has initial support for just a serial console, for the
>> Sony Xperia Z1 phone.  This phone uses a QualComm 8074 processor.
>>
> 
> Qualcomm, the C isn’t caps.

Will fix.
> 
>> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
>> ---
>> arch/arm/boot/dts/Makefile                   |    1 +
>> arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts |   18 ++++++++++++++++++
>> 2 files changed, 19 insertions(+)
>> create mode 100644 arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index b8c5cd3..680ce7e 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -341,6 +341,7 @@ dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
>> dtb-$(CONFIG_ARCH_QCOM) += \
>> 	qcom-apq8064-ifc6410.dtb \
>> 	qcom-apq8074-dragonboard.dtb \
>> +	qcom-apq8074-xperia-z1.dtb \
>> 	qcom-apq8084-mtp.dtb \
>> 	qcom-msm8660-surf.dtb \
>> 	qcom-msm8960-cdp.dtb
>> diff --git a/arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts b/arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts
>> new file mode 100644
>> index 0000000..59b3fa1
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts
>> @@ -0,0 +1,18 @@
>> +#include "qcom-msm8974.dtsi"
>> +
>> +/ {
>> +	model = "Sony Xperia Z1 phone";
>> +	compatible = "qcom,msm8974”;
> 
> Should have a board compat as well
I'll ask Bjorn what we want to do here.  There was a compat that I stripped,
but I'm not sure we settled on the official name we want.  In any event,
will fix.
> 
>> +	qcom,msm-id = <126 8 0>, <185 8 0>, <186 8 0>;
> 
> We don’t have qcom,msm-id upstream at this time.
Do I just leave this out, then?

Thanks.
 -- Tim

P.S. By now you probably noticed I mis-typed device-tree@vger.kernel.org.  I'll fix that also.
