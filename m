Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaIVHWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:22:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27588 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaIVHWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:22:08 -0400
X-AuditID: cbfee691-f79b86d000004a5a-b5-541fce1c88bc
Message-id: <541FCE1B.7010101@samsung.com>
Date: Mon, 22 Sep 2014 16:22:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        r.baldyga@samsung.com
Subject: Re: [PATCH v3] extcon: max77693: Fix a bug occured at changing ADC
 debounce time.
References: <1410926323-8234-1-git-send-email-jonghwa3.lee@samsung.com>
In-reply-to: <1410926323-8234-1-git-send-email-jonghwa3.lee@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSoCtzTj7EYP4PXovOs0+YLS7vmsNm
	cbtxBZvFg8M72R1YPPq2rGL0+LxJLoApissmJTUnsyy1SN8ugStj0fFzrAVT+So6b5U0MC7n
	7mLk5JAQMJGYfOoKC4QtJnHh3nq2LkYuDiGBpYwSV9auZIUp+tvzkx0isYhR4uiER1BVrxkl
	Fl05zwRSxSugJfGq/Rs7iM0ioCrxctcdsG42oPj+FzfYQGxRgTCJldMh1vEKCEr8mHwPzBYB
	qrn2+B0jiM0sECwxaU8HM4gtLBAjsf3CQbCZQgLuElO2TwKr5xTwkPixajsLRL2OxP7WaWwQ
	trzE5jVvmUGOkxCYxy6x9MFLNoiDBCS+TT4E1MABlJCV2HSAGeIzSYmDK26wTGAUm4XkpFlI
	xs5CMnYBI/MqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjMDYOf3v2cQdjPcPWB9iFOBgVOLh
	/dEiHyLEmlhWXJl7iNEU6IqJzFKiyfnACM0riTc0NjOyMDUxNTYytzRTEufVkf4ZLCSQnliS
	mp2aWpBaFF9UmpNafIiRiYNTqoFR68rjzUcTm/Z+q9jK1xauyFx8pmBzvskHwWUXnrfpphye
	a3l64Vv9vW+/TuObm7wkt7zTaqpn7hzF3r3zF/tdyeawuH4jWfvZ442c3ds9PCcHCK9avPUy
	V4f14evGr1R3+sfnPjN2Fg/yUfwos3o747eJqtcKltbJF936+kHTcfvGfQmV/WE/lViKMxIN
	tZiLihMBvuxzyJgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jAV2Zc/IhBrvusll0nn3CbHF51xw2
	i9uNK9gsHhzeye7A4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGYuOn2MtmMpX0XmrpIFxOXcXIyeHhICJxN+en+wQtpjEhXvr2boYuTiEBBYxShyd
	8AjKec0osejKeSaQKl4BLYlX7d/AOlgEVCVe7rrDCmKzAcX3v7jBBmKLCoRJrJx+hQWiXlDi
	x+R7YLYIUM21x+8YQWxmgWCJSXs6mEFsYYEYie0XDoLNFBJwl5iyfRJYPaeAh8SPVdtZIOp1
	JPa3TmODsOUlNq95yzyBUWAWkhWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwZD6T2sG4ssHiEKMAB6MSD++CJvkQIdbEsuLK3EOMEhzMSiK8R3OAQrwpiZVVqUX58UWl
	OanFhxhNgSEwkVlKNDkfmDTySuINjU3MjCyNzA0tjIzNlcR5D7RaBwoJpCeWpGanphakFsH0
	MXFwSjUwbus7yHk/NPaQ38yFSYbryw4+mv2Wcf0KXTvfS0vLtnzbFXx31lrnmV71b84X/bXo
	5Z1+QO7Uh5Jv++Tmnz8tuOi/6Xoep8mPIyXLnpxSqDpYZhZYr7Kmd1V5kcbE51liPFKuUd9W
	Ciz0f67gadh54bdu4q0b1ra619IfBa6wvfdq29zTC15e11RiKc5INNRiLipOBADXyRwD4gIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 12:58 PM, Jonghwa Lee wrote:
> When it writes some value other than 0 to BTLDset and JIGset, muic device
> will be reset automatically. And it happens during updating ADC debounce time,
> because it shares same register. To update ADC debounce time without reset,
> set value only to ADCDbset and 0 to BTLDset and JIGset.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
> Changes:
> v3:	- Fix typo (regmap_write_bits -> regmap_write)
> v2:	- Fix comments.
> 
>  drivers/extcon/extcon-max77693.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 77460f2..132540e 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -255,10 +255,15 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
>  	case ADC_DEBOUNCE_TIME_10MS:
>  	case ADC_DEBOUNCE_TIME_25MS:
>  	case ADC_DEBOUNCE_TIME_38_62MS:
> -		ret = regmap_update_bits(info->max77693->regmap_muic,
> -					  MAX77693_MUIC_REG_CTRL3,
> -					  CONTROL3_ADCDBSET_MASK,
> -					  time << CONTROL3_ADCDBSET_SHIFT);
> +		/*
> +		 * Don't touch BTLDset, JIGset when you want to change adc
> +		 * debounce time. If it writes other than 0 to BTLDset, JIGset
> +		 * muic device will be reset and loose current state.
> +		 */
> +		ret = regmap_write(info->max77693->regmap_muic,
> +				  MAX77693_MUIC_REG_CTRL3,
> +				  (CONTROL3_ADCDBSET_MASK &
> +				  time << CONTROL3_ADCDBSET_SHIFT));

I think that masking operation is not necessary. I drop this operation and apply it.

>  		if (ret) {
>  			dev_err(info->dev, "failed to set ADC debounce time\n");
>  			return ret;
> 

Applied.

Thanks,
Chanwoo Choi
