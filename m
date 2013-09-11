Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3IKCgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:36:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40367 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3IKCgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:36:22 -0400
X-AuditID: cbfee68e-b7f756d000004512-94-522fd720f782
Message-id: <522FD720.8030806@samsung.com>
Date: Wed, 11 Sep 2013 11:36:16 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] extcon: use dev_get_platdata()
References: <003e01ceae95$9a708ab0$cf51a010$%han@samsung.com>
In-reply-to: <003e01ceae95$9a708ab0$cf51a010$%han@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkQFfhun6QweutnBaXF15itbi8aw6b
	xe3GFWwOzB59W1YxenzeJBfAFMVlk5Kak1mWWqRvl8CV8f/+Q9aCs2wVx46cYmpgnMfaxcjJ
	ISFgIrF95mk2CFtM4sK99UA2F4eQwFJGiW9Nc9lgil61dEMlpjNK3DyxjgkkISTwilHiw6Vw
	EJtXQEvi3K+7YHEWAVWJ+TOmgW1gA4rvf3EDbJCoQJjEyulXWCDqBSV+TL4HZosIqEh8Xn8c
	rIZZwFtix8QJYL3CAuYSL2+8YoHYZSvRsu8DcxcjBwengJ1E820TiHIdif2t06Ba5SU2r3nL
	DHKnhMBkdonOqbcZIe4RkPg2+RALSK+EgKzEpgPMEH9JShxccYNlAqPYLCQXzUIydhaSsQsY
	mVcxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBMbL6X/P+nYw3jxgfYgxGWjlRGYp0eR8YLzl
	lcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR74KF
	xNUrxwvbVVdeSdwdL8C5dJXEyQ8cf/9frZ5S8i6S9f61PX8CWVbzMK6x4a3l7d3b4H49yFGu
	aI9am19iZ1iWmPrN31dadh27JZElxp0ePm3JoTA+3svJhSvXLFL4mbVarDW4oFL761V3kcaG
	LPYHTR/kTok7nbzDoPzY49TMl0Y7Y3qVWIozEg21mIuKEwFlINRRrQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jQV2F6/pBBpNeM1tcXniJ1eLyrjls
	FrcbV7A5MHv0bVnF6PF5k1wAU1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEN
	Y8b/+w9ZC86yVRw7coqpgXEeaxcjJ4eEgInEq5ZuNghbTOLCvfVANheHkMB0RombJ9YxgSSE
	BF4xSny4FA5i8wpoSZz7dRcsziKgKjF/xjSwQWxA8f0vboANEhUIk1g5/QoLRL2gxI/J98Bs
	EQEVic/rj4PVMAt4S+yYOAGsV1jAXOLljVcsELtsJVr2fWDuYuTg4BSwk2i+bQJRriOxv3Ua
	VKu8xOY1b5knMArMQrJhFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjsZn
	UjsYVzZYHGIU4GBU4uG9IacfJMSaWFZcmXuIUYKDWUmEd6oTUIg3JbGyKrUoP76oNCe1+BBj
	MjAAJjJLiSbnAxNFXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFw
	SjUw8syNsGGJUXid2SFbp3Lld5F5z2z+uTKx/z3z13GzhE/23mQgwe1etXqWxiJrI/mtbgcU
	b3Cs+5S+r6t+5r1ZVVPMvTPVNSQtJjJHZt8rTn9z8bst91Xeg1ph07Jj9FetWMSxfF/Xyw2H
	9AsjK1wktraXfPR50CofFLgmtCTt+xePOweO3u9RYinOSDTUYi4qTgQA0OE5XAoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

I prefer to consolidate this patchset as one patch because of simliar moditication.

Thanks,
Chanwoo Choi

On 09/11/2013 11:21 AM, Jingoo Han wrote:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly. This is a cosmetic change
> to make the code simpler and enhance the readability.
> 
> ---
>  drivers/extcon/extcon-adc-jack.c |    2 +-
>  drivers/extcon/extcon-gpio.c     |    2 +-
>  drivers/extcon/extcon-palmas.c   |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

