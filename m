Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaIPG7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:59:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47208 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaIPG7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:59:47 -0400
X-AuditID: cbfee68d-f79c46d000000b84-a6-5417dfdfa4b8
Date: Tue, 16 Sep 2014 06:59:43 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 0/5] Add dt support for extcon gpio driver
To: George Cherian <george.cherian@ti.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rongjun.ying@csr.com" <rongjun.ying@csr.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140916065704822@myungjoo.ham
Msgkey: 20140916065704822@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140916065704822@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <15828005.405941410850778437.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkRPf+ffEQg/OHdC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG3IM/WAp6eCuurrjK3sB4h6eLkZNDSEBdYtGSk2wgtoSAiUTP
	k1nMELaYxIV769kgapYySpydkQ5Tc+75V9YuRi6g+BxGid4DS1hAEiwCqhL3X5xk6mLk4GAT
	MJe4PyMIJCws4CRx5+1vZpB6EYG/zBLtR98ygiSYBeokbi5qZ4ZYoCSxZt8rsDm8AoISJ2c+
	YYFYpiox7dRJdoi4msSbjRMZIeISErOmX2CFsHklZrQ/haqXk5j2dQ3UA9IS52dtYIR5ZvH3
	x1Bxfoljt3eA3QnS++R+MMyY3Zu/QMNBQGLqmYNQrVoSHRtfQ43nk1iz8C0LzJhdp5Yzw/Te
	3zKXCeItRYkp3Q/ZIWwtiS8/9rGhe4sXGCYtHz8zT2BUnoUkNQtJ+ywk7chqFjCyrGIUTS1I
	LihOSi8y1CtOzC0uzUvXS87P3cQITAun/z3r3cF4+4D1IUYBDkYlHt4TE8RChFgTy4orcw8x
	mgJjaSKzlGhyPjD55JXEGxqbGVmYmpgaG5lbmimJ8ypK/QwWEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwJiUuVhxYqjMk9ki+0pmXJNlEnZs9d+w36/hjfS6VcnXU9oY0jfeCth+M2Cx+Q3D
	v1z7j6fO/y84N2u1m23bGt71lvu8T9/cPtXr7Xyde/dSTyyINKl5lNlv6Ltq+e5dSeWWUxrr
	b5QHtIckz186/5Xxhr/aqazcKzUFeL58/3r+5/mv7vdsZByUWIozEg21mIuKEwGkW2dJBgMA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t/tPt3798VDDN5OV7e4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hsaxVoYGBkamQDUJaRlz
	D/5gKejhrbi64ip7A+Mdni5GTg4hAXWJRUtOsoHYEgImEueef2WFsMUkLtxbDxTnAqqZwyjR
	e2AJC0iCRUBV4v6Lk0xdjBwcbALmEvdnBIGEhQWcJO68/c0MUi8i8JdZov3oW0aQBLNAncTN
	Re3MEMuUJNbsewU2h1dAUOLkzCcsEMtUJaadOskOEVeTeLNxIiNEXEJi1vQLUAfxSsxofwpV
	Lycx7esaZghbWuL8rA2MMEcv/v4YKs4vcez2DrA7QXqf3A+GGbN78xeofwUkpp45CNWqJdGx
	8TXUeD6JNQvfssCM2XVqOTNM7/0tc5kg3lKUmNL9kB3C1pL48mMfG7q3eIFh0vLxM/MERrlZ
	SFKzkLTPQtKOrGYBI8sqRtHUguSC4qT0CkO94sTc4tK8dL3k/NxNjOD09GzhDsYv560PMQpw
	MCrx8Bb0iYUIsSaWFVfmHmKU4GBWEuFlvioeIsSbklhZlVqUH19UmpNafIjRFBiBE5mlRJPz
	gakzryTe0NjYxMzE1NLEwsDUXEmc9+7NpCAhgfTEktTs1NSC1CKYPiYOTqkGxpbsot4CndCL
	JW/ehxj/ZrRxt7yRaJhR5N5su2D7t3XmWzzO3f0nmn+rvOLcMVEhwW9lP+Q2vXz7+1tV6xXW
	l2/Xy93+pDtzU67a2Srh86z+4nknFDKNnZwW8nM372idaP83W3Sy/Y1a9m3LLi3tUdqfF3ls
	xkXHqTqzUjzqoqQWnHA11JH+ocRSnJFoqMVcVJwIALfEeENlAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8G6xtPf025567

> Hi Chanwoo,
> 
> Could you please look into this series?

Hi,

Chanwoo has been on a vacation since last week.
I think he will be out of office (and out of the work email)
until this week.

I will not be generally available this week as well.

Cheers,
MyungJoo.

> 
> On 09/09/2014 09:44 AM, George Cherian wrote:
> > This series
> >          - Convert extcon-gpio driver to use gpiod_* API's
> >          - Adds dt support to extcon-gpio driver.
> > 	- Add cable name support in case of dt.
> >
> > George Cherian (5):
> >    extcon: gpio: Minor cleanups
> >    extcon: gpio: Convert the driver to use gpio desc API's
> >    extcon: gpio: Add dt support for the driver.
> >    extcon: gpio: Always use  gpio_get_value_cansleep
> >    extcon: gpio: Add support for using cable names
> >
> >   .../devicetree/bindings/extcon/extcon-gpio.txt     |  23 +++++
> >   drivers/extcon/extcon-gpio.c                       | 100 +++++++++++++--------
> >   include/linux/extcon/extcon-gpio.h                 |   4 +-
> >   3 files changed, 89 insertions(+), 38 deletions(-)
> >   create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> >
> Regards
> -George
> 
> 
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
