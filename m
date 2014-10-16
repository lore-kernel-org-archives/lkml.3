Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaJPLLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 07:11:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45501 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJPLLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 07:11:39 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-f79ab6d0000046f7-81-543fa7e76c10
Content-transfer-encoding: 8BIT
Message-id: <543FA7E7.5030009@samsung.com>
Date: Thu, 16 Oct 2014 20:11:35 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
To: Vivek Gautam <gautam.vivek@samsung.com>,
        Prabu Thangamuthu <Prabu.T@synopsys.com>
Cc: Alim Akhtar <alim.akhtar@gmail.com>, Seungwon Jeon <tgih.jun@samsung.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manjunath M Bettegowda <Manjunath.MB@synopsys.com>
Subject: Re: [PATCH v6] mmc: dw_mmc: Add IDMAC 64-bit address mode support
References: <705D14B1C7978B40A723277C067CEDE21B3336B2@IN01WEMBXB.internal.synopsys.com>
 <CAGOxZ51fzvoqUQ7=8312iLyu4jwgmskkaysgXQHju-E5EM5gNQ@mail.gmail.com>
 <CAFp+6iFQ=MU-R-mYLeL0=H5fVWkxVu5s4ineh3RcSExCUNAjCA@mail.gmail.com>
 <543F6A93.1070008@samsung.com>
 <705D14B1C7978B40A723277C067CEDE21B333F07@IN01WEMBXB.internal.synopsys.com>
 <CAFp+6iEXMNzaEgcpFE_vCYj6xwPLJvLzBhA5NFrfnEt1kSyk8Q@mail.gmail.com>
In-reply-to: <CAFp+6iEXMNzaEgcpFE_vCYj6xwPLJvLzBhA5NFrfnEt1kSyk8Q@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkSPf5cvsQg2kXzC2W3qq2mHB5O6NF
	25WD7BaXd81hszjyv5/RYsXsuWwWE7YeZ7X4cP8is8XxteEOnB47Z91l97hzbQ+bx41XC5k8
	+rasYvTYsv8zo8fnTXIBbFFcNimpOZllqUX6dglcGY27iwomqlbs27WftYFxjWwXIyeHhICJ
	xIb1O9ggbDGJC/fWA9lcHEICSxkl2hp2s8AU7T83mREiMZ1R4lrnSlaQBK+AoMSPyfeAijg4
	mAXkJY5cygYJMwuoS0yat4gZov41o8TdlR9YIOq1JGYveMUKUs8ioCrxcQnYGDYBHYnt344z
	gdiiAmESh9rmgdkiAuESmy+dB5vDLHCMSeJg52t2kISwgJfEjo9z2SEWzGWWaN73EGwBp0Cw
	xO8trSwgCQmBl+wSh3a3MoMkWAQEJL5NPgR2qYSArMSmA8wQn0lKHFxxg2UCo9gsJP/MQvhn
	FpJ/FjAyr2IUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIjMfT/55N2MF474D1IUYBDkYlHt4L
	AfYhQqyJZcWVuYcYTYGOmMgsJZqcD4z6vJJ4Q2MzIwtTE1NjI3NLMyVx3tdSP4OFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MIY6MHLyc8k7Z2Re+qk77+yk6NunO9905Nzb9t73i3z0un19
	e9uMf0Ymbwj7Va5SO2V7lrnZzg9hLz+J3LcoXv94g2V8peikSYef33VatPmOt0pKQfUXqSM7
	m3/PknM9wtau2XH09+clVa1/Vq+8Jb55U0zA4ymKkj7p1tdOzDZijTzWJXTY/7ESS3FGoqEW
	c1FxIgDFU4+bwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd3ny+1DDJ7N1rdYeqvaYsLl7YwW
	bVcOsltc3jWHzeLI/35GixWz57JZTNh6nNXiw/2LzBbH14Y7cHrsnHWX3ePOtT1sHjdeLWTy
	6NuyitFjy/7PjB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynk
	Jeam2iq5+AToumXmAB2lpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcxo
	3F1UMFG1Yt+u/awNjGtkuxg5OSQETCT2n5vMCGGLSVy4t56ti5GLQ0hgOqPEtc6VrCAJXgFB
	iR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxEzRP1rRom7Kz+wQNRrScxe8IoVpJ5FQFXi4xKw
	MWwCOhLbvx1nArFFBcIkDrXNA7NFBMIlNl86DzaHWeAYk8TBztfsIAlhAS+JHR/nskMsmMss
	0bzvIdgCToFgid9bWlkmMArMQnLfLIT7ZiG5bwEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4Gh/JrWDcWWDxSFGAQ5GJR5ejWD7ECHWxLLiytxDjBIczEoivIsmAYV4UxIrq1KL8uOL
	SnNSiw8xmgJ9N5FZSjQ5H5iI8kriDY1NzIwsjcwNLYyMzZXEeQ+0WgcKCaQnlqRmp6YWpBbB
	9DFxcEo1MKqxGklcm1F+7l/NdJMW4eV/vNJzN9/KDbj/8VSkc69PlONpz0ebvU6vfM5/inFZ
	p+f7p2Yrp09QiTTeJXK75nyPjdO6+8vEjjz9/XiZ1+dKzoU+bw8orFmx7dPxkh9P9+eZbe2f
	3+t5cs7WgJ9i7zvmrdj2cLv4FqcPjcwHerkDf4Xp8izclqCqxFKckWioxVxUnAgAcRTM3AwD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 08:09 PM, Vivek Gautam wrote:
