Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaITBuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 21:50:24 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33309 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaITBuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 21:50:22 -0400
Message-ID: <541CDD54.3020203@gmail.com>
Date: Fri, 19 Sep 2014 18:50:12 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tim Bird <tim.bird@sonymobile.com>
CC: Kumar Gala <galak@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        =?windows-1252?Q?=22Andersson=2C_Bj=F6rn=22?= 
	<Bjorn.Andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>
Subject: Re: [PATCH] ARM: dts: Add initial DTS file for Sony Xperia Z1 phone
References: <5418C1D2.4000303@sonymobile.com> <27E278AA-EBC0-4368-B75C-DCB2DD906612@codeaurora.org> <5418C471.9000807@sonymobile.com>
In-Reply-To: <5418C471.9000807@sonymobile.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/2014 4:14 PM, Tim Bird wrote:
> 
> 
> On 09/16/2014 04:08 PM, Kumar Gala wrote:
>>
>> On Sep 16, 2014, at 4:03 PM, Tim Bird <tim.bird@sonymobile.com> wrote:
>>
>>> This DTS has initial support for just a serial console, for the
>>> Sony Xperia Z1 phone.  This phone uses a QualComm 8074 processor.
>>>
>>
>> Qualcomm, the C isn’t caps.
> 
> Will fix.
>>
>>> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
>>> ---
>>> arch/arm/boot/dts/Makefile                   |    1 +
>>> arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts |   18 ++++++++++++++++++
>>> 2 files changed, 19 insertions(+)
>>> create mode 100644 arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts
>>>
>>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>>> index b8c5cd3..680ce7e 100644
>>> --- a/arch/arm/boot/dts/Makefile
>>> +++ b/arch/arm/boot/dts/Makefile
>>> @@ -341,6 +341,7 @@ dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
>>> dtb-$(CONFIG_ARCH_QCOM) += \
>>> 	qcom-apq8064-ifc6410.dtb \
>>> 	qcom-apq8074-dragonboard.dtb \
>>> +	qcom-apq8074-xperia-z1.dtb \
>>> 	qcom-apq8084-mtp.dtb \
>>> 	qcom-msm8660-surf.dtb \
>>> 	qcom-msm8960-cdp.dtb
>>> diff --git a/arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts b/arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts
>>> new file mode 100644
>>> index 0000000..59b3fa1
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/qcom-apq8074-xperia-z1.dts
>>> @@ -0,0 +1,18 @@
>>> +#include "qcom-msm8974.dtsi"
>>> +
>>> +/ {
>>> +	model = "Sony Xperia Z1 phone";
>>> +	compatible = "qcom,msm8974”;
>>
>> Should have a board compat as well

Also need to add the board compat string, and "qcom,msm8974” to the list of
strings in arch/arm/mach-qcom/board.c: qcom_dt_match[].


> I'll ask Bjorn what we want to do here.  There was a compat that I stripped,
> but I'm not sure we settled on the official name we want.  In any event,
> will fix.
>>
>>> +	qcom,msm-id = <126 8 0>, <185 8 0>, <186 8 0>;
>>
>> We don’t have qcom,msm-id upstream at this time.
> Do I just leave this out, then?
> 
> Thanks.
>  -- Tim
> 
> P.S. By now you probably noticed I mis-typed device-tree@vger.kernel.org.  I'll fix that also.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

