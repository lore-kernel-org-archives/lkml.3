Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbaEFPtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:49:23 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46261 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629AbaEFPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:49:20 -0400
Message-ID: <53690435.5040602@st.com>
Date: Tue, 6 May 2014 17:48:05 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: <devicetree@vger.kernel.org>, <kernel@stlinux.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH 0/4] Enable ST Keyscan driver
References: <1399304320-18197-1-git-send-email-gabriel.fernandez@linaro.org> <5368D806.8050609@linaro.org>
In-Reply-To: <5368D806.8050609@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.129.6.68]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-06_05:2014-05-06,2014-05-06,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srini,

	I will prepare the branch next week for the pull request.

Thanks,
Maxime

On 05/06/2014 02:39 PM, Srinivas Kandagatla wrote:
> All the DT patches look good for me.
> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> I think It will be better to send a pull request to Arnd/Olof including
> other reviewed DT patches.
>
> thanks,
> srini
>
>
> On 05/05/14 16:38, Gabriel FERNANDEZ wrote:
>> The goal of this series is to enable ST Keyscan support to ST SoCs.
>> The DT definition is added for STiH415 and STiH416 SoCs on
>> B2000 board.
>> Tested on B2000 sti board.
>>
>> Gabriel Fernandez (4):
>>    ARM: STi: DT: add keyscan for stih415
>>    ARM: STi: DT: add keyscan for stih416
>>    ARM: STi: DT: add keyscan for stih41x-b2000
>>    ARM: multi_v7_defconfig: add ST Keyscan driver
>>
>>   arch/arm/boot/dts/stih415-pinctrl.dtsi | 16 ++++++++++++++++
>>   arch/arm/boot/dts/stih415.dtsi         | 12 ++++++++++++
>>   arch/arm/boot/dts/stih416-pinctrl.dtsi | 16 ++++++++++++++++
>>   arch/arm/boot/dts/stih416.dtsi         | 12 ++++++++++++
>>   arch/arm/boot/dts/stih41x-b2000.dtsi   | 23 +++++++++++++++++++++++
>>   arch/arm/configs/multi_v7_defconfig    |  1 +
>>   6 files changed, 80 insertions(+)
>>
