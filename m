Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaICHKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:10:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:35619 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaICHKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:10:01 -0400
X-AuditID: cbfee691-f79546d0000011a1-2e-5406bec28106
Message-id: <5406BEC2.60801@samsung.com>
Date: Wed, 03 Sep 2014 16:09:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        r.baldyga@samsung.com
Subject: Re: [PATCH v2] extcon: max77693: Fix a bug occured at changing ADC
 debounce time.
References: <1409726878-25781-1-git-send-email-jonghwa3.lee@samsung.com>
In-reply-to: <1409726878-25781-1-git-send-email-jonghwa3.lee@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSoHtoH1uIQccRTYvOs0+YLS7vmsNm
	cbtxBZvFg8M72R1YPPq2rGL0+LxJLoApissmJTUnsyy1SN8ugSvj0PTnTAXf+CpeT9NqYGzg
	6WLk5JAQMJFY+O0YC4QtJnHh3nq2LkYuDiGBpYwSv08/YoEpmjr3EDOILSSwiFHi5SNFiKLX
	jBJtB2cygiR4BTQk9p7vYAWxWQRUJV7/fA3WwCagJbH/xQ02EFtUIExi5fQrLBD1ghI/Jt8D
	s0WAaq49fgc2h1kgWGLSng6wXmGBGIl3HTehFntIXGlawwRicwp4Siz8OYcVol5HYn/rNDYI
	W15i85q3zCDHSQhMZ5eYvXoxI8RBAhLfJh8CWsYBlJCV2HSAGeIxSYmDK26wTGAUm4XkpFlI
	xs5CMnYBI/MqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjMDIOf3v2cQdjPcPWB9iFOBgVOLh
	XRDAFiLEmlhWXJl7iNEU6IqJzFKiyfnA+MwriTc0NjOyMDUxNTYytzRTEufVkf4ZLCSQnliS
	mp2aWpBaFF9UmpNafIiRiYNTqoFRwuuOe2uTNkMLj4iUf8s+QeF5Iva1kx4a3FqQuemVc4TG
	N9s6oaClBxnbZ2Uf7dsocNDhtklstf/RKJnOM1d8zbMvLppuqM261tgo7q5G9ZpH7KU3VDds
	j2Q/ryo5Qe6Ml/iWmfP2uF27+klFgbN/OfOqlypXzia8Vp2nklR7/F3hwVmBIkeVWIozEg21
	mIuKEwGWqSaclwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t9jAd1D+9hCDFb+krfoPPuE2eLyrjls
	FrcbV7BZPDi8k92BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYMw5Nf85U8I2v4vU0rQbGBp4uRk4OCQETialzDzFD2GISF+6tZwOxhQQWMUq8fKTY
	xcgFZL9mlGg7OJMRJMEroCGx93wHK4jNIqAq8frna7BmNgEtif0vboA1iwqESaycfoUFol5Q
	4sfke2C2CFDNtcfvwOYwCwRLTNrTAdYrLBAj8a7jJjPEYg+JK01rmEBsTgFPiYU/57BC1OtI
	7G+dxgZhy0tsXvOWeQKjwCwkK2YhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxN
	jOC4fCa1g3Flg8UhRgEORiUe3gUBbCFCrIllxZW5hxglOJiVRHh9E4FCvCmJlVWpRfnxRaU5
	qcWHGE2BITCRWUo0OR+YMvJK4g2NTcyMLI3MDS2MjM2VxHkPtFoHCgmkJ5akZqemFqQWwfQx
	cXBKNTBO+Hh12uTt39xcKzd8UWOR4P7a8fzOLoXPBqu3m4fPWm+09tcO3w3lyW1PRGW+LuDM
	k96ov2P+BzHpm4cYfDluHrm27dXkOdzPw72UDu6efoDnCyfnmh13HmnYqM7sWrjOMcct39Zy
	hY19/5uJ5k6bffsi9y0rMvhY8PlWTPF51lOv9/grPY3yUWIpzkg01GIuKk4EAJmAXI3hAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonghwa,

On 09/03/2014 03:47 PM, Jonghwa Lee wrote:
> When it writes some value other than 0 to BTLDset and JIGset, muic device
> will be reset automatically. And it happens during updating ADC debounce time,
> because it shares same register. To update ADC debounce time without reset,
> set value only to ADCDbset and 0 to BTLDset and JIGset.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
> Changes in v2
>  - Fix comments.
> 
>  drivers/extcon/extcon-max77693.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 77460f2..171f35a 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -255,10 +255,15 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
>  	case ADC_DEBOUNCE_TIME_10MS:
>  	case ADC_DEBOUNCE_TIME_25MS:
>  	case ADC_DEBOUNCE_TIME_38_62MS:
> -		ret = regmap_update_bits(info->max77693->regmap_muic,
> +		/*
> +		 * Don't touch BTLDset, JIGset when you want to change adc
> +		 * debounce time. If it writes other than 0 to BTLDset, JIGset
> +		 * muic device will be reset and loose current state.
> +		 */
> +		ret = regmap_write_bits(info->max77693->regmap_muic,

regmap_write_bits() is wrong. You have to use regmap_write().

>  					  MAX77693_MUIC_REG_CTRL3,
> -					  CONTROL3_ADCDBSET_MASK,
> -					  time << CONTROL3_ADCDBSET_SHIFT);
> +					  (CONTROL3_ADCDBSET_MASK &
> +					  time << CONTROL3_ADCDBSET_SHIFT));

I think you don't need to mask with CONTROL3_ADCDBSET_MASK.
You can just write following statement wihtout masking operation
because of using regmap_write() function.

		ret = regmap_write(info->max77693->regmap_muic,			
  				  MAX77693_MUIC_REG_CTRL3,
				  time << CONTROL3_ADCDBSET_SHIFT);

Thanks,
Chanwoo Choi
