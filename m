Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3KDKB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:01:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:24891 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3KDKBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:01:55 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-44-527770924802
Message-id: <52777093.8040107@samsung.com>
Date: Mon, 04 Nov 2013 19:01:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] mfd: max77693: Fix up bug of wrong interrupt number
References: <1381367155-4888-1-git-send-email-cw00.choi@samsung.com>
 <5276FF3C.9050304@samsung.com> <20131104084244.GD6566@zurbaran>
In-reply-to: <20131104084244.GD6566@zurbaran>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWyRsSkQHdSQXmQQcc2SYuzTW/YLe5/Pcpo
	cXnXHDaL092sDiwed67tYfOYdzLQo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDIerTjIVjCT
	raLt6wumBsZG1i5GTg4JAROJK6e+MkHYYhIX7q1n62Lk4hASWMoo8fPXSRaYog17D0ElFjFK
	TH9/mB3CecUo0XjgBjNIFa+AlsSUOX/BxrIIqEr8uLAczGYDiu9/cYMNxBYVCJNYOf0KC0S9
	oMSPyfeAbA4OEQENib09NSBhZoFgiTmPPrOD2MICHhLXZ52A2tXGKLGvYzFYL6eArsTPGTuY
	IRp0JPa3TmODsOUlNq95ywzSICGwil1iWtMVNoiDBCS+TT4EtkxCQFZi0wFmiM8kJQ6uuMEy
	gVFsFpKTZiEZOwvJ2AWMzKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAqPp9L9nE3Yw3jtg
	fYgxGWjlRGYp0eR8YDTmlcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVANjYuzD4I9z/jMct87Vkq3W3SKzUXJykMe8gGUCwlVeLy2cJ4U1qJaJXG5j
	WPPygN0DqcQvh5lNfa+f2bPexzRqJZuFzd5LEWVtLWzbLK8vtBTON4zWCH1x86640Yn4i+wc
	/lxSK2NTjzSGcaT/dV523eFxyuSzdQqGj2xOO212Oxx+uu6m2SMlluKMREMt5qLiRABXG6Fy
	vAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xgO6kgvIgg3O9whZnm96wW9z/epTR
	4vKuOWwWp7tZHVg87lzbw+Yx72SgR9+WVYwenzfJBbBENTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBtVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jBmPFpxkK1gJltF29cXTA2MjaxdjJwcEgImEhv2HmKDsMUkLtxbD2Rz
	cQgJLGKUmP7+MDuE84pRovHADWaQKl4BLYkpc/6CdbMIqEr8uLAczGYDiu9/cQNskqhAmMTK
	6VdYIOoFJX5Mvgdkc3CICGhI7O2pAQkzCwRLzHn0mR3EFhbwkLg+6wTUrjZGiX0di8F6OQV0
	JX7O2MEM0aAjsb91GhuELS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYJj9ZnUDsaVDRaHGAU4GJV4eCUulwUJsSaWFVfmHmKU4GBWEuFlCCsPEuJN
	SaysSi3Kjy8qzUktPsSYDAyBicxSosn5wDSSVxJvaGxiZmRpZG5oYWRsTpqwkjjvgVbrQCGB
	9MSS1OzU1ILUIpgtTBycUg2MDLxVwi4G2i0PGNR+TZu9f97Omg+izp/a7p5L2fP9cbOHaHKd
	cEWDLUd09YGQvROr3ZuevBdZND18dmfd0S9ndU+XdzVe91W/sM405290/If9vb9yrPQUrS8u
	PtRobH2ANXbrC7aCRzpablU8N42n2R4s6Dj3pV7Jbv1DnoA/HkF53NrWmteUWIozEg21mIuK
	EwEtoeBUGQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 05:42 PM, Samuel Ortiz wrote:
> Hi Chanwoo,
> 
> On Mon, Nov 04, 2013 at 10:58:20AM +0900, Chanwoo Choi wrote:
>> Ping!
>>
>> Thanks,
>> Chanwoo Choi
>>
>> On 10/10/2013 10:05 AM, Chanwoo Choi wrote:
>>> The max77693 MFD device use irq domain method which has hardware interrupt number
>>> and virtual interrupt number getting through irq domain mapping. This patch
>>> use hardware interrupt number instead of virtual interrupt number to get
>>> struct irq_data.
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  drivers/mfd/max77693-irq.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
> Patch applied, thanks.
> 

Thanks,

Best Regards,
Chanwoo Choi

