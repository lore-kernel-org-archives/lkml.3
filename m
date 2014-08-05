Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaHELsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:48:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47168 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbaHELsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:48:13 -0400
X-AuditID: cbfee691-b7f306d000003d81-59-53e0c47a2798
Message-id: <4F887641414547418FB42327CF5E09DF@sisodomain.com>
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>, linux-usb@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, sachin.kamat@samsung.com,
        "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1407235148-31790-1-git-send-email-gautam.vivek@samsung.com>
 <000d01cfb09c$239a8670$6acf9350$%han@samsung.com>
In-reply-to: <000d01cfb09c$239a8670$6acf9350$%han@samsung.com>
Subject: Re: [PATCH RESEND] usb: ehci/ohci-exynos: Fix PHY getting sequence
Date: Tue, 05 Aug 2014 17:14:26 +0530
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=iso-8859-1; reply-type=original
Content-transfer-encoding: 7bit
X-Priority: 3
X-MSMail-priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MIMEOLE: Produced By Microsoft MimeOLE V14.0.8117.416
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWyRsSkWrfqyINgg1MX9S2aF69ns7i88BKr
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLBYta2W2uHLpFJvFhN8X2Bw4PfbPXcPusXlJvcfsuz8Y
	Pfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugStj+v5NzAVdnBXnZq5nbmBcyt7FyMkhIWAiMWni
	A2YIW0ziwr31bF2MXBxCAksZJfZdOcoKUzR7SwcjRGIRo0Tf7UYmCOc7UNWH10wgVbwCthLf
	X1wDs9kEdCWa3u4C6uDgEBGwlzj2xBeknlmgi0mi+fIJsHVCAjUSZw8/Zwep4RSwk3i1QQ8k
	LCzgLdH68zRYCYuAqsSsD11sEOMFJX5MvscCYjMLBEisnDibEcKWl9i85i3UB7wSM9qfskDY
	khKre26BfckpICTRcbUT6hljiSn/lkLVm0tc3L4Z7BcJgV4OiTnT7zJCLBaQ+Db5EAvIbRIC
	shKbDjDDzDy44gbLBEapWUhOmoXkpFlITlrAyLyKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cT
	IzDST/97NnEH4/0D1ocYk4FWTmSWEk3OByaKvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgXD5FbvOaKamO9xVu3gnLZChZu9Rqb9e9Z1sqlZXe
	NXKxWMu3navQvH//4K61RUV1i9XU5j/VDso/sf/S5ofxL9cuO8x7JO/bRy+PWXumaPgu+C19
	U3qCw6VHnHksfmLxbK/ey/70WfrzefOaVMut157kfTtYeWWDxMtZQifeLTrEf+n8O88FE5iV
	WIozEg21mIuKEwHhaB28CgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd2qIw+CDdZPVLdoXryezeLywkus
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsli0rJXZ4sqlU2wWE35fYHPg9Ng/dw27x+Yl9R6z7/5g
	9OjbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGdP3b2Iu
	6OKsODdzPXMD41L2LkZODgkBE4nZWzoYIWwxiQv31rN1MXJxCAksYpTou93IBOF8Z5TY9+E1
	E0gVr4CtxPcX18BsNgFdiaa3u4C6OThEBOwljj3xBalnFuhikmi+fIIZpEZIoEbi7OHn7CA1
	nAJ2Eq826IGEhQW8JVp/ngYrYRFQlZj1oYsNYrygxI/J91hAbGaBAImVE2czQtjyEpvXvGWG
	OJRXYkb7UxYIW1Jidc8tsGc4BYQkOq52skLEjSWm/FsKVW8ucXH7ZqYJjCKzkKyYhWTFLCQr
	FjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQITiPPpHcwrmqwOMQowMGoxMMroHY/WIg1
	say4MvcQowQHs5II79NdD4KFeFMSK6tSi/Lji0pzUosPMZoCfTqRWUo0OR+Y4vJK4g2NTcxN
	jU0tTSxMzCyVxHkPtloHCgmkJ5akZqemFqQWwfQxcXBKNTDOEHYTrr4mupPVIZlP8eHDOXfd
	5ebw3r9UsFJaziAxnulfu5xk+Cvd0lN3+lb9sWnXC7UvNSrQs8tabLeWZ25tyKRZ0qv77JSn
	60/Nufate0eu4qUfD+38om/Mmdp9/1mSSXzYj+8XqyfIvpgytdiy93G4geq686eTtpquaUmt
	2PGw9I+mrqgSS3FGoqEWc1FxIgCCSSEFOQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,


On Tuesday, August 05, 2014 4:28 PM, Jingoo Han wrote:
> On Tuesday, August 05, 2014 7:39 PM, Vivek Gautam wrote:
>>
>> Since we want to keep support for both older usb-phys as well as the
>> newer generic phys, lets first get the generic PHYs and fallback to
>> older USB-PHYs only when we fail to get the former.
>> This should fix the issue with ehci-exynos and ohci-exynos, wherein
>> in the absence of SAMSUNG_USB2PHY config symbol, we end up getting
>> the NOP_USB_XCEIV phy when the same is enabled. And thus the PHYs
>> are not configured properly.
>>
>> Reported-by: Sachin Kamat <sachin.kamat@samsung.com>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
>
> Right, we would get the generic PHYs first, then get the older
> usb-phys. Then, the older one will be removed from the kernel.

Right, I have a set of patches to remove the older phy support for Exynos 
SoC series,
keeping the support for S3C64XX, which I shall send soon.

[snip]

Thanks
Vivek Gautam 

