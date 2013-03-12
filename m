Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3CLFLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:11:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12285 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3CLFLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:11:53 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-6c-513eb9182dd4
Date: Tue, 12 Mar 2013 05:11:52 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: Regulator API ignored return values
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>, Jingoo Han <jg1.han@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Dmitry Torokhov <dtor@mail.ru>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130312050934742@jg1.han
Msgkey: 20130312050934742@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130312050934742@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17686649.119241363065111720.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zQ12JnXaBBt9fSllc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMONlbVtDDU/H41VfmBsYH3F2MnBxCAkoSk07uZQSxJQRMJD4fbmaB
	sMUkLtxbz9bFyAVUs4xR4uHppywwRXtebmeFSMxnlFh46CMbSIJFQFXi4esHrCA2m4C6xITf
	EJOEBQwk9k76CbZBREBZ4tePSWDNzAKXmCXmz1zLBnGGrMS9ybOZQWxeAUGJkzOfADVzAG1T
	kLh3Tw7E5BVQlJh2qgbiBgmJO/f3s0LYvBIz2mFuk5OY9nUNM4QtLXF+1gZGmGcWf38MFeeX
	OHZ7BxPEdF6JJ/eDYcbs3vyFDcIWkJh65iBUq6pE686vTBA2n8SahW+hVglKnL7WzQzT27Dx
	NzuIzQx05ZTuh1C2lsSXH/vYUD0FYjtJfPv4i2UCo/IsJKlZSNpnIWlHVrOAkWUVo2hqQXJB
	cVJ6kTFyXG9ihCTB/h2Mdw9YH2LczwiMkonMUqLJ+cA0mlcSb2hsZmRhamJqbGRuaUahsImp
	hYWJEVWElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwGjIee320Xj4sPSf8j1OW
	cOCsI5/cmOb21fkqL9LoqTuy8EqouUPp/dJDyv6b76j2B+6N3LZ6q/ojvf2zlZV1fma83X52
	ziWn3INe/jGrXN5W9LILVjnP671bb/eyQrPTYpnKUqtWKXfdY5c85k36VLbsZkdTQe/jOy9X
	7bt0W2muYKlUukGGEktxRqKhFnNRcSIAW2myiPUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DF2JnXaBBv8OiFtc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jJO9ZQU9PBWPX31lbmB8wN3FyMkhJKAkMenkXkYQW0LARGLPy+2sELaYxIV769m6GLmAauYz
	Siw89JENJMEioCrx8PUDsCI2AXWJCb+bWUBsYQEDib2TfoINEhFQlvj1YxIrSDOzwCVmifkz
	17JBbJOVuDd5NjOIzSsgKHFy5hOgZg6gbQoS9+7JgZi8AooS007VQNwgIXHn/n6oe3glZrQ/
	ZYGw5SSmfV3DDGFLS5yftYER5ubF3x9Dxfkljt3ewQQxnVfiyf1gmDG7N39hg7AFJKaeOQjV
	qirRuvMrE4TNJ7Fm4VuoVYISp691M8P0Nmz8zQ5iMwNdOaX7IZStJfHlxz42VE+B2E4S3z7+
	YpnAKDcLSWoWkvZZSNqR1SxgZFnFKJpakFxQnJReYaJXnJhbXJqXrpecn7uJEZyeni3Zwdhw
	wfoQowAHoxIP74nPtoFCrIllxZW5hxglOJiVRHgzNtsFCvGmJFZWpRblxxeV5qQWH2JMBsbf
	RGYp0eR8YOrMK4k3NDY2MTMxNTewMLA0J01YSZz3Wat1oJBAemJJanZqakFqEcwWJg5OqQbG
	ZrdoTr4TJgaSTyzW/FvT4G+U6WIe0VUnzj+jZX+P/43QdbKfu7PrN6w0fczeuH9VIm9d7/Mu
	2aW7EoM5guIsd9550JU8V5l35cMN3n6Hd5/RSkn2jdxo8ef9p/difVdsgnTPvN66i5lNJ9Lj
	HlfR3l3//E4G31jzbOedwrLVWV+nPlDb0tmgxFKckWioxVxUnAgAsAFC1pMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2C5BvLN012961

On Tuesday, March 12, 2013 5:44 AM, Arnd Bergmann wrote:
> 
> Hi all,
> 
> Mark Brown has added a patch to Linux-next that warns about certain regulator
> API functions being called without checking the results, which seems to have
> uncovered a number of bugs.
> 
> I've added a few people to Cc that might be interested in the reports and
> in fixing these bugs. Below you can find a list of all instances I found
> building the ARM defconfigs.
> 
> 	Arnd
> 
[...]
> /git/arm-soc/drivers/video/backlight/l4f00242t03.c: In function 'l4f00242t03_lcd_init':
> /git/arm-soc/drivers/video/backlight/l4f00242t03.c:58:18: warning: ignoring return value of
> 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]
> /git/arm-soc/drivers/video/backlight/l4f00242t03.c:61:18: warning: ignoring return value of
> 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]

Hi Arnd Bergmann,

I fixed these warnings and the patch was added to mm-tree.
(http://www.spinics.net/lists/mm-commits/msg95324.html)
Thank you for reporting :)

Best regards,
Jingoo Han
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
