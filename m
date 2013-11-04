Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab3KDBnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 20:43:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33114 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3KDBnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 20:43:18 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-9d-5276fbb43f17
Message-id: <5276FBB5.1020506@samsung.com>
Date: Mon, 04 Nov 2013 10:43:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, dongxing.zhang@intel.com
Subject: Re: [PATCH] [extcon]:remove freed groups caused the panic or warning
 in unregister flow
References: <1383346094.2702.16.camel@wxm-ubuntu>
In-reply-to: <1383346094.2702.16.camel@wxm-ubuntu>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkWHfL77Igg8u7JCymf9nHbLH42xRm
	i8u75rBZ3G5cwWZxuf0dmwOrx+I9L5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+Pdpv+s
	BSd5Kg68EmpgbOTqYuTkkBAwkbj67iIbhC0mceHeeiCbi0NIYCmjxItDS5hhiq5cmckEYgsJ
	LGKUOP/CAKLoFaPEom3nwbp5BbQkLgGtB7FZBFQlvi9cywhiswHF97+4AVYjKhAmsXL6FRaI
	ekGJH5PvgdkiAnoSS97cBqrh4GAWKJC48z0YJCwskCQx7eszFoi9hhI/rq5jAinhFDCSOHLZ
	CCTMLKAuMWneImYIW15i85q3zCCnSQisY5e49vEUO8Q5AhLfJh9iAemVEJCV2HQA6i1JiYMr
	brBMYBSbheSgWUjGzkIydgEj8ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwEg6/e9Z7w7G
	2wesDzEmA62cyCwlmpwPjMS8knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamBUUj2bw8x34BN3rmVLIJPXv+rTtqmvr/Km/E/oKDyj1sbe+KWy78Hv
	dY/T9bYaOL/cl9AYrpKrp7r/CQ+HD9sj86jfppV+y5L2JVbKzpcJXLjd7JXB9St/X4TEanI+
	4/TQ/idgN8d55//96i/vVuYnLSxe+GmKieDV4532c35tv79IPUbj8RElluKMREMt5qLiRAAY
	rsiXugIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xgO6W32VBBh/vC1pM/7KP2WLxtynM
	Fpd3zWGzuN24gs3icvs7NgdWj8V7XjJ59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWPGu03/WQtO8lQceCXUwNjI1cXIySEhYCJx5cpMJghbTOLCvfVs
	ILaQwCJGifMvDLoYuYDsV4wSi7adB0vwCmhJXAL6DsRmEVCV+L5wLSOIzQYU3//iBliNqECY
	xMrpV1gg6gUlfky+B2aLCOhJLHlzG6iGg4NZoEDizvdgkLCwQJLEtK/PWCD2Gkr8uLqOCaSE
	U8BI4shlI5Aws4C6xKR5i5ghbHmJzWveMk9gFJiFZMEsJGWzkJQtYGRexSiaWpBcUJyUnmuo
	V5yYW1yal66XnJ+7iREcp8+kdjCubLA4xCjAwajEwytxuSxIiDWxrLgy9xCjBAezkgiv8zmg
	EG9KYmVValF+fFFpTmrxIcZkoP8nMkuJJucDU0heSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0D
	hQTSE0tSs1NTC1KLYLYwcXBKNTC69S7kWvjJR+n24d5Tq02WVTstP/r0WOcyyf03Od9+W8Kv
	c53R/Gn4jpM3H02+PstJ/1LTld+2igqfFDgy3nlX3b3JcE6zk32yr/2NWwFthl+KlWYdWXL2
	6AlhWdZkwyddfqEicr3Gh4LPXSqeNJv7jZPOx9Y5f247O6ysZjXSO5jhsTVeyfy1EktxRqKh
	FnNRcSIA3cE0sxcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

>  drivers/extcon/extcon-class.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 148382f..48f4669 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -794,6 +794,8 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  		return;
>  	}
>  
> +	device_unregister(edev->dev);
> +
>  	if (edev->mutually_exclusive && edev->max_supported) {
>  		for (index = 0; edev->mutually_exclusive[index];
>  				index++)
> @@ -814,7 +816,6 @@ void extcon_dev_unregister(struct extcon_dev *edev)
>  	if (switch_class)
>  		class_compat_remove_link(switch_class, edev->dev, NULL);
>  #endif
> -	device_unregister(edev->dev);
>  	put_device(edev->dev);
>  }
>  EXPORT_SYMBOL_GPL(extcon_dev_unregister);
> 

I think we could only apply following patch instead of moving the position of device_unregister().

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 148382f..ff27b19 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -805,10 +805,8 @@ void extcon_dev_unregister(struct extcon_dev *edev)
        for (index = 0; index < edev->max_supported; index++)
                kfree(edev->cables[index].attr_g.name);
 
-       if (edev->max_supported) {
-               kfree(edev->extcon_dev_type.groups);
+       if (edev->max_supported)
                kfree(edev->cables);
-       }
 
 #if defined(CONFIG_ANDROID)
        if (switch_class)

Thanks,
Chanwoo Choi

