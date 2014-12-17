Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaLQAc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 19:32:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:56164 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaLQAc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 19:32:57 -0500
X-AuditID: cbfee68e-f79b46d000002b74-28-5490cf383c85
Message-id: <5490CF37.9080204@samsung.com>
Date: Wed, 17 Dec 2014 09:32:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: weiyj_lk@163.com
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] extcon: Remove duplicated include from extcon-class.c
References: <1418087319-14416-1-git-send-email-weiyj_lk@163.com>
In-reply-to: <1418087319-14416-1-git-send-email-weiyj_lk@163.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSomtxfkKIwaMbghaXd81hs7jduILN
	ou3fDyaLnes62R1YPBavmMLq0bdlFaPH0ntHGT0+b5ILYInisklJzcksSy3St0vgylg64Qhj
	wWq2irNLZjI3MM5m7WLk5JAQMJF48Xo5C4QtJnHh3nq2LkYuDiGBpYwS01avZ4QpapqxjhEi
	sYhRYv7nXiYI5zWjxO077ewgVbwCWhKzn+1nA7FZBFQlTi+aCLaCDSi+/8UNsLioQJjEyulX
	WCDqBSV+TL4HZHNwiAiISHQ/iQQJMwtUSKxrmAY2UlggQOLEi2Vg5UICDhL75m5g7mJk5+AU
	cJRYqAdRrSOxv3UaG4QtL7F5zVtmkMskBNaxS/w8B3ImyDUCEt8mHwLbJCEgK7HpADPEW5IS
	B1fcYJnAKDYLyT2zkIydhWTsAkbmVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiBsXT637O+
	HYw3D1gfYhTgYFTi4Q0s7A8RYk0sK67MPcRoCnTFRGYp0eR8YMTmlcQbGpsZWZiamBobmVua
	KYnzJkj9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAGOWb39xv9vqB6j3Rf8IfNjzXqT65
	IfjtSj2LH4eXFWjOnN0wcY9Dv2pSyr7LcxIZP248l7PTf3ciO7s+Z9tFo/srrX7r9X/YZRnz
	fXPswfVXZofu8ZvCyvVY9qLPmh08sWue5k06kLDf8YN2teP0Z1u2Jf/kWF70RXWla/hKP743
	/fnJvs+FviuxFGckGmoxFxUnAgBwY2QGoAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jAV2L8xNCDGbc5La4vGsOm8XtxhVs
	Fm3/fjBZ7FzXye7A4rF4xRRWj74tqxg9lt47yujxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWPG0glHGAtWs1WcXTKTuYFxNmsXIyeHhICJRNOMdYwQtpjEhXvr
	2boYuTiEBBYxSsz/3MsE4bxmlLh9p50dpIpXQEti9rP9bCA2i4CqxOlFE8EmsQHF97+4ARYX
	FQiTWDn9CgtEvaDEj8n3gGwODhEBEYnuJ5EgYWaBCol1DdPARgoLBEiceLEMrFxIwEFi39wN
	zF2M7BycAo4SC/UgqnUk9rdOY4Ow5SU2r3nLPIFRYBaS+bOQlM1CUraAkXkVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnCkPpPewbiqweIQowAHoxIPb2Bhf4gQa2JZcWXuIUYJDmYlEV6L
	RRNChHhTEiurUovy44tKc1KLDzGaAr0/kVlKNDkfmETySuINjU3MjCyNzA0tjIzNlcR5lezb
	QoQE0hNLUrNTUwtSi2D6mDg4pRoYZd89/+0+Q+ngV6GgaI71ii087g8CX9Yc4J257m7iFuur
	7M0rGffsXBz81Tjj6L0tha+uVFaUnnFU/HDNN0qvWo6vVDJjg0xz6OM9z2x2X5w93Yz34C+Z
	so9GTzYEZdusnfwrmrfgxsrNZ1pkZY4HlC4OYtio9eBSSsHFbv3Ou5opnPKP1Vk2KbEUZyQa
	ajEXFScCAKltEdnqAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 10:08 AM, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/extcon/extcon-class.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 043dcd9..8319f25 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -32,7 +32,6 @@
>  #include <linux/of.h>
>  #include <linux/slab.h>
>  #include <linux/sysfs.h>
> -#include <linux/of.h>
>  
>  /*
>   * extcon_cable_name suggests the standard cable names for commonly used
> 
> 

The same patch[1] is already posted.
[1] https://lkml.org/lkml/2014/12/8/716

Thanks,
Chanwoo Choi

