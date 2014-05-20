Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaETI2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:28:18 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:44922 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbaETI2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:28:15 -0400
Message-ID: <537B11DE.6040000@st.com>
Date: Tue, 20 May 2014 10:27:10 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v4 6/6] ARM: dts: STiH407: Add B2120 board support
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>	<1394614210-15698-7-git-send-email-maxime.coquelin@st.com> <CAOesGMg5Jk_XB3zdfKz8VxRObYbFO8OMuRyo7Ba-kavANbci1w@mail.gmail.com>
In-Reply-To: <CAOesGMg5Jk_XB3zdfKz8VxRObYbFO8OMuRyo7Ba-kavANbci1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-19_03:2014-05-19,2014-05-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On 05/20/2014 08:18 AM, Olof Johansson wrote:
> Hi,
>
> Just a quick drive-by review since I was looking at these patches in
> the pull request you sent.
>
>
>

Thanks for the review.
I will send a new series taking your comments into account, except the 
one about reference-based syntax.

[...]

>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 12455cf..f760a88 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -317,7 +317,8 @@ dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
>>   dtb-$(CONFIG_ARCH_STI)+= stih415-b2000.dtb \
>>          stih416-b2000.dtb \
>>          stih415-b2020.dtb \
>> -       stih416-b2020.dtb
>> +       stih416-b2020.dtb \
>> +       stih407-b2120.dtb
>
> These should be in alphanumerical order. 407 comes before 415. You've
> been out of order with others as well.

Ok, it will be re-ordered in the next series.

>
>>   dtb-$(CONFIG_ARCH_SUNXI) += \
>>          sun4i-a10-a1000.dtb \
>>          sun4i-a10-cubieboard.dtb \
>> diff --git a/arch/arm/boot/dts/stih407-b2120.dts b/arch/arm/boot/dts/stih407-b2120.dts
>> new file mode 100644
>> index 0000000..9c97da4
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/stih407-b2120.dts
>> @@ -0,0 +1,78 @@
>> +/*
>> + * Copyright (C) 2014 STMicroelectronics (R&D) Limited.
>> + * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +/dts-v1/;
>> +#include "stih407.dtsi"
>> +/ {
>> +       model = "STiH407 B2120";
>> +       compatible = "st,stih407", "st,stih407-b2120";
>
> This should go from specific to generic, so the order needs to be the other way.
>
> Please check other dts files for the same (I didn't).
>

Ok, I will change that for this dts and also the other ones.
Thanks,
Maxime


