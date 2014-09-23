Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaIWH7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:59:54 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:55544 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbaIWH7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:59:52 -0400
Message-ID: <54212840.60508@st.com>
Date: Tue, 23 Sep 2014 09:58:56 +0200
From: Gabriel Fernandez <gabriel.fernandez@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Maxime Coquelin <maxime.coquelin@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <olof@lixom.net>
Cc: <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Olivier Bideau <olivier.bideau@st.com>
Subject: Re: [RESEND PATCH 1/4] ARM: STi: DT: STiH407: 407 DT Entry for clockgen
 A0
References: <1408977888-10473-1-git-send-email-gabriel.fernandez@linaro.org> <1408977888-10473-2-git-send-email-gabriel.fernandez@linaro.org> <542124CB.1080307@st.com>
In-Reply-To: <542124CB.1080307@st.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.19.41]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-23_03:2014-09-23,2014-09-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Maxime !

On 09/23/2014 09:44 AM, Maxime Coquelin wrote:
>
>
> On 08/25/2014 04:44 PM, Gabriel FERNANDEZ wrote:
>> Patch adds DT entries for clockgen A0
>>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
>> ---
>>   arch/arm/boot/dts/stih407-clock.dtsi | 32 
>> ++++++++++++++++++++++++++++++++
>>   1 file changed, 32 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/stih407-clock.dtsi 
>> b/arch/arm/boot/dts/stih407-clock.dtsi
>> index 800f46f..e03e86e 100644
>> --- a/arch/arm/boot/dts/stih407-clock.dtsi
>> +++ b/arch/arm/boot/dts/stih407-clock.dtsi
>> @@ -7,6 +7,10 @@
>>    */
>>   / {
>>       clocks {
>> +        #address-cells = <1>;
>> +        #size-cells = <1>;
>> +        ranges;
>> +
>>           /*
>>            * Fixed 30MHz oscillator inputs to SoC
>>            */
>> @@ -35,5 +39,33 @@
>>               clock-frequency = <200000000>;
>>               clock-output-names = "clk-s-icn-reg-0";
>>           };
>> +
>> +        /*
>> +         * ClockGenAs on SASG2
>> +         */
> Note that I removed this comment since no SASG2 on STiH407.
>
>> +        clockgen-a@090ff000 {
>> +            compatible = "st,clkgen-c32";
>> +            reg = <0x90ff000 0x1000>;
> ...

