Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaAJNof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:44:35 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35233 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaAJNod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:44:33 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-fd-52cff93f1650
Message-id: <52CFF938.706@samsung.com>
Date: Fri, 10 Jan 2014 14:44:24 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/6 v2] crypto:s5p-sss: Add device tree support
References: <1389095509-14357-3-git-send-email-ch.naveen@samsung.com>
 <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
 <52CEAEB0.80304@samsung.com>
 <CAHfPSqA=xkHX1kajjYfNz2KMrnfHGdWzu9GWvSE4ZjWWZb-hQA@mail.gmail.com>
In-reply-to: <CAHfPSqA=xkHX1kajjYfNz2KMrnfHGdWzu9GWvSE4ZjWWZb-hQA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xq7r2P88HGZzYw21x9/lhRouXhzQt
	5pxvYbHofiVjcf/eTyaLy7vmsFnMOL+PyWLRtv/MFqt2/WG0ODvnEJMDl8eWlTeZPHbOusvu
	se2AqkffllWMHp83yQWwRnHZpKTmZJalFunbJXBl3G54xV6wX63i5sKnjA2Ma+W6GDk5JARM
	JF6t7GOFsMUkLtxbz9bFyMUhJLCUUeLg/EMsEM5nRokb/08zgVTxCqhJ7L7fxQhiswioSvze
	dYcdxGYDin9ueMQGYosKREj8nbeeEaJeUOLH5HssILaIgJHEzAcLGUGGMgvcZZLYdO0o0GoO
	DmEBZ4knJ50glj1nlFi/9Q8zSAOnQLDE+qO9YAuYBawlVk7axghhy0tsXvOWeQKjwCwkO2Yh
	KZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJAI+LqDcekxq0OMAhyMSjy8BbPO
	BwmxJpYVV+YeYpTgYFYS4bV/BRTiTUmsrEotyo8vKs1JLT7EyMTBKdXAeG7T4Wer2xv1FsUv
	nd325jPDybzzvyyZb79vMf7Urvd4oa7htG+KS11m1Nf+2p5yvV3gQUHPtQUbuiao7r6zUeNi
	cWAca8S7r7Jv/llNf5szXYVX6IFu8lKnR+uPGV+bJXuLc/qCf115F4/z5pr1hH891CWbd4ZV
	xvT2gnk5+hL6n37er3VV0lNiKc5INNRiLipOBAC+HG4zXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 10.01.2014 07:07, Naveen Krishna Ch wrote:
> Hello Tomasz,
>
> Thanks for time and review comments they are really helping me a lot
> in getting the patches merged.
>
> Secondly, accept my apologies for not giving proper writeup of why i
> din't address
> few of your comments on v1 of this patchset.

It's okay.

>
> On 9 January 2014 19:44, Tomasz Figa <t.figa@samsung.com> wrote:
>> Hi Naveen,
>>
>>
>> On 09.01.2014 05:59, Naveen Krishna Chatradhi wrote:
>>>
>>> This patch adds device tree support to the s5p-sss.c crypto driver.
>>> Implements a varient struct to address the changes in SSS hardware
>>> on various SoCs from Samsung.
>>>
>>> Also, Documentation under devicetree/bindings added.
>>>
>>> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
>>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>>> CC: David S. Miller <davem@davemloft.net>
>>> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
>>> TO: <linux-crypto@vger.kernel.org>
>>> CC: <linux-samsung-soc@vger.kernel.org>
>>> ---
>>> Changes since v1:
>>> 1. Added description of the SSS module in Documentation
>>> 2. Corrected the interrupts description
>>> 3. Added varient struct instead of the version variable
>>>
>>>    .../devicetree/bindings/crypto/samsung-sss.txt     |   20 +++++
>>>    drivers/crypto/s5p-sss.c                           |   81
>>> ++++++++++++++++++--
>>>    2 files changed, 95 insertions(+), 6 deletions(-)
>>>    create mode 100644
>>> Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>> b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>> new file mode 100644
>>> index 0000000..0e45b0d
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>> @@ -0,0 +1,20 @@
>>> +Samsung SoC SSS (Security SubSystem) module
>>> +
>>> +The SSS module in S5PV210 SoC supports the following:
>>> +-- Feeder (FeedCtrl)
>>> +-- Advanced Encryption Standard (AES)
>>> +-- Data Encryption Standard (DES)/3DES
>>> +-- Public Key Accelerator (PKA)
>>> +-- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
>>> +-- PRNG: Pseudo Random Number Generator
>>> +
>>> +Required properties:
>>> +
>>> +- compatible : Should contain entries for this and backward compatible
>>> +  SSS versions:
>>> +  - "samsung,s5p-secss" for S5PV210 SoC.
>>
>>
>> As I wrote in my previous reply, please use specific compatible string
>> containing name of SoC on which the block described by it appeared first.
>> Let me say it again, for security block that showed up first on S5PV210 the
>> string will be "samsung,s5pv210-secss".
> 1. .name           = "s5p-secss", is the name used in the present driver.
>      So, i dint modify that.

Please note that compatible strings and platform driver names are 
completely different things. There is no relation between them. 
Moreover, there are different rules (or recommendation) involved for 
creating both, so it's completely fine to add a compatible string of 
"samsung,s5pv210-secss", while keeping platform driver named "s5p-secss".

> 2. I'm not sure which one is the first soc to have the new varient.
>      May be Exynos4210. Will modify in the next version.

Let's see.

 From what I can find in various user's manuals, S5PV210 is the first to 
have the first variant, while Exynos4210 already has the new one.

>>
>>> +       },
>>> +       { },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
>>> +#else
>>> +static struct of_device_id s5p_sss_dt_match[] =  {
>>> +       { },
>>> +};
>>
>>
>> Hmm, I don't think there is any need for this.
> I think all Exynos4 and Exynos5 now supports DT
> But, i'm not sure of the S5PV210 series.

S5PV210 does not support DT yet. Work is already in progress, but board 
file support will have to be retained for some time, so this driver 
should support non-DT probing too.

It doesn't affect my comment, though, as you can use of_match_ptr() macro.

>>> @@ -674,9 +741,11 @@ static int s5p_aes_remove(struct platform_device
>>> *pdev)
>>>    static struct platform_driver s5p_aes_crypto = {
>>>          .probe  = s5p_aes_probe,
>>>          .remove = s5p_aes_remove,
>>> +       .id_table       = s5p_sss_ids,
>>>          .driver = {
>>>                  .owner  = THIS_MODULE,
>>>                  .name   = "s5p-secss",
>>> +               .of_match_table = s5p_sss_dt_match,
>>
>>
>> .of_match_table = of_match_ptr(s5p_sss_dt_match),
> I dint use it, Some time back there was a patchset from Sachin
> https://lkml.org/lkml/2013/9/28/61
> Please suggest me on this.

I believe Sachin already explained this in his reply to your patch. 
Generally the driver from your link is supposed to always support DT, 
while this one can be built without DT support.

Best regards,
Tomasz
