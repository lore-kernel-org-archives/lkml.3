Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaLRAaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:30:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:17493 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaLRAaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:30:07 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f1-5492200c8980
Message-id: <5492200B.3000502@samsung.com>
Date: Thu, 18 Dec 2014 09:30:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: adc-jack: Release IIO channel on driver remove
References: <1418831967-26066-1-git-send-email-iivanov@mm-sol.com>
In-reply-to: <1418831967-26066-1-git-send-email-iivanov@mm-sol.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSpMujMCnE4O5hdotnEx8yWjxoWsVk
	cXnXHDaL240r2BxYPDat6mTz2LR/GrNH35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZZx8spe5
	4CxrxaENSg2M51i6GDk4JARMJJ7vCu9i5AQyxSQu3FvP1sXIxSEksJRRYvLsXnaYmqetMRDx
	RYwST199ZwdpEBJ4zSjxd7EHiM0roCVx/NonNhCbRUBV4uWqbYwgNhtQfP+LG2BxUYEwiZXT
	r7BA1AtK/Jh8D+wGEQFNiU1ngkFMZoECiSOb6kEqhAW8JSbOvc0MsclJ4lrbRCYQm1PAWeLd
	qkawicwCOhL7W6dB2fISm9e8ZQY5U0JgHbtE9/m1TBDnCEh8m3wI6l1ZiU0HmCHelZQ4uOIG
	ywRGsVlIDpqFZOwsJGMXMDKvYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiMotP/nk3YwXjv
	gPUhRgEORiUe3hfXJ4QIsSaWFVfmHmI0BbpiIrOUaHI+MFbzSuINjc2MLExNTI2NzC3NlMR5
	X0v9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqKuic0SK6WJ979Sv/3YkrlHyLb977w/X
	aw2ufRcupZy0vXxVROdpYnv07MeX+WJmi71zfGLxzilu1cmpp88b7+W+27b7dtDyhwctcvQS
	ZO6dYtJ4WaP337tDJN8lU9pslcENvlktTOZe9fw1wtP8D6qVL/aXf/zY+bvRvTpdneebTZ9w
	C0+qUGIpzkg01GIuKk4EAEEQuxSdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAV0ehUkhBj8KLZ5NfMho8aBpFZPF
	5V1z2CxuN65gc2Dx2LSqk81j0/5pzB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjDmHHyyV7mgrOsFYc2KDUwnmPpYuTgkBAwkXjaGtPFyAlkiklcuLee
	rYuRi0NIYBGjxNNX39lBEkICrxkl/i72ALF5BbQkjl/7xAZiswioSrxctY0RxGYDiu9/cQMs
	LioQJrFy+hUWiHpBiR+T74HtEhHQlNh0JhjEZBYokDiyqR6kQljAW2Li3NvMEJucJK61TWQC
	sTkFnCXerWoEm8gsoCOxv3UalC0vsXnNW+YJjAKzkCyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN
	9YoTc4tL89L1kvNzNzGCY/SZ1A7GlQ0WhxgFOBiVeHhfXp8QIsSaWFZcmXuIUYKDWUmEdzfX
	pBAh3pTEyqrUovz4otKc1OJDjKZA/09klhJNzgemj7ySeENjEzMjSyNzQwsjY3MlcV4l+7YQ
	IYH0xJLU7NTUgtQimD4mDk6pBkbZ+VFnNtj9fz7n7W3dle+9H0wtmvZCwVza7If5fTd2r+rs
	9Vv8b578tXjh52XCEv7/WStZ713Iiy79vbBLV4NRb6Vg9SaTj2/F7/h32GhyXDv1ykLmD7PH
	GZc/fk8OKL9K2/x4/lpzm8lld961lD7Iv58vyOjBvsfsxs0pZRcDbHelJKQwJForsRRnJBpq
	MRcVJwIAmbQwHOcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2014 12:59 AM, Ivan T. Ivanov wrote:
> Release IIO channel acquired during driver probe.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/extcon/extcon-adc-jack.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
> index d860229..ce8c6ff 100644
> --- a/drivers/extcon/extcon-adc-jack.c
> +++ b/drivers/extcon/extcon-adc-jack.c
> @@ -173,6 +173,7 @@ static int adc_jack_remove(struct platform_device *pdev)
>  
>  	free_irq(data->irq, data);
>  	cancel_work_sync(&data->handler.work);
> +	iio_channel_release(data->chan);
>  
>  	return 0;
>  }
> 

Applied it.

Thanks,
Chanwoo Choi
