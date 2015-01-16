Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbbAPMdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:33:02 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41243 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbbAPMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:33:00 -0500
Message-ID: <54B904C3.1080002@st.com>
Date: Fri, 16 Jan 2015 13:32:03 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH 0/3] Enable myphy28lp support
References: <1421229299-8206-1-git-send-email-gabriel.fernandez@linaro.org> <54B8FC56.8080400@st.com>
In-Reply-To: <54B8FC56.8080400@st.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-16_04:2015-01-16,2015-01-16,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/16/2015 12:56 PM, Maxime Coquelin wrote:
> Hi Gabriel,
>
>     For the series:
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
>
>     Kishon, could you take care of adding PHY driver patch for v3.20?
Hi Kishon,

     Don't apply the patch, since we have 2 other PHY driver patches, I 
will send you a pull request.

Best regards,
Maxime


>
> Thanks,
> Maxime
> On 01/14/2015 10:54 AM, Gabriel FERNANDEZ wrote:
>> The goal of this series is to enable the support of MiPHY28lp Generic 
>> PHY.
>>
>> The first patch is to update miphy28lp phy driver to access sysconfig 
>> register
>> offsets via syscfg dt property. It's based on Arnds review comments here
>> https://lkml.org/lkml/2014/11/13/161
>> I have updated the miphy28lp phy driver same way as Peter's 
>> implementation.
>>
>> Gabriel Fernandez (3):
>>    phy: miphy28lp: Pass sysconfig register offsets via syscfg dt
>>      property.
>>    ARM: DT: STi: STiH407: Add DT node for MiPHY28lp
>>    ARM: multi_v7_defconfig: Enable MiPHY28lp - ST's Generic (SATA, 
>> PCIe &
>>      USB3) PHY
>>
>>   .../devicetree/bindings/phy/phy-miphy28lp.txt      | 43 
>> ++++++---------
>>   arch/arm/boot/dts/stih407-family.dtsi              | 53 
>> +++++++++++++++++++
>>   arch/arm/boot/dts/stihxxx-b2120.dtsi               | 11 ++++
>>   arch/arm/configs/multi_v7_defconfig                |  1 +
>>   drivers/phy/phy-miphy28lp.c                        | 61 
>> ++++++++++++----------
>>   5 files changed, 113 insertions(+), 56 deletions(-)
>>
>

