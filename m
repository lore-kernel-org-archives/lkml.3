Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab3KDCgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 21:36:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44317 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3KDCgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 21:36:44 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-fd-52770835ae72
Message-id: <52770837.5000901@samsung.com>
Date: Mon, 04 Nov 2013 11:36:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Zhang, Dongxing" <dongxing.zhang@intel.com>
Subject: Re: [PATCH] [extcon]:remove freed groups caused the panic or warning
 in unregister flow
References: <1383346094.2702.16.camel@wxm-ubuntu>
 <5276FBB5.1020506@samsung.com>
 <FA47D36D6EC9FE4CB463299737C09B9901B6467C@SHSMSX102.ccr.corp.intel.com>
In-reply-to: <FA47D36D6EC9FE4CB463299737C09B9901B6467C@SHSMSX102.ccr.corp.intel.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkUNeMozzI4EoDq8X0L/uYLRZ/m8Js
	cXnXHDaL240r2Cwut79jc2D1WLznJZNH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZXSvOMlU
	8E204treT0wNjNcEuxg5OSQETCROn9/NCGGLSVy4t56ti5GLQ0hgKaPE2ZnzWWCKfj9bwAqR
	WMQoMffJI2YI5xWjxNqmY8wgVbwCWhLbtz1jA7FZBFQlps1ZAGazAcX3v7gBZosKhEmsnH6F
	BaJeUOLH5HtgtoiAnsSSN7fBVjML3GKU2NkylR0kISyQJDHt6zOwIiGBOYwS/2ZUgNicQIP6
	dm8FizMLqEtMmreIGcKWl9i85i0zxNmb2CWO7Q6COEhA4tvkQ0D1HEBxWYlNB6BKJCUOrrjB
	MoFRbBaSk2YhmToLydQFjMyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQIj6vS/Z307GG8e
	sD7EmAy0ciKzlGhyPjAi80riDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7NbUgtSi+
	qDQntfgQIxMHp1QDY/GZprMilTlT92jNu/Fv1uy2lWqPVzaaVT0/ZcObar353HtOd8P3hgnr
	4pc9CBEwldgnoxY36fHkHxsOvrj/ymCx1sdG8YqOd6nmG2yW5x4Wt9ip0N4j6n5jzSnd7a8v
	GjruPX6gr3XG2+RendkCpqfuWjf5hhhH7LvXPpulWJd5peKlxvOxb5RYijMSDbWYi4oTAWMp
	6UG+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgK4pR3mQwZ85VhbTv+xjtlj8bQqz
	xeVdc9gsbjeuYLO43P6OzYHVY/Gel0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYw5jRveIkU8E30Yprez8xNTBeE+xi5OSQEDCR+P1sASuELSZx4d56
	ti5GLg4hgUWMEnOfPGKGcF4xSqxtOsYMUsUroCWxfdszNhCbRUBVYtqcBWA2G1B8/4sbYLao
	QJjEyulXWCDqBSV+TL4HZosI6EkseXMbbAOzwC1GiZ0tU9lBEsICSRLTvj4DKxISmMMo8W9G
	BYjNCTSob/dWsDizgLrEpHmLmCFseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERyxz6R2MK5ssDjEKMDBqMTDK3G5LEiINbGsuDL3EKMEB7OSCK/z
	OaAQb0piZVVqUX58UWlOavEhxmRgEExklhJNzgcmk7ySeENjEzMjSyNzQwsjY3PShJXEeQ+0
	WgcKCaQnlqRmp6YWpBbBbGHi4JRqYJw2gS9bkSHNjMn32MnrF6bNnXzQNdbWK6VVXZq9ReDD
	rF2L/nY8lT70XD+rPWfuzJLyZxM/CstvOmn3UEby0ZHdnssZtxzuX1ys9Tz3rP2K9ep75nq4
	fVi650FTjcqjD4x73yyqfcoV4T390Z0zE0pS+4yW6u+YvkTvjZ+LsRv76qsbAvb8q/2jxFKc
	kWioxVxUnAgAcCTNWRwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 11:07 AM, Wang, Xiaoming wrote:
> Dear Choi
> 
> -----Original Message-----
> From: Chanwoo Choi [mailto:cw00.choi@samsung.com] 
> Sent: Monday, November 04, 2013 9:43 AM
> To: Wang, Xiaoming
> Cc: myungjoo.ham@samsung.com; linux-kernel@vger.kernel.org; Liu, Chuansheng; Zhang, Dongxing
> Subject: Re: [PATCH] [extcon]:remove freed groups caused the panic or warning in unregister flow
> 
> Hi Wang,
> 
>>  drivers/extcon/extcon-class.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-class.c 
>> b/drivers/extcon/extcon-class.c index 148382f..48f4669 100644
>> --- a/drivers/extcon/extcon-class.c
>> +++ b/drivers/extcon/extcon-class.c
>> @@ -794,6 +794,8 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>>  		return;
>>  	}
>>  
>> +	device_unregister(edev->dev);
>> +
>>  	if (edev->mutually_exclusive && edev->max_supported) {
>>  		for (index = 0; edev->mutually_exclusive[index];
>>  				index++)
>> @@ -814,7 +816,6 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>>  	if (switch_class)
>>  		class_compat_remove_link(switch_class, edev->dev, NULL);  #endif
>> -	device_unregister(edev->dev);
>>  	put_device(edev->dev);
>>  }
>>  EXPORT_SYMBOL_GPL(extcon_dev_unregister);
>>
> 
> I think we could only apply following patch instead of moving the position of device_unregister().
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c index 148382f..ff27b19 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -805,10 +805,8 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>         for (index = 0; index < edev->max_supported; index++)
>                 kfree(edev->cables[index].attr_g.name);
>  
> -       if (edev->max_supported) {
> -               kfree(edev->extcon_dev_type.groups);
> +       if (edev->max_supported)
>                 kfree(edev->cables);
> -       }
>  
>  #if defined(CONFIG_ANDROID)
>         if (switch_class)
> 
> Thanks,
> Chanwoo Choi
> 
> 	I don't agree with you.
> 	Why do not you want moving the position of device_unregister()?
> 	It will cause the memory leak if has not kfree edev->extcon_dev_type.groups as your patch do firstly. And if you think kfree edev->extcon_dev_type.groups is meaningless well then kfree edev->extcon_dev_type.groups in function exton_dev_register (line 756)also should be removed I think. What do you think?
> 

As you comment, my opinion has memory leak problem. My mistake.
But, I prefer to call 'device_unregister' at the end of extcon_dev_unregister().
To resolve kernel panic, I think we could use 'devm_kzalloc' instead of kzalloc/kfree.
What is your opinion about my approach?

Thanks,
Chanwoo Choi


