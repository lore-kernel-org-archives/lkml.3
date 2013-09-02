Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3IBAlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:41:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10357 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab3IBAlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:41:52 -0400
X-AuditID: cbfee68e-b7f756d000004512-b6-5223debbedbd
Message-id: <5223DEBB.5010300@samsung.com>
Date: Mon, 02 Sep 2013 09:41:31 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH 2/3] extcon: Change field type of 'dev' in extcon_dev
 structure
References: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
 <1378081208-20274-3-git-send-email-cw00.choi@samsung.com>
 <20130902003807.GA10709@kroah.com>
In-reply-to: <20130902003807.GA10709@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkUHf3PeUgg6/7NCyaF69nszjb9Ibd
	4vKuOWwWtxtXsDmweOyfu4bdo2/LKkaPz5vkApijuGxSUnMyy1KL9O0SuDKuv2pnL9jIWvGr
	8xR7A+NKli5GTg4JAROJl7ufskPYYhIX7q1n62Lk4hASWMoo8W/DDGaYohmPj7FAJKYzSkx7
	sp0JwnnFKHH8wjqwKl4BLYmeS7vAbBYBVYmVHw+wgdhsQPH9L26A2aICYRIrp19hgagXlPgx
	+R6YLSKgIfHy6C0wm1kgXOLi3i4wW1ggVGLO2utQm5cxSvQe+csKkuAU0JfYvXECVIOOxP7W
	aWwQtrzE5jVvmUEaJASWsUtseb2NHeIiAYlvkw8BNXAAJWQlNh2Aek1S4uCKGywTGMVmIblp
	FpKxs5CMXcDIvIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMJJO/3vWt4Px5gHrQ4zJQCsn
	MkuJJucDIzGvJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYwzN9yTu97l9cSnSdGsxaPw3ZTk793+Wx/c+vPj56QFMyKktfv3/1n9N+GKp+C109e0
	S6Ps2eXiX0801wzwe72whqvbjMdtr7PuOvN7hU29G8O2b9xv3y+SI+H3is14kRZb3cvkUt3U
	NobrzLc+PA06NUtkt/DifUoX+1p0w9ik8u13d561eqzEUpyRaKjFXFScCACzWetCugIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xoO7ue8pBBi9PKlo0L17PZnG26Q27
	xeVdc9gsbjeuYHNg8dg/dw27R9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmXH/Vzl6wkbXiV+cp9gbGlSxdjJwcEgImEjMeH4OyxSQu3FvP1sXIxSEk
	MJ1RYtqT7UwQzitGieMX1jGDVPEKaEn0XNoFZrMIqEqs/HiADcRmA4rvf3EDzBYVCJNYOf0K
	C0S9oMSPyffAbBEBDYmXR2+B2cwC4RIX93aB2cICoRJz1l5ngVi2jFGi98hfVpAEp4C+xO6N
	E6AadCT2t05jg7DlJTavecs8gVFgFpIds5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGcJw+k97BuKrB4hCjAAejEg+vwjLlICHWxLLiytxDjBIczEoivHE3gUK8KYmVValF
	+fFFpTmpxYcYk4FBMJFZSjQ5H5hC8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5Ykpqd
	mlqQWgSzhYmDU6qBUbFZ7qLC7N8y9z+f3SXrtFA25qm7efuNrZecHvx1m1Wmu2rix+hFD3da
	Xd7BJFAR+YVvmePlWq0tDhv/m3FccOqw3fP3WdTGm+cbv12eNu3FsdRf5v7aBjvlupVF7pYp
	Twy942++Z2qb2toTz7977U3QZUg9LrFd7OACuelCs74dmR+ww45D5IESS3FGoqEWc1FxIgDJ
	LOB+FwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 09/02/2013 09:38 AM, Greg KH wrote:
> On Mon, Sep 02, 2013 at 09:20:07AM +0900, Chanwoo Choi wrote:
>> -	edev->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
>> -	if (!edev->dev)
>> -		return -ENOMEM;
>> -	edev->dev->parent = dev;
>> -	edev->dev->class = extcon_class;
>> -	edev->dev->release = extcon_dev_release;
>> +	edev->dev.parent = dev;
>> +	edev->dev.class = extcon_class;
>> +	edev->dev.release = extcon_dev_release;
> 
> You didn't change extcon_dev_release() to properly free all of the
> memory you allocated here, otherwise the slab allocator will oops when
> you try to call it...
> 

I'll fix it. Thanks.

Best Regards,
Chanwoo Choi

