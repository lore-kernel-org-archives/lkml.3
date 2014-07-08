Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaGHJBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:01:52 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:50275 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526AbaGHJBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:01:49 -0400
Message-ID: <53BBB358.3040801@st.com>
Date: Tue, 8 Jul 2014 11:01:12 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        <devicetree@vger.kernel.org>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <peppe.cavallaro@st.com>
Subject: Re: [PATCH v2 3/3] MAINTAINERS: Add dwc3-st.c file to ARCH/STI architecture
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org> <1404541530-27856-4-git-send-email-peter.griffin@linaro.org> <53BBA075.9040204@st.com> <20140708075332.GM6407@lee--X1>
In-Reply-To: <20140708075332.GM6407@lee--X1>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-08_03:2014-07-08,2014-07-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/08/2014 09:53 AM, Lee Jones wrote:
> On Tue, 08 Jul 2014, Maxime Coquelin wrote:
>> On 07/05/2014 08:25 AM, Peter Griffin wrote:
>>> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
>>
>> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
>
> Maxime,
>    Once Acked by Felipe, I think this should go in via your tree to
> avoid conflicts with other ARM/STI ARCHITECTURE additions.

Ok

>
>>> ---
>>>   MAINTAINERS | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 702ca10..269ad3b 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -1325,6 +1325,7 @@ F:	drivers/pinctrl/pinctrl-st.c
>>>   F:	drivers/media/rc/st_rc.c
>>>   F:	drivers/i2c/busses/i2c-st.c
>>>   F:	drivers/tty/serial/st-asc.c
>>> +F:	drivers/usb/dwc3/dwc3-st.c
>>>
>>>   ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
>>>   M:	Lennert Buytenhek <kernel@wantstofly.org>
>>>
>
