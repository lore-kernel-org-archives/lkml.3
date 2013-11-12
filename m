Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3KLABF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:01:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:62759 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3KLAA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:00:56 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-b7-52816fb6498e
Message-id: <52816FB6.6070907@samsung.com>
Date: Tue, 12 Nov 2013 09:00:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        myungjoo.ham@samsung.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] extcon: arizona: Add defines for microphone detection
 levels
References: <1383916783-17921-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <5280AAAF.8040005@samsung.com> <20131111105356.GB22184@lee--X1>
 <5280B836.2050203@samsung.com> <20131111111913.GD22184@lee--X1>
In-reply-to: <20131111111913.GD22184@lee--X1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkUHdbfmOQwbVuVYt/U26wW9z/epTR
	4vKuOWwWtxtXsFksf/ufzeJ0N6sDm8eda3vYPOadDPR4OfE3m0ffllWMHp83yQWwRnHZpKTm
	ZJalFunbJXBlnN4+k72gj69i2vZ1TA2M57m7GDk5JARMJOb1bWOGsMUkLtxbzwZiCwksZZT4
	ussDpmbdwtNANVxA8emMErPvf2SEcF4xSkx5OZ0FpIpXQEtizuQDYJNYBFQlGl4vAouzAcX3
	v7gBNlVUIExi5fQrUPWCEj8m3wOyOThEBFQkzr0xB5nJLLCBUWLl/03sIDXCAuESF8/0skAs
	u8ko8fDRS7AFnAK6Emc3f2YEsZkF1CUmzVvEDGHLS2xe8xbsVAmBY+wSS5btZoO4SEDi2+RD
	YNskBGQlNh2AellS4uCKGywTGMVmIblpFpKxs5CMXcDIvIpRNLUguaA4Kb3ISK84Mbe4NC9d
	Lzk/dxMjMNZO/3vWt4Px5gHrQ4zJQCsnMkuJJucDYzWvJN7Q2MzIwtTE1NjI3NKMNGElcd5F
	D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBa+Bw9EypmVM92WJu72+fRFZcLv89OFH+0
	fmXAbOvOjwENLrcDuOSTchXetX/o7dvaJvZz+13vdccSGgqP/nUPF33mtVx2R3yr+2X28MId
	acHdC7feie6OSL4W/sJ3U/e29byeLM0Mpc+5n93R9FM5nzK/s/oew54mibQ79XwJO2Ysblu8
	vVKJpTgj0VCLuag4EQBC5aq/ywIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQd1t+Y1BBlc+yVj8m3KD3eL+16OM
	Fpd3zWGzuN24gs1i+dv/bBanu1kd2DzuXNvD5jHvZKDHy4m/2Tz6tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bp7TPZC/r4KqZtX8fUwHieu4uRk0NC
	wERi3cLTzBC2mMSFe+vZuhi5OIQEpjNKzL7/kRHCecUoMeXldBaQKl4BLYk5kw+AdbAIqEo0
	vF4EFmcDiu9/cYMNxBYVCJNYOf0KVL2gxI/J94BsDg4RARWJc2/MQWYyC2xglFj5fxM7SI2w
	QLjExTO9LBDLbjJKPHz0EmwBp4CuxNnNnxlBbGYBdYlJ8xYxQ9jyEpvXvGWewCgwC8mOWUjK
	ZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOJafSe1gXNlgcYhRgINRiYd3B1dj
	kBBrYllxZe4hRgkOZiURXvNcoBBvSmJlVWpRfnxRaU5q8SHGZGAQTGSWEk3OB6aZvJJ4Q2MT
	MyNLI3NDCyNjc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgXOgc8mRSUPC0xU9yPM5f
	f6/q+1AnpzkmK6mo5kP8oYJvwY9Cspgm11nwbbOp5Lt1vqdPWZzRaMPSnNRF6vdtD6m+miF0
	7uGe5VoHz/k/ktko0R5w48hsF4cJr1WrTr/83dDSVjP11UMxEQUxXZ0HvM4vIpwLXJNLPl7z
	SLI+Kvrpit4xhjnNSizFGYmGWsxFxYkANwHmwSkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 08:19 PM, Lee Jones wrote:
> On Mon, 11 Nov 2013, Chanwoo Choi wrote:
> 
>> On 11/11/2013 07:53 PM, Lee Jones wrote:
>>>> On 11/08/2013 10:19 PM, Charles Keepax wrote:
>>>>> Improve readability by creating a define for each microphone detection
>>>>> level.
>>>>>
>>>>> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
>>>>> ---
>>>>>  drivers/extcon/extcon-arizona.c       |   21 ++++++++++++++++-----
>>>>>  include/linux/mfd/arizona/registers.h |    9 +++++++++
>>>>>  2 files changed, 25 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
>>>>> index 3c55ec8..6d914ba 100644
>>>>> --- a/drivers/extcon/extcon-arizona.c
>>>>> +++ b/drivers/extcon/extcon-arizona.c
>>>>> @@ -44,6 +44,17 @@
>>>>>  #define HPDET_DEBOUNCE 500
>>>>>  #define DEFAULT_MICD_TIMEOUT 2000
>>>>>  
>>>>> +enum {
>>>>> +	MICD_LVL_1_TO_7 = ARIZONA_MICD_LVL_1 | ARIZONA_MICD_LVL_2 |
>>>>> +			  ARIZONA_MICD_LVL_3 | ARIZONA_MICD_LVL_4 |
>>>>> +			  ARIZONA_MICD_LVL_5 | ARIZONA_MICD_LVL_6 |
>>>>> +			  ARIZONA_MICD_LVL_7,
>>>>> +
>>>>> +	MICD_LVL_0_TO_7 = ARIZONA_MICD_LVL_0 | MICD_LVL_1_TO_7,
>>>>> +
>>>>> +	MICD_LVL_0_TO_8 = MICD_LVL_0_TO_7 | ARIZONA_MICD_LVL_8,
>>>>> +};
>>>>
>>>> MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8 haven't the sequential value.
>>>> I prefer '#define' keyword to define MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8
>>>> instead of enum keyword.
>>>
>>> Actually Charles has already sent me this patch and I applied it a
>>> while ago.
>>
>> Why did you applied extcon driver patch on your tree?
> 
> Good point, well presented!
> 
> I should have just Acked the MFD parts in this case.
> 

OK, I understand.

Thanks,
Chanwoo Choi

