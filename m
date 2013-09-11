Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3IKAev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:34:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62250 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3IKAet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:34:49 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-c6-522fbaa8e2f8
Message-id: <522FBAA8.2060506@samsung.com>
Date: Wed, 11 Sep 2013 09:34:48 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: Remove casting the return value which is a void
 pointer
References: <005201cead1e$1f2007a0$5d6016e0$%han@samsung.com>
In-reply-to: <005201cead1e$1f2007a0$5d6016e0$%han@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWyRsSkQHfFLv0gg8/nhSwuL7zEanF51xw2
	i9uNK9gcmD36tqxi9Pi8SS6AKYrLJiU1J7MstUjfLoEr4/3kN0wFl5grtsxqYW5gfM/UxcjJ
	ISFgInGk5TELhC0mceHeerYuRi4OIYGljBK3j91ngym6d2wuE0RiOqPElFVPoKpeMUq8WfeF
	uYuRg4NXQEvi91sjkAYWAVWJBc+62EFsNqDw/hc3wAaJCoRJrJx+BWwbr4CgxI/J98BsEQEV
	ic/rj4PVMAt4S+yYOIEVxBYGqr9w7B1YjZCArcSRVTPBbE4BO4nZl68zQtTrSOxvnQbVKy+x
	ec1bZpDbJASms0v0nd7GBnGQgMS3yYdYQO6UEJCV2HSAGeIxSYmDK26wTGAUm4XkpFlIxs5C
	MnYBI/MqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjMCIOf3vWe8OxtsHrA8xJgOtnMgsJZqc
	D4y4vJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	3nvQH212U6Pk1sT6fyscrjvVT2o4P+Wr9qrdUsmNF2p/2Z0qVtiy6MGcs7OnFyX5si0NP5D4
	dOH77xvFEh3LmfJixWSMgtl2hAZ+KW0xn9b52lC9SXLX71SxF0tqajsqw9YEXLm7nHUB8955
	ti+4chhCutSnl2/zWaDn+detwefIMaZjG/JXKLEUZyQaajEXFScCANZcS4WuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQd0Vu/SDDH6081hcXniJ1eLyrjls
	FrcbV7A5MHv0bVnF6PF5k1wAU1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEN
	Y8b7yW+YCi4xV2yZ1cLcwPieqYuRk0NCwETi3rG5ULaYxIV769m6GLk4hASmM0pMWfUEynnF
	KPFm3RfmLkYODl4BLYnfb41AGlgEVCUWPOtiB7HZgML7X9xgA7FFBcIkVk6/wgJi8woISvyY
	fA/MFhFQkfi8/jhYDbOAt8SOiRNYQWxhoPoLx96B1QgJ2EocWTUTzOYUsJOYffk6I0S9jsT+
	1mlQvfISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	Hp9J72Bc1WBxiFGAg1GJh/eGnH6QEGtiWXFl7iFGCQ5mJRHeqU5AId6UxMqq1KL8+KLSnNTi
	Q4zJwBCYyCwlmpwPTBV5JfGGxiZmRpZG5oYWRsbmpAkrifMebLUOFBJITyxJzU5NLUgtgtnC
	xMEp1cCYsu7od5aDYrt2JWmmsjcKBe/aco9XchHTOoFdypt+vmvbuf/qIt4l+mEFj/f8XSIv
	EFeS/aOAn/d/x/l7Ow5acO/+vmmtzuGas/Vsz3u4dYw13qVFXd2dmMdyQKiN5U3L3MSnn/8m
	Pt4S3Ss2Lcf4WVXax+YP1WzKEuZ7Oz8cu1LrucHI2GidEktxRqKhFnNRcSIAK9IsdAsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On 09/09/2013 02:33 PM, Jingoo Han wrote:
> Casting the return value which is a void pointer is redundant.
> The conversion from void pointer to any other pointer type is
> guaranteed by the C programming language.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/extcon/extcon-class.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Applied it on extcon-linus branch.

Thanks,
Chanwoo Choi

