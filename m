Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbbAZBrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 20:47:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9195 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbbAZBrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 20:47:33 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-04-54c59cad4a94
Message-id: <54C59CAC.8020509@samsung.com>
Date: Mon, 26 Jan 2015 10:47:24 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: Add sd0_rst pinctrl node to exynos5420
References: <1422023038-11842-1-git-send-email-jh80.chung@samsung.com>
 <CABxcv=mJhHTBKes38+6kHi5o3RmBHHN6sVqBUDRc-YyNvkdESQ@mail.gmail.com>
 <1422028075.15395.92.camel@collabora.co.uk>
 <CABxcv=kARp8xLYCqf8dfdKd9ehs1u=qTEjkn1iujhN77ZjPdTA@mail.gmail.com>
In-reply-to: <CABxcv=kARp8xLYCqf8dfdKd9ehs1u=qTEjkn1iujhN77ZjPdTA@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWyRsSkRHftnKMhBku28FjMP3KO1eLa7xls
	Fv2PXzNbXN41h81ixvl9TBbTj79ldWDz+Pv8OovH39mtzB6bVnWyeXzeJBfAEsVlk5Kak1mW
	WqRvl8CVsWzvQsaCZewVn2dvY21gvMzaxcjJISFgInFy6y52CFtM4sK99WxdjFwcQgJLGSXe
	3X7HBFN0cG8DG4gtJDCdUeLieUEI+zWjxONl7iA2r4CWxNlN+5hBbBYBVYkPNx6BLWAT0JHY
	/u042BxRgTCJiTcfs0LUC0r8mHyPBcQWEUiWuP9lJthiZoFrjBIHrj4AGyQs4CpxeNIbFoiL
	mpgkTi25D5bgFAiW2Nz6FMjmAOpQl5gyJRckzCwgL7F5zVtmiKP3sUts+FwCcZCAxLfJh1hA
	yiUEZCU2HYAqkZQ4uOIGywRGsVlITpqFMHQWkqELGJlXMYqmFiQXFCelF5noFSfmFpfmpesl
	5+duYgTG1+l/zybsYLx3wPoQowAHoxIPb0Pz0RAh1sSy4srcQ4ymQEdMZJYSTc4HRnFeSbyh
	sZmRhamJqbGRuaWZkjjva6mfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYPX6WJa080T/j
	bJxOltjXTIXmICWDIi6P5Q842I9Kbz/mOolT5+OSDSvNnnuzHA5SV0k7cGPZozNeyh+r1lsU
	m25SqWq4lX/1t7Vy0etz3rOEDvi/Co5xCxQXuT/18GenKjuptOiuPSud2m/6t51yMV4aqOSz
	5d/Sm4cEinP2fNA+GT8xunSWEktxRqKhFnNRcSIAIfRPMKoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQd01c46GGDz4bGox/8g5Votrv2ew
	WfQ/fs1scXnXHDaLGef3MVlMP/6W1YHN4+/z6ywef2e3MntsWtXJ5vF5k1wAS1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8ayvQsZC5axV3yevY21gfEyaxcjJ4eEgInE
	wb0NbBC2mMSFe+vBbCGB6YwSF88LQtivGSUeL3MHsXkFtCTObtrHDGKzCKhKfLjxCGwOm4CO
	xPZvx5lAbFGBMImJNx+zQtQLSvyYfI8FxBYRSJa4/2Um0HwuDmaBa4wSB64+ABskLOAqcXjS
	GxaQhJBAE5PEqSX3wRKcAsESm1ufAtkcQB3qElOm5IKEmQXkJTavecs8gVFgFpIdsxCqZiGp
	WsDIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOH6fSe9gXNVgcYhRgINRiYdXo/FoiBBr
	YllxZe4hRgkOZiUR3vIpQCHelMTKqtSi/Pii0pzU4kOMpsAQmMgsJZqcD0wteSXxhsYmZkaW
	RuaGFkbG5krivEr2bSFCAumJJanZqakFqUUwfUwcnFINjCv9Vdsn5sY2Fek/ZKy0cQ+JcX17
	K/qi14JXpxYq7N4UxPK/wNs8aZeFZuma6VzVgc6vt0q+85Iv7puhJ9E3z+TYNrd0t3MzDkbE
	HZ+gZbPNUEIkese6lg69fmc520e1ut2rZZuZK6p8KsKPFkzK7jzNqnV7Dvfk6K2PUw7s0rR9
	cTp264MNSizFGYmGWsxFxYkAPDygD/UCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/24/2015 12:59 AM, Javier Martinez Canillas wrote:
> Hello Sjoerd,
> 
> On Fri, Jan 23, 2015 at 4:47 PM, Sjoerd Simons
> <sjoerd.simons@collabora.co.uk> wrote:
>>>
>>> If this pin is used by the Odroid XU3 board, shouldn't be defined in
>>> the exynos5422-odroidxu3.dts instead?
>>
>> It's not just used by the XU3 though, it's also hooked up on the peach
>> pi chromebook for example and i would expect it to be hooked up on most
>> board with an eMMC
>>
>> This change is consistent with most of the special purpose GPIO pins
>> defined in that file, so i don't see the problem with including it in
>> that pinctrl file
> 
> In that case I completely agree that it should be defined in the .dtsi
> but that is not what the commit message said though :-)

I will resend the patch with obvious commit message.
Thanks for review.

Best Regards,
Jaehoon Chung

> 
> Best regards,
> Javier
> 

