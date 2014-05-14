Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaENLuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:50:52 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52074 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbaENLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:50:50 -0400
Message-ID: <5373586A.5000302@st.com>
Date: Wed, 14 May 2014 13:50:02 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pankaj Dev <pankaj.dev@st.com>
Subject: Re: [PATCH 1/9] ARM: STi: DT: STiH416: 416 DT Entry for clockgen
 A0/1/10/11/12
References: <1399305223-18703-1-git-send-email-gabriel.fernandez@linaro.org> <1399305223-18703-2-git-send-email-gabriel.fernandez@linaro.org> <20140506071843.GD5206@lee--X1> <CAG374jD+msPPbPtFS+ji=8jS9+D-YHu31k7zzzC7Ty7jw9n7jQ@mail.gmail.com> <20140508080344.GE5307@lee--X1>
In-Reply-To: <20140508080344.GE5307@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-14_03:2014-05-14,2014-05-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 05/08/2014 10:03 AM, Lee Jones wrote:
>>>> Patch adds DT entries for clockgen A0/1/10/11/12
>>>>
>>>> Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
>>>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>>>> ---
>>>>   arch/arm/boot/dts/stih416-clks.h     |  15 ++
>>>
>>> This should live in include/dt-bindings/clk
>>>
>> include/dt-bindings/clk or  include/dt-bindings/clock ?
>
> I have no idea what the difference between the two are.  I guess you
> are in a better position to answer that.  My point was just that the
> includes should be in the include directory, rather than being held
> locally in the 'dts' directory.

Even if these .h files are only used by the DTS files??

There are some .h files for pincfg related stuff, shouldn't we do the 
same in this case?

Regards,
Maxime

>
>>>>   arch/arm/boot/dts/stih416-clock.dtsi | 477 ++++++++++++++++++++++++++++++++++
>>>>   arch/arm/boot/dts/stih416.dtsi       |  10 +-
>>>>   3 files changed, 497 insertions(+), 5 deletions(-)
>>>>   create mode 100644 arch/arm/boot/dts/stih416-clks.h
>
