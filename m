Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaICG4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:56:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24448 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaICG4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:56:07 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-f79536d000000fd1-07-5406bb853df5
Content-transfer-encoding: 8BIT
Message-id: <5406BB85.1050903@samsung.com>
Date: Wed, 03 Sep 2014 15:56:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: jonghwa3.lee@samsung.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        r.baldyga@samsung.com
Subject: Re: [PATCH] extcon: max77693: Fix a bug occured at changing ADC
 debounce time.
References: <1409723407-21221-1-git-send-email-jonghwa3.lee@samsung.com>
 <5406AD6C.3090306@samsung.com> <5406B786.3020301@samsung.com>
In-reply-to: <5406B786.3020301@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSpNu6my3E4PwhWYvOs0+YLS7vmsNm
	cbtxBZvFg8M72R1YPPq2rGL0+LxJLoApissmJTUnsyy1SN8ugStj0h71glsCFT2XfrM2MN7g
	7WLk5JAQMJH4P+UdG4QtJnHh3nowW0hgKaPE94ZkmJq5//czdTFyAcUXMUqsnTQJrIhXQFDi
	x+R7LF2MHBzMAvISRy5lg4SZBdQlJs1bxAxR/5pRomfCRxaIei2JlpebwHpZBFQl/ly8yQhi
	swHF97+4ARYXFQiTWDn9Cli9iICMxMqrP5kghgZLTNrTwQxiCwtEStx8tpkRYkEHo8Sq10/A
	ijgFtCWurP/GApKQEFjELrHs0QNWiG0CEt8mHwK7VEJAVmLTAWaIzyQlDq64wTKBUWwWkn9m
	IfwzC8k/CxiZVzGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIExs3pf8/6djDePGB9iFGAg1GJ
	h3dBAFuIEGtiWXFl7iFGU6AjJjJLiSbnA6MzryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpi
	SWp2ampBalF8UWlOavEhRiYOTqkGxjZ+613HS156Bz8RqXwZtUbuQlxGlsa1k1UrrM5UNB03
	nrz2uOymhzfdt4jzl2+a2+4y8eaExUkfqotM34uwSpnMamnZdCP1zIaC8ra4JK3EX5P9RZUn
	NSkyr31p5O10ibV1QvX3j3KJoksZgje+ndt8s0hjQ1NNSG7tUfbNR//7GNp6Z0okKLEUZyQa
	ajEXFScCAPzDiduWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jAd3W3WwhBlNmill0nn3CbHF51xw2
	i9uNK9gsHhzeye7A4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGZP2qBfcEqjoufSbtYHxBm8XIyeHhICJxNz/+5kgbDGJC/fWs3UxcnEICSxilFg7
	aRIbSIJXQFDix+R7LF2MHBzMAvISRy5lg4SZBdQlJs1bxAxR/5pRomfCRxaIei2JlpebwHpZ
	BFQl/ly8yQhiswHF97+4ARYXFQiTWDn9Cli9iICMxMqrP5kghgZLTNrTwQxiCwtEStx8tpkR
	YkEHo8Sq10/AijgFtCWurP/GMoFRYBaS+2Yh3DcLyX0LGJlXMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgTH5TOpHYwrGywOMQpwMCrx8C4IYAsRYk0sK67MPcQowcGsJMLrmwgU4k1JrKxK
	LcqPLyrNSS0+xGgK9N1EZinR5HxgysgriTc0NjEzsjQyN7QwMjZXEuc90GodKCSQnliSmp2a
	WpBaBNPHxMEp1cDYp8Uzw+3kpXk7a5e0rC06tp1L6t5UtfNl+nsLPEP1+j0m6l+dHWl5xVTU
	epfsMgPbTakTN8hEcu6/eeyTp8PSF3+NBJas117QFfHf/uuUZe+zHv0+8XuaNcufbzkfE1Xd
	9yn4XLkh22aQyvVx0X/lF3Nf/9L/r+mruYhNQ1VGVWW+vz1HXaicEktxRqKhFnNRcSIAthGF
	HeECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 03:39 PM, jonghwa3.lee@samsung.com wrote:
> On 2014년 09월 03일 14:55, Chanwoo Choi wrote:
> 
>> On 09/03/2014 02:50 PM, Jonghwa Lee wrote:
>>> When it writes some value other than 0 to BTLDset and JIGset, muic device
>>> will be reset automatically. And it happens during updating ADC debounce time,
>>> because it shares same register. To update ADC debounce time without reset,
>>> set value only to ADCDbset and 0 to BTLDset and JIGset.
>>>
>>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>> ---
>>>  drivers/extcon/extcon-max77693.c |   11 ++++++++---
>>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
>>> index 77460f2..661a3bb 100644
>>> --- a/drivers/extcon/extcon-max77693.c
>>> +++ b/drivers/extcon/extcon-max77693.c
>>> @@ -255,10 +255,15 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
>>>  	case ADC_DEBOUNCE_TIME_10MS:
>>>  	case ADC_DEBOUNCE_TIME_25MS:
>>>  	case ADC_DEBOUNCE_TIME_38_62MS:
>>> -		ret = regmap_update_bits(info->max77693->regmap_muic,
>>> +		/*
>>> +		 * Don't touch BTLDset, JIGset when you want to change adc
>>> +		 * debounce time. BTLDset, JIGset reflects actual pin status
>>> +		 * and are not configurable.
>>> +		 */
>>> +		ret = regmap_write_bits(info->max77693->regmap_muic,
>>>  					  MAX77693_MUIC_REG_CTRL3,
>>> -					  CONTROL3_ADCDBSET_MASK,
>>> -					  time << CONTROL3_ADCDBSET_SHIFT);
>>> +					  (CONTROL3_ADCDBSET_MASK &
>>> +					  time << CONTROL3_ADCDBSET_SHIFT));
>>
>> Do you make this patch on extcon-next branch?
>>
>> The max77693_muic_set_debounce_time() of extcon-max77693.c
>> use regmap_update_bits instead of regmap_write_bits as following:
> 
> 
> This patch intends to use 'regmap_write_bits()' not 'regmap_update_bits()'.

You're right. It is my mistake to review this patch.

> With using regmap_update_bits(), it would writes some value to BTLDset and
> JIGset then muic device will loose current state.

OK, I'll apply yout next patch(v2).

Thanks,
Chanwoo Choi
