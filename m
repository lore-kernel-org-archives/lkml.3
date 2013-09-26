Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3IZMa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:30:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16497 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab3IZMa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:30:56 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-42-524428f91f9a
Message-id: <524428FA.1010903@samsung.com>
Date: Thu, 26 Sep 2013 21:30:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 (RESEND)] extcon: arizona: Correct typo in headphone
 detect range transitions
References: <1379943239-2779-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1379943239-2779-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkRPenhkuQwdZOcYt/U26wW1zeNYfN
	4nbjCjaL5W//szmweLyc+JvNo2/LKkaPz5vkApijuGxSUnMyy1KL9O0SuDKevv/KUrCKueLq
	4h72BsYrTF2MnBwSAiYSu9fsZIewxSQu3FvP1sXIxSEksJRRYuHd/4wwRT2rD7JDJBYxSqzv
	v8AE4bxilLh98CsrSBWvgJbEkd9HWUBsFgFViU/LboN1swHF97+4wQZiiwqESaycfoUFol5Q
	4sfke2C2iICFxJQlt5hBbGaBRIk5574AbePgEBZIlzg5IRUkLCQQIrHx0wawck6BUImXC2ax
	QJTrSOxvncYGYctLbF7zlhni6FXsEq+P1kCcIyDxbfIhFpCREgKyEpsOQJVIShxccYNlAqPY
	LCQHzUIydRaSqQsYmVcxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525iBMbQ6X/Pencw3j5gfYgx
	GWjlRGYp0eR8YAzmlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoHxXEBJwan83EWXzZ/lhTJee22hWLZT/0/FgdYqjRl3zB2WLcium+VSxfLkod3l
	wy/mNcQ+Mz3i/CQ+cOOazJvr1eM/HOKrVFSrz7ZVlnx/7vPDinctEjt2hH9X0HsZZRfiWKyS
	eXbNk8WXHV+tmftE/JdeaTznm4h3B1bts6krbJdL31xw44mIEktxRqKhFnNRcSIAFWai+rcC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgO5PDZcgg90tAhb/ptxgt7i8aw6b
	xe3GFWwWy9/+Z3Ng8Xg58TebR9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmPH3/laVgFXPF1cU97A2MV5i6GDk5JARMJHpWH2SHsMUkLtxbz9bFyMUh
	JLCIUWJ9/wUmCOcVo8Ttg19ZQap4BbQkjvw+ygJiswioSnxadpsRxGYDiu9/cYMNxBYVCJNY
	Of0KC0S9oMSPyffAbBEBC4kpS24xg9jMAokSc859AdrMwSEskC5xckIqSFhIIERi46cNYOWc
	AqESLxfMYoEo15HY3zqNDcKWl9i85i3zBEaBWUg2zEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwTH6THoH46oGi0OMAhyMSjy8F5idg4RYE8uKK3MPMUpwMCuJ8L6VdQkS
	4k1JrKxKLcqPLyrNSS0+xJgMDICJzFKiyfnA9JFXEm9obGJmZGlkbmhhZGxOmrCSOO/BVutA
	IYH0xJLU7NTUgtQimC1MHJxSDYxztTrmcE66cbtbVqu5y6ij6wwTw6SjHhnTU7ZWxCnfqZ7z
	5692ou9alU7+y1YXenLkXRvFd/N4Pbz2I5mLx8X52dPbfXsmbglumZys3mikkXppmmrI0Q2R
	X3zCC9xZvR/4zL5k8o8n7tXVLp5d0oaP3gh33GOMfmhzyn4K65R/FTdyuVpzhJRYijMSDbWY
	i4oTAVB9sM8VAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 10:33 PM, Charles Keepax wrote:
> We should move range when the measured value is greater than or equal to
> the max value not when greater than.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 

Applied this patchset on extcon-linus branch.

Thanks,
Chanwoo Choi

