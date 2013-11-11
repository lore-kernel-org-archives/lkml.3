Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3KKLWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:22:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41063 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3KKLWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:22:42 -0500
X-AuditID: cbfee691-b7f866d000001b8c-63-5280be018d09
Message-id: <5280BE00.8030002@samsung.com>
Date: Mon, 11 Nov 2013 20:22:40 +0900
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
 <20131111110652.GD6549@opensource.wolfsonmicro.com>
 <20131111111503.GC22184@lee--X1>
In-reply-to: <20131111111503.GC22184@lee--X1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkSJdxX0OQweI3XBb/ptxgt7j/9Sij
	xeVdc9gsbjeuYLNY/vY/m8XpblYHNo871/awecw7GejxcuJvNo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DK+LD4DFPBS6GKo3MeMTcwruDvYuTkkBAwkXi5eSY7hC0mceHeerYuRi4OIYGl
	jBLdL44ywxR9X/+JBSKxiFFiTes5VgjnFaPEoclb2UCqeAW0JJ7s6ATrYBFQlVg14yYriM0G
	FN//4gZYjahAmMTK6VdYIOoFJX5Mvgdkc3CICKhInHtjDjKTWWADo8TK/5vAThIWCJe4eKYX
	avMHRonp53eAJTgFdCV+X94NZjMLqEtMmreIGcKWl9i85i3U2afYJY5Oy4A4SEDi2+RDYMsk
	BGQlNh2AKpGUOLjiBssERrFZSE6ahWTqLCRTFzAyr2IUTS1ILihOSi8y1StOzC0uzUvXS87P
	3cQIjLXT/55N3MF4/4D1IcZkoJUTmaVEk/OBsZpXEm9obGZkYWpiamxkbmlGmrCSOG/6o6Qg
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwVWf3sV5+fK/3+aubdjBXKP18YxP97adq5oVdD
	S32VqtTXqVNKFxhU2bEYSzUcFuL2ncx9+ova7uW/uE5P3P5c5VrQzAJj43UhD2NUwqWvaL0W
	6zi4x27NcyXtpytf+kucSt/8br5g0Zdmx1X6E3fnT7Ps2yhzgGn2pMDpZXfkHOwqX0ofXJGs
	xFKckWioxVxUnAgA8UI+H8sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAV3GfQ1BBj9PM1n8m3KD3eL+16OM
	Fpd3zWGzuN24gs1i+dv/bBanu1kd2DzuXNvD5jHvZKDHy4m/2Tz6tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aHxWeYCl4KVRyd84i5gXEFfxcjJ4eE
	gInE9/WfWCBsMYkL99azdTFycQgJLGKUWNN6jhXCecUocWjyVjaQKl4BLYknOzqZQWwWAVWJ
	VTNusoLYbEDx/S9ugNWICoRJrJx+hQWiXlDix+R7QDYHh4iAisS5N+YgM5kFNjBKrPy/iR2k
	RlggXOLimV4WiGUfGCWmn98BluAU0JX4fXk3mM0soC4xad4iZghbXmLzmrfMExgFZiHZMQtJ
	2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfyM6kdjCsbLA4xCnAwKvHwRig0
	BAmxJpYVV+YeYpTgYFYS4b23BCjEm5JYWZValB9fVJqTWnyIMRkYBBOZpUST84FpJq8k3tDY
	xMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGJfX3q/mn7J+/7UlvNmG
	e2Z8+b7sYe5GTcHVu5xPZchtv6zwU31eg3J7kXoxu/OGLeyXjizc7rX1VNntx1x6lQreZUI/
	j+cJbO+dtcvAYCLr3MsfPaYdZdyp8Sxwofa6yQzzdgXZbH1wrXHK05rc4rxUnhZerg9OUg8K
	qxf8TX2/5R23W6qG50QlluKMREMt5qLiRAC/cvC2KQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 08:15 PM, Lee Jones wrote:
> On Mon, 11 Nov 2013, Charles Keepax wrote:
> 
>> On Mon, Nov 11, 2013 at 10:53:56AM +0000, Lee Jones wrote:
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
>>
>>
>> I will do an incremental patch to update them to defines.
>>
>>
>>> Actually Charles has already sent me this patch and I applied it a
>>> while ago.
>>>
>>> I'm inclined to agree with you though, so if you want to send a patch
>>> based on v3.14-rc1 I'd be happy to accept it.
>>
>> Apologies for causing confusion here I checked your tree for the
>> patch and didn't see it, so I assumed you had decided not to
>> apply it. I must have missed it some how.
> 
> So I am partly to blame here. My public repos sometimes aren't as
> up-to-date and my private ones, but if I've replied to a patch and
> said I've applied it, I inevitably have.
> 

But this patch has only the dependency of extcon subsystem.
At least, you have to get 'Acked-by' or 'Signed-off-by' from
subsystem maintainer. I didn't agree applying this patch on mainline tree.






