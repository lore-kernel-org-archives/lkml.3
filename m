Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3ILHPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:15:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45378 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3ILHPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:15:06 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-24-523169f8c33e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002801ce8376$a807dbf0$f81793d0$@samsung.com>
 <51ED49D6.9050209@ti.com> <000701ce8741$fe47deb0$fad79c10$@samsung.com>
 <51EE22DF.6090902@ti.com> <001301ce8772$522dfc50$f689f4f0$@samsung.com>
 <5231607C.10702@ti.com>
In-reply-to: <5231607C.10702@ti.com>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
Date: Thu, 12 Sep 2013 16:15:04 +0900
Message-id: <003501ceaf87$cda45db0$68ed1910$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgjA5UH78b855SFOzq0Q4r44D2AABOVKg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t8zQ90fmYZBBleOCVr8nXSM3WJJU4bF
	y0OaFvOPnGO1uLzwEqtF74KrbBYXnvawWVzeNYfN4uy842wWM87vY7LYOPUXo0X7JWWLn7vm
	sVg0Hn3AatH65AGjA7/H71+TGD12zrrL7rFgU6nH94Xz2T36tqxi9Hj6Yy+zx/Eb25k8Pm+S
	C+CI4rJJSc3JLEst0rdL4MqYf+wfc8FsjoqTDcoNjKfYuhg5OCQETCRunXHqYuQEMsUkLtxb
	DxTm4hASWMYose7xV2aIhInE6iUfWSESixglzs0+zg7h/GKUOLaggxGkik1ATeLLl8PsILaI
	gI7EwtPrmUGKmAXeMEtcXn2MCaLjOaPE4yO/wDo4BVQkVj7rAbOFBRIl5r7+wAxyE4uAqsS2
	46UgYV4BW4nlvY2sELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGWGeEdd4tFfXYgbjCTmdmxm
	hCgRkdj34h0jyAkSAjs4JFYfnwGWYBEQkPg2+RALRK+sxKYDUB9LShxccYNlAqPELCSbZyHZ
	PAvJ5llIVixgZFnFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJEZIiJuxgvHfA+hBjMtD6icxS
	osn5wBSTVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQbGjH9mgt4Ndy/fiY5T29Zzor1P/+P2VXk/O3sesN88MvmOXUrBl5fbNZc/We56f+LKu/N3
	ct8ud89uTnP/UZ/jl+d92sz404rm/4c+Ke72aslTOXN90zrGtDfL5zQ9ZV/H1lOe5dukYu3G
	bs26J0l753KLeR0Caww/9IYG8FXO06kI4D6jyTFFiaU4I9FQi7moOBEAzRq6KicDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsVy+t9jAd0fmYZBBvO7eCz+TjrGbrGkKcPi
	5SFNi/lHzrFaXF54idWid8FVNosLT3vYLC7vmsNmcXbecTaLGef3MVlsnPqL0aL9krLFz13z
	WCwajz5gtWh98oDRgd/j969JjB47Z91l91iwqdTj+8L57B59W1Yxejz9sZfZ4/iN7UwenzfJ
	BXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCd
	rqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmH/sH3PBbI6Kkw3KDYyn
	2LoYOTkkBEwkVi/5yAphi0lcuLceKM7FISSwiFHi3Ozj7BDOL0aJYws6GEGq2ATUJL58OcwO
	YosI6EgsPL2eGaSIWeANs8Tl1ceYIDqeM0o8PvILrINTQEVi5bMeMFtYIFFi7usPQB0cHCwC
	qhLbjpeChHkFbCWW9zayQtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe8xasVUJAXeLRX12IG4wk
	5nZsZoQoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66X
	nJ+7iRGcgp5J72Bc1WBxiFGAg1GJh7djlkGQEGtiWXFl7iFGCQ5mJRHeeHPDICHelMTKqtSi
	/Pii0pzU4kOMyUB/TmSWEk3OB6bHvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGan
	phakFsFsYeLglGpg3Gzr8F76q7j7c4VPE7lfLphzKdJMQm9nQerri6G+W94Lu8RW3PYu8j0R
	3zXta/01paszLm+Qi0xXs5qYUGKz/PsuIbX5u7LtLn1Ie+G9//isewvj+A//WHp5R7p2u6ve
	/is6QSrz/p/SMZHmzln0Q7CjIp13s1zRzi0Gn/clnoxp+bdhupX0BSWW4oxEQy3mouJEAOL8
	zfyFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 July 2013 12:30 PM, Kishon Vijay Abraham I wrote:
> >> .
> >> .
> >>>>> +			of_pci_range_to_resource(&range, np, &pp->cfg);
> >>>>> +			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
> >>>>> +			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> >>>>> +		}
> >>>>> +	}
> >>>>> +
> >>>>> +	pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
> >>>>> +				resource_size(&pp->cfg));
> >>>>
> >>>> Why is configuraion space divided into two?
> >>>
> >>> Sorry, I don't know the exact reason. :(
> >>> Pratyush Anand may know about this.
> >>> Pratyush Anand, could you answer the question?
> >>>
> >>> Also, if you find some problems, please let me know.
> 
> One more query..
> 
> Where is inbound translation configuration done in your driver? how should it
> be done?

Hi Kishon,

Sorry, I cannot understand your question exactly.
However, the following thread would be helpful.

http://www.spinics.net/lists/arm-kernel/msg252078.html
https://lkml.org/lkml/2013/6/17/890

Best regards.
Jingoo Han

