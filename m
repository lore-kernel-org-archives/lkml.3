Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaE0A5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:57:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64447 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaE0A5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:57:51 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-15-5383e30dbb8a
Message-id: <5383E32A.6040009@samsung.com>
Date: Tue, 27 May 2014 09:58:18 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Sunghwan Yun <sunghwan.yun@samsung.com>,
        Daeseok Youn <daeseok.youn@gmail.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: Re: [PATCH 1/9] staging: ion: tidy up a bit
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <20140526103612.GE15585@mwanda>
In-reply-to: <20140526103612.GE15585@mwanda>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zLV3ex83BBpObuSze/73PZrF94zdW
	i5eHNC0OfrjPYvH633QWiz1nfrFbNC9ez2ZxcPYSJoszv3UtLu+aw2axdv42NosbkwstTncs
	YnXg9di2exurx+W+XiaPe/sOs3jsnHWX3ePOtT1sHvvnrmH3+Pj0FotH35ZVjB6fN8kFcEZx
	2aSk5mSWpRbp2yVwZex8tI65YBZrxaG5C1gbGP8ydzFycEgImEi07BLsYuQEMsUkLtxbz9bF
	yMUhJLCMUeLw1L2sEAkTiVfds1kgEosYJR7PaQdLCAm8YZQ4vVMDxOYV0JI4PeUJO4jNIqAq
	cfTJSTaQBWwC2hKHtgWDhEUFIiTuNR5mhSgXlPgx+R4LiC0ioCNxufMHO8h8ZoHFzBJvDrUz
	gySEgRavvHYAalemxIa5l1hAZnICNTR+CgEJMwtYS6yctI0RwpaX2LzmLTPIHAmBqRwSN/ue
	MEPcIyDxbfIhFoiHZSU2HWCG+EtS4uCKGywTGMVmITlpFpKxs5CMXcDIvIpRNLUguaA4Kb3I
	UK84Mbe4NC9dLzk/dxMjJKJ7dzDePmB9iDEZaOVEZinR5HxgQsgriTc0NjOyMDUxNTYytzQj
	TVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkazD+5mGl+dzaJEyr5smWW90e56
	VUL/+aWmd5pf/Hvof21+9QvVVHEvufm7ZdfmmeyXmPJV9FTp24s77uwx1skKm/C5ZvY5r38v
	Z0+7ozvTjPv92Razo6Wzzp3/Wf/8xRuTrxc4ugUPHEzb3xf++kWrglmby00T22VXJReU877W
	6SoL1RD9xXBRiaU4I9FQi7moOBEA1+L1TP4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAV3ex83BBpP6WS3e/73PZrF94zdW
	i5eHNC0OfrjPYvH633QWiz1nfrFbNC9ez2ZxcPYSJoszv3UtLu+aw2axdv42NosbkwstTncs
	YnXg9di2exurx+W+XiaPe/sOs3jsnHWX3ePOtT1sHvvnrmH3+Pj0FotH35ZVjB6fN8kFcEY1
	MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2tpFCW
	mFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8zY+Wgdc8Es1opDcxewNjD+Ze5i
	5OSQEDCReNU9mwXCFpO4cG89WxcjF4eQwCJGicdz2llBEkICbxglTu/UALF5BbQkTk95wg5i
	swioShx9chKogYODTUBb4tC2YJCwqECExL3Gw6wQ5YISPybfA5svIqAjcbnzBzvIfGaBxcwS
	bw61gx0hDHTEymsHoHZlSmyYe4kFZCYnUEPjpxCQMLOAtcTKSdsYIWx5ic1r3jJPYBSYhWTF
	LCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnDCeSe1gXNlgcYhRgINRiYd3
	gm9zsBBrYllxZe4hRgkOZiUR3g0ngUK8KYmVValF+fFFpTmpxYcYk4EBMJFZSjQ5H5jM8kri
	DY1NzIwsjcyMTcyNjUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBkbdn1bGjkxIPRnZV
	xl/hz57mXR7yWX+6Z7yD4MkDclcOCR/izZPgjFQS/XyfUa2g7fr+RbEZ35pVfusz8ITtzjJj
	8J136er1qxw6IbdbfLYF+axy37Agf+JTm8NM/H9V54WJb1U9x5Z5/7r4zIUHQnPa180W+N0S
	ciY6aWp4xswJLbdv3ik6o8RSnJFoqMVcVJwIAPULnx5cAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Carpenter,

On 05/26/2014 07:36 PM, Dan Carpenter wrote:
> On Mon, May 26, 2014 at 07:04:53PM +0900, Heesub Shin wrote:
>> @@ -124,7 +122,6 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
>>
>>   		info->page = page;
>>   		info->order = orders[i];
>> -		INIT_LIST_HEAD(&info->list);
>>   		return info;
>>   	}
>>   	kfree(info);
>
> Wait.  How does this code work without that INIT_LIST_HEAD()?  What am
> I missing here...

No problem. As the object info is just a node, not a head, it is 
completely useless to initialize it as a list head.

regards,
Heesub

>
> regards,
> dan carpenter
>
>
>
