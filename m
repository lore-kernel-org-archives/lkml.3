Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaCKN5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:57:45 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:38958 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbaCKN5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:57:42 -0400
Message-ID: <531F161F.9040804@st.com>
Date: Tue, 11 Mar 2014 14:56:47 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, <kernel@stlinux.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/5] ARM: STi: Add STiH407 SoC support
References: <1394203251-25361-1-git-send-email-maxime.coquelin@st.com> <1394203251-25361-2-git-send-email-maxime.coquelin@st.com> <20140310123405.GU14976@lee--X1>
In-Reply-To: <20140310123405.GU14976@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I missed this one.

On 03/10/2014 01:34 PM, Lee Jones wrote:
>> This patch adds support to STiH407 SoC.
>>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>> ---
>>   Documentation/arm/sti/stih407-overview.txt    | 18 ++++++++++++++++++
>>   Documentation/devicetree/bindings/arm/sti.txt | 15 +++++++++++++++
>>   arch/arm/mach-sti/Kconfig                     |  9 +++++++++
>>   arch/arm/mach-sti/board-dt.c                  |  1 +
>>   4 files changed, 43 insertions(+)
>>   create mode 100644 Documentation/arm/sti/stih407-overview.txt
>>   create mode 100644 Documentation/devicetree/bindings/arm/sti.txt
>
> <snip>
>
>> +config SOC_STIH407
>> +	bool "STiH407 STMicroelectronics Consumer Electronics family"
>> +	default y
>> +	help
>> +	  This enables support for STMicroelectronics Digital Consumer
>> +	  Electronics family StiH407 parts, primarily targeted at set-top-box
>> +	  and other digital audio/video applications using Flattened Device
>> +	  Trees.
>> +
>
> Are these configs actually used for something?
Not currently, but it is going to happen (for reset controller).

I will add it only when I'll send the reset controller driver for STiH407.

Regards,
Maxime

>
> <snip>
>
