Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaICFz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:55:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27346 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbaICFz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:55:58 -0400
X-AuditID: cbfee691-f79546d0000011a1-cf-5406ad6c1027
Message-id: <5406AD6C.3090306@samsung.com>
Date: Wed, 03 Sep 2014 14:55:56 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        r.baldyga@samsung.com
Subject: Re: [PATCH] extcon: max77693: Fix a bug occured at changing ADC
 debounce time.
References: <1409723407-21221-1-git-send-email-jonghwa3.lee@samsung.com>
In-reply-to: <1409723407-21221-1-git-send-email-jonghwa3.lee@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSqJuzli3EYMN+ZYvOs0+YLS7vmsNm
	cbtxBZvFg8M72R1YPPq2rGL0+LxJLoApissmJTUnsyy1SN8ugSvj788+1oL//BU3Ny9mb2D8
	ztPFyMkhIWAiMf/PKnYIW0ziwr31bF2MHBxCAksZJV7YwJTs2LiWtYuRCyi8iFFi8dzbbBDO
	a0aJ/x07WECqeAW0JG493sIKYrMIqEqs+L+HCcRmA4rvf3GDDcQWFQiTWDn9ClS9oMSPyffA
	bBGgmmuP3zGC2MwCwRKT9nQwg9jCApESN59tBosLCXhIdHZ2g8U5BTwltrz4BVWvI7G/dRob
	hC0vsXnNW2aQ4yQEprNLrFnziQniIAGJb5MPsYB8JiEgK7HpADPEZ5ISB1fcYJnAKDYLyUmz
	kIydhWTsAkbmVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiBkXP637OJOxjvH7A+xCjAwajE
	w7sggC1EiDWxrLgy9xCjKdAVE5mlRJPzgfGZVxJvaGxmZGFqYmpsZG5ppiTOqyP9M1hIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDY+ysl0t+r/pa87ZewLPslXw9ownX+rMb7vNvK1rq2jMh
	2LP8AbPnNf/1wn28W4TCVpgodtsXnNo18due/puM26yvL5Wf+4Nv+e+DCTWPVlzpuZl7xHoO
	s61WKsOvLwkng7gXsHI//OpqGedtEevykam1a7/ehrKWe682lUzWPKLBtzHe9GTrTSWW4oxE
	Qy3mouJEAK7wFviXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd2ctWwhBpcny1h0nn3CbHF51xw2
	i9uNK9gsHhzeye7A4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGX9/9rEW/OevuLl5MXsD43eeLkZODgkBE4kdG9eyQthiEhfurWfrYuTiEBJYxCix
	eO5tKOc1o8T/jh0sIFW8AloStx5vAetgEVCVWPF/DxOIzQYU3//iBhuILSoQJrFy+hWoekGJ
	H5PvgdkiQDXXHr9jBLGZBYIlJu3pYAaxhQUiJW4+2wwWFxLwkOjs7AaLcwp4Smx58QuqXkdi
	f+s0NghbXmLzmrfMExgFZiFZMQtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525i
	BMfmM+kdjKsaLA4xCnAwKvHwLghgCxFiTSwrrsw9xCjBwawkwuubCBTiTUmsrEotyo8vKs1J
	LT7EaAoMgYnMUqLJ+cC0kVcSb2hsYmZkaWRuaGFkbK4kznuw1TpQSCA9sSQ1OzW1ILUIpo+J
	g1OqgdFTbf9H42+azUfO7tBw4AvLFyi6ZlhtJFhVxxA+4+/VuBMnclu3dQg62Z6YFXp15ZXV
	m5Zxr3uRU/G+4dmjVesnZOSX5DjsTpJZulpfd7riZu6tvcqJSsfkJ26bnvrhmvqp7rXqk1fb
	BeQZuTBNv3poQd1CpbUz7zadD3sooc/9onHxKc5+ofdKLMUZiYZazEXFiQCOrH6L4wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 02:50 PM, Jonghwa Lee wrote:
> When it writes some value other than 0 to BTLDset and JIGset, muic device
> will be reset automatically. And it happens during updating ADC debounce time,
> because it shares same register. To update ADC debounce time without reset,
> set value only to ADCDbset and 0 to BTLDset and JIGset.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 77460f2..661a3bb 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -255,10 +255,15 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
>  	case ADC_DEBOUNCE_TIME_10MS:
>  	case ADC_DEBOUNCE_TIME_25MS:
>  	case ADC_DEBOUNCE_TIME_38_62MS:
> -		ret = regmap_update_bits(info->max77693->regmap_muic,
> +		/*
> +		 * Don't touch BTLDset, JIGset when you want to change adc
> +		 * debounce time. BTLDset, JIGset reflects actual pin status
> +		 * and are not configurable.
> +		 */
> +		ret = regmap_write_bits(info->max77693->regmap_muic,
>  					  MAX77693_MUIC_REG_CTRL3,
> -					  CONTROL3_ADCDBSET_MASK,
> -					  time << CONTROL3_ADCDBSET_SHIFT);
> +					  (CONTROL3_ADCDBSET_MASK &
> +					  time << CONTROL3_ADCDBSET_SHIFT));

Do you make this patch on extcon-next branch?

The max77693_muic_set_debounce_time() of extcon-max77693.c
use regmap_update_bits instead of regmap_write_bits as following:

	switch (time) {
	case ADC_DEBOUNCE_TIME_5MS:
	case ADC_DEBOUNCE_TIME_10MS:
	case ADC_DEBOUNCE_TIME_25MS:
	case ADC_DEBOUNCE_TIME_38_62MS:
		ret = regmap_update_bits(info->max77693->regmap_muic,
					  MAX77693_MUIC_REG_CTRL3,
					  CONTROL3_ADCDBSET_MASK,
					  time << CONTROL3_ADCDBSET_SHIFT);
		if (ret) {
			dev_err(info->dev, "failed to set ADC debounce time\n");
			return ret;
		}


Thanks,
Chanwoo Choi