> Hi Prabu,
> 
> 
> On Thu, Oct 16, 2014 at 4:09 PM, Prabu Thangamuthu <Prabu.T@synopsys.com> wrote:
>>
>> Hi Jaehoon, Vivek, Alim,
>>
>> Thanks for your review comments.
>>
>> On Thu, Oct 16, 2014 at 12:20 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>> Hi, Prabu.
>>>
>>> On 10/15/2014 09:05 PM, Vivek Gautam wrote:
>>>> Hi Prabu,
>>>>
>>>>
>>>> On Tue, Oct 14, 2014 at 5:41 PM, Alim Akhtar <alim.akhtar@gmail.com>
>>> wrote:
>>>>> Hi Prahu,
>>>>> Thanks for a quick re-spin o the patch.
>>>>> One last comment, this is more of a information seek.
>>>>> On Thu, Oct 9, 2014 at 1:09 PM, Prabu Thangamuthu
>>> <Prabu.T@synopsys.com> wrote:
>>>>>> Synopsys DW_MMC IP core supports Internal DMA Controller with 64-bit
>>> address mode from IP version 2.70a onwards.
>>>>>> Updated the driver to support IDMAC 64-bit addressing mode.
>>>>>>
>>>>>> Tested the features in DW_MMC core v2.70a and v2.40a with HAPS-51
>>> setup and driver is working fine.
>>>>>>
>>>>>> Signed-off-by: Prabu Thangamuthu <prabu.t@synopsys.com>
>>>>>> ---
>>>>>> Change log v6:
>>>>>>         - Updated with review comment.
>>>>>>
>>>>>> Change log v5:
>>>>>>         - Recreated the patch against linux-next as this patch is
>>>>>> required for another patch
>>>>>> http://www.spinics.net/lists/arm-kernel/msg357985.html
>>>>>>
>>>>>> Change log v4:
>>>>>>         - Add the dynamic support for 32-bit and 64-bit address mode based
>>> on hw configuration.
>>>>>>         - Removed the CONFIG_MMC_DW_IDMAC_64BIT_ADDRESS macro.
>>>>>>
>>>>>>  drivers/mmc/host/dw_mmc.c  |  195
>>> +++++++++++++++++++++++++++++++++++---------
>>>>>>  drivers/mmc/host/dw_mmc.h  |   11 +++
>>>>>>  include/linux/mmc/dw_mmc.h |    2 +
>>>>>>  3 files changed, 170 insertions(+), 38 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/mmc/host/dw_mmc.c
>>> b/drivers/mmc/host/dw_mmc.c
>>>>>> index 69f0cc6..c3b75a5 100644
>>>>>> --- a/drivers/mmc/host/dw_mmc.c
>>>>>> +++ b/drivers/mmc/host/dw_mmc.c
>>>>>> @@ -62,6 +62,24 @@
>>>>>>                                  SDMMC_IDMAC_INT_FBE | SDMMC_IDMAC_INT_RI | \
>>>>>>                                  SDMMC_IDMAC_INT_TI)
>>>>>>
>>>>>> +struct idmac_desc_64addr {
>>>>>> +       u32             des0;   /* Control Descriptor */
>>>>>> +
>>>>>> +       u32             des1;   /* Reserved */
>>>>> What is the default value of these _Reserved_ descriptors? As these
>>>>> are pointers, do you thing initializing then to zero make sense?
>>
>> We don't think it's required to assign zero to reserved des field as mobster core not going to use this field's for any operations unless user has modified it.
>> Also it's working fine in our test set-up without initializing them to zero.

Right, it's not required to assign zero to there. And It's working fine, because it's not used or referred anywhere.
Just Recommend to initialize to zero.
Actually, i don't understand why des1 is reserved..

>>
>>>>
>>>> I think the default reset value of these descriptors will depend on
>>>> how dwmmc is integrated in h/w and how these descriptors are then
>>>> configured.
>>>>
>>>> So it makes sense to initialize these descriptors to zero before use.
>>>> We have seen on our exynos7 system, that we need to initialize the
>>>> descriptors des1 and des2 to zero before we use them further.
>>
>> It looks like exynos7 is using this reserved fields for some other purposes. To make it generic, we will initialize the reserved fields to zero.
>>
>> Does exynos7 requires des2 (Buffer sizes) also to be initialized to zero?
> 
> Yes, we need des2 to be initialized to zero.
> One question however, do we have some default reset value set to these
> descriptors ? If yes then how can we check this value ?

I knew it doesn't have the reset value for descriptors.

Best Regards,
Jaehoon Chung

> I just tried printing the value of des1 and des2 in dw_mci_translate_sglist()
> where we are assigning these descriptors.
> 
>>
>>>
>>> I agreed with Vivek and Alim's comment.
>>>
>>> And I think you can fix the below compile warning.
>>>
>>> drivers/mmc/host/dw_mmc.c: In function ‘dw_mci_idmac_init’:
>>> drivers/mmc/host/dw_mmc.c:542:21: warning: right shift count >= width of
>>> type [enabled by default]
>>> drivers/mmc/host/dw_mmc.c:547:3: warning: right shift count >= width of
>>> type [enabled by default]
>>> drivers/mmc/host/dw_mmc.c:575:3: warning: right shift count >= width of
>>> type [enabled by default]
>>>
>>> I will check this patch with 2.70a and other version.
>>>
>>
>> We will fix the warnings and post the new patch.
>>
>> Regards,
>> Prabu Thangamuthu.
>>
> 
> 
> 

