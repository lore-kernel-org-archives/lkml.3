Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab3KKK6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:58:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38432 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3KKK6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:58:00 -0500
X-AuditID: cbfee68f-b7f836d000001b39-7b-5280b8364d8c
Message-id: <5280B836.2050203@samsung.com>
Date: Mon, 11 Nov 2013 19:57:58 +0900
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
In-reply-to: <20131111105356.GB22184@lee--X1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWyRsSkWNdsR0OQwflpJhb/ptxgt7j/9Sij
	xeVdc9gsbjeuYLNY/vY/m8XpblYHNo871/awecw7GejxcuJvNo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKWPJNueAed8W2+UINjNc5uxg5OSQETCSezP/DDmGLSVy4t56ti5GLQ0hgKaPE
	6oOrWWGKvu9eyAKRmM4o8XHyWijnFaPEtB+HwNp5BbQkzr1ZDWazCKhKLFp6AMxmA4rvf3GD
	DcQWFQiTWDn9CgtEvaDEj8n3gGwODhEBFaBec5CZzAIbGCVW/t8E1issEC5x8UwvWD3Y5mnz
	RUBsTgFdiS8zIc5mFlCXmDRvETOELS+xec1bZpBBEgL72CUefj3JCnGQgMS3yYfAlkkIyEps
	OsAM8ZmkxMEVN1gmMIrNQnLSLCRjZyEZu4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZG
	YJyd/vesfwfj3QPWhxiTgVZOZJYSTc4HxmleSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmk
	J5akZqemFqQWxReV5qQWH2Jk4uCUamCcejmLbXGWm6+hbsMq3f3J6rPmrDPO83C2Lmg3nHSP
	PYZ5S/LvuXk+LhLzZbosT33Z182jIJMnaly9/2PhzW8MPzwfm3K9/hyTcvRYyt4Qh+3SkmF3
	ZxeZzWrfITDzxoq8yC6pkq7LDhkzOaecOqYW4OV7LvrnWwPv6YssZ9Z/1fCuqtt2+aMSS3FG
	oqEWc1FxIgCRWMK1yQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jQV2zHQ1BBsuX6Fr8m3KD3eL+16OM
	Fpd3zWGzuN24gs1i+dv/bBanu1kd2DzuXNvD5jHvZKDHy4m/2Tz6tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aSb8oF97grts0XamC8ztnFyMkhIWAi
	8X33QhYIW0ziwr31bF2MXBxCAtMZJT5OXssC4bxilJj24xA7SBWvgJbEuTerwWwWAVWJRUsP
	gNlsQPH9L26wgdiiAmESK6dfYYGoF5T4MfkekM3BISKgAtRrDjKTWWADo8TK/5vAeoUFwiUu
	nukFqwfbPG2+CIjNKaAr8WXmH7AaZgF1iUnzFjFD2PISm9e8ZZ7AKDALyYpZSMpmISlbwMi8
	ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4ip9J72Bc1WBxiFGAg1GJhzdCoSFIiDWxrLgy
	9xCjBAezkgjvvSVAId6UxMqq1KL8+KLSnNTiQ4zJwBCYyCwlmpwPTDB5JfGGxiZmRpZG5oYW
	RsbmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cBorer38vqavZUn+Zx3Bu9X1bnmyJe7
	50bPdBtr5sR3wRIzP1nfZ4m88St0Vue/ieb7ak79n/2j5czE29G35i199GDJqYkpTFeuPP9j
	ulNbPrWD3TLR7byueDbjrU9XhfNe3dq+K97RpjvKQ2r/lZcXcu0bDn968Lz8yuyaiz0f7qfe
	WXxKmenBAyWW4oxEQy3mouJEAAbxvHUmAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 07:53 PM, Lee Jones wrote:
>> On 11/08/2013 10:19 PM, Charles Keepax wrote:
>>> Improve readability by creating a define for each microphone detection
>>> level.
>>>
>>> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
>>> ---
>>>  drivers/extcon/extcon-arizona.c       |   21 ++++++++++++++++-----
>>>  include/linux/mfd/arizona/registers.h |    9 +++++++++
>>>  2 files changed, 25 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
>>> index 3c55ec8..6d914ba 100644
>>> --- a/drivers/extcon/extcon-arizona.c
>>> +++ b/drivers/extcon/extcon-arizona.c
>>> @@ -44,6 +44,17 @@
>>>  #define HPDET_DEBOUNCE 500
>>>  #define DEFAULT_MICD_TIMEOUT 2000
>>>  
>>> +enum {
>>> +	MICD_LVL_1_TO_7 = ARIZONA_MICD_LVL_1 | ARIZONA_MICD_LVL_2 |
>>> +			  ARIZONA_MICD_LVL_3 | ARIZONA_MICD_LVL_4 |
>>> +			  ARIZONA_MICD_LVL_5 | ARIZONA_MICD_LVL_6 |
>>> +			  ARIZONA_MICD_LVL_7,
>>> +
>>> +	MICD_LVL_0_TO_7 = ARIZONA_MICD_LVL_0 | MICD_LVL_1_TO_7,
>>> +
>>> +	MICD_LVL_0_TO_8 = MICD_LVL_0_TO_7 | ARIZONA_MICD_LVL_8,
>>> +};
>>
>> MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8 haven't the sequential value.
>> I prefer '#define' keyword to define MICD_LVL_1_TO_7 / MICD_LVL_0_TO_7 /MICD_LVL_0_TO_8
>> instead of enum keyword.
> 
> Actually Charles has already sent me this patch and I applied it a
> while ago.
> 

Why did you applied extcon driver patch on your tree?



