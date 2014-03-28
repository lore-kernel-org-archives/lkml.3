Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbaC1Awq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 20:52:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57971 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbaC1Awp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 20:52:45 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-d7-5334c7dc6342
Message-id: <5334C7E0.8050803@samsung.com>
Date: Fri, 28 Mar 2014 09:52:48 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] charger-manager: Fix checking of wrong return type
References: <1395921415-17506-1-git-send-email-cw00.choi@samsung.com>
 <1764333.udFThjx8n5@amdc1032>
In-reply-to: <1764333.udFThjx8n5@amdc1032>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWyRsSkUPfOcZNggwu3eC02zljPajHpyXtm
	i4krJzNbnG16w25xedccNovbjSvYHNg8ds66y+6xeYWWR9+WVYwenzfJBbBEcdmkpOZklqUW
	6dslcGVsP/WKueAGT8WRZaeZGhg3cnUxcnJICJhILJv+lwXCFpO4cG89WxcjF4eQwFJGiS3f
	W1lhip7Nf8wIkZjOKPHm4lqoqleMEl0PLzKBVPEKaEncn3wWqIqDg0VAVWLbAnGQMBtQeP+L
	G2wgtqhAmMTK6VdYIMoFJX5MvgdmiwhYSKxd8ZYFZCazQBOjxMH++YwgCWEBP4lLd9vYQWwh
	gVSJ9tfnwOKcQENb9h1iBrGZBXQk9rdOY4Ow5SU2r3nLDDJIQuAQu8TaBQ1gDSwCAhLfJh9i
	ATlOQkBWYtMBZojPJCUOrrjBMoFRbBaSm2YhGTsLydgFjMyrGEVTC5ILipPSi0z1ihNzi0vz
	0vWS83M3MQJj7PS/ZxN3MN4/YH2IMRlo5URmKdHkfGCM5pXEGxqbGVmYmpgaG5lbmpEmrCTO
	m/4oKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDI++CxEnS54xsl+n6hKzuDD7x8JP9hVlH
	HZkO3OfszViTnhP8KZUjckV5wsr+1fx8646sjPowNX6ZNs+Utim/70tncacrmkV6Zl7n+aX2
	KuTFm3sHk0o2hCqkr/ILcEr05+urDtYqfcl3ccknz+nG1TqZOXP0pWRbJvOJsrzYem3Ba63l
	mp4OSizFGYmGWsxFxYkAdhOlrMcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQd07x02CDY6cYLfYOGM9q8WkJ++Z
	LSaunMxscbbpDbvF5V1z2CxuN65gc2Dz2DnrLrvH5hVaHn1bVjF6fN4kF8AS1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYsf3UK+aCGzwVR5adZmpg3MjVxcjJISFgIvFs
	/mNGCFtM4sK99WxdjFwcQgLTGSXeXFwL5bxilOh6eJEJpIpXQEvi/uSzQB0cHCwCqhLbFoiD
	hNmAwvtf3GADsUUFwiRWTr/CAlEuKPFj8j0wW0TAQmLtircsIDOZBZoYJQ72zwfbLCzgJ3Hp
	bhs7iC0kkCrR/vocWJwTaGjLvkPMIDazgI7E/tZpbBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYw
	Mq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7gZ1I7GFc2WBxiFOBgVOLhdbAwCRZiTSwr
	rsw9xCjBwawkwpswDSjEm5JYWZValB9fVJqTWnyIMRkYAhOZpUST84HJJa8k3tDYxMzI0sjc
	0MLI2Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGA+eqvZeUf0+sUA+SO9aTphSRHCN
	9RIxto1Tui3vLUlimHeqcmdDb1HR3+A164xvHNbgSpp04cT97gWRu1ldnhxZVbPV48aNb853
	vmg8vvZIV2tBhmvWjulHbgo+cirU/fhxarZ1R37SzJMaPxWabkxYV3VYMDRi6spv9bGZdjfb
	K7Y/7ZLidlBiKc5INNRiLipOBAAEh/TNJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/28/2014 01:52 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Thursday, March 27, 2014 08:56:55 PM Chanwoo Choi wrote:
>> This patch fix minor issue about checking wrong return type.
>>
>> The of_cm_parse_desc() return ERR_PTR(errnor number) when some error happen
>> in this function. But, charger_manager_probe() has only checked whether
>> desc is NULL or not. If of_cm_parse_desc() returns ERR_PTR(-ENOMEM), desc
>> isn't NULL but desc is (void *)(-ENOMEM). Althouhg some error happen for parsing
>> DT, charger_manager_probe() can't detect error of desc instance.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> ---
>>  drivers/power/charger-manager.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
>> index 9e4dab4..a10fb57 100644
>> --- a/drivers/power/charger-manager.c
>> +++ b/drivers/power/charger-manager.c
>> @@ -1677,7 +1677,7 @@ static int charger_manager_probe(struct platform_device *pdev)
>>  		}
>>  	}
>>  
>> -	if (!desc) {
>> +	if (IS_ERR(desc)) {
>>  		dev_err(&pdev->dev, "No platform data (desc) found\n");
>>  		return -ENODEV;
> 
> While you are at it you may also fix the code to return the proper error
> code.  of_cm_parse_desc() currently returns -ENOMEM not -ENODEV but it
> would be even better to decode the actual return code from desc by using
> 'return PTR_ERR(desc)' instead of 'return -ENODEV'.

I'll resend this patch after fix it.

Thanks,
Chanwoo Choi


