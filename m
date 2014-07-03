Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbaGCIH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:07:29 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:36256 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756220AbaGCIHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:07:14 -0400
Message-ID: <53B50EFD.2070007@st.com>
Date: Thu, 3 Jul 2014 10:06:21 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Philipp Zabel <p.zabel@pengutronix.de>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <patrice.chotard@st.com>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Add reset controllers for STiH407 SoC
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org> <1404317194.4109.13.camel@paszta.hi.pengutronix.de> <20140702165924.GB17665@lee--X1>
In-Reply-To: <20140702165924.GB17665@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-03_03:2014-07-02,2014-07-03,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/02/2014 06:59 PM, Lee Jones wrote:
> On Wed, 02 Jul 2014, Philipp Zabel wrote:
>
>> Hi Peter,
>>
>> Am Mittwoch, den 02.07.2014, 15:08 +0100 schrieb Peter Griffin:
>>> This series adds reset controller support for the STiH407 SoC.
>>>
>>> Changes since v1
>>>   - Update copyright to 2014
>>>   - Add const qualifier
>>>   - Fix various whitespace issues
>>>   - Remove THIS_OWNER
>>>   - Move DT documentation into separate patch
>>>
>>> Peter Griffin (4):
>>>    reset: stih407: Add softreset, powerdown and picophy controllers
>>>    reset: sti: Document sti-picophyreset controllers bindings.
>>>    ARM: sti: Add STiH407 Kconfig entry to select STIH407_RESET
>>>    ARM: sti: Add STiH407 reset controller support.
>>>
>>>   .../bindings/reset/st,sti-picophyreset.txt         |  42 ++++++
>>>   arch/arm/boot/dts/stih407.dtsi                     |  16 +++
>>>   arch/arm/mach-sti/Kconfig                          |  10 ++
>>>   drivers/reset/sti/Kconfig                          |   4 +
>>>   drivers/reset/sti/Makefile                         |   1 +
>>>   drivers/reset/sti/reset-stih407.c                  | 158 +++++++++++++++++++++
>>>   .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
>>>   7 files changed, 292 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
>>>   create mode 100644 drivers/reset/sti/reset-stih407.c
>>>   create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h
>>
>> Looks good to me now.
>>
>> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
>
> Do you have a tree for Reset?  If not, which route do these patches
> normally follow?
>

I will queue patch 4 to STi DT branch for v3.17.
For now, no nodes uses reset for STiH407, so we don't need the 
dt-bindings header file in the STi tree.

If we have a DT node using a reset line before my pull-request, I might 
have to integrate the series in the STi DT branch.
Philipp, does that sound reasonable?

Regards,
Maxime
