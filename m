Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3IZHMC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:12:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48201 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3IZHMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:12:00 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-22-5243de3f189d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Balaji T K'" <balajitk@ti.com>, "'Nishanth Menon'" <nm@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
 <001701ceba5d$f0827750$d18765f0$%han@samsung.com>
In-reply-to: <001701ceba5d$f0827750$d18765f0$%han@samsung.com>
Subject: Re: [PATCH V2 17/18] regulator: twl: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:11:59 +0900
Message-id: <003001ceba87$b0fb17c0$12f14740$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAWzIQAAlt6aA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zQ137e85BBp3zpC2mTt7OZjH14RM2
	i8sLL7FafLvSwWRxedccNos3P84yWZz808vowO6xc9Zddo9NqzrZPO5c28Pm0bdlFaPH8Rvb
	mTw+b5ILYIvisklJzcksSy3St0vgymg6d4i54A1bxeevO9kbGI+ydjFyckgImEj0ff7JDmGL
	SVy4t56ti5GLQ0hgGaPEhS0bmGGKHra1M0EkFjFKNCybA+X8YpT4MucbE0gVm4CaxJcvh8FG
	iQj4S+y++wRsBbPAWkaJuQuiQGwhgUKJf13PgaZycHAK2Ek0/7UECQsLeEvsWjGHEcRmEVCV
	uH67CWwkr4CtxIbfmxghbEGJH5PvsUCM1JJYv/M4E4QtL7F5zVuwkRIC6hKP/upCXGAl0bL7
	IhtEiYjEvhfvGEFOlhD4yi5x7cJcJohdAhLfJh9igeiVldh0AOpfSYmDK26wTGCUmIVk8ywk
	m2ch2TwLyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MULiuHcH4+0D1ocYk4HWT2SW
	Ek3OB6aBvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwVnH9VX63TWXaVsXOte9+GTyS3sqi4fdRNez/rX8zdaP+Br7wF5kwtW5mm7Noru/+wz8u
	ZjM2tX74Fq7MV+C2YcuG74IV6+f1CWoK3pl+67HOt1f6J1Zf7zXaHPOEYd52vau+XaKPly45
	zFYmdoJBzfzprQuz/EodZ6lrv71yXcxl+YaS79yxLkosxRmJhlrMRcWJAPIJFvb5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAV37e85BBg8miFtMnbydzWLqwyds
	FpcXXmK1+Halg8ni8q45bBZvfpxlsjj5p5fRgd1j56y77B6bVnWyedy5tofNo2/LKkaP4ze2
	M3l83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjGj6dwh5oI3bBWf
	v+5kb2A8ytrFyMkhIWAi8bCtnQnCFpO4cG89WxcjF4eQwCJGiYZlc5ggnF+MEl/mfAOrYhNQ
	k/jy5TA7iC0i4C+x++4TsEnMAmsZJeYuiAKxhQQKJf51PWfuYuTg4BSwk2j+awkSFhbwlti1
	Yg4jiM0ioCpx/XYT2EheAVuJDb83MULYghI/Jt9jgRipJbF+53EmCFteYvOat2AjJQTUJR79
	1YW4wEqiZfdFNogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGMFJ4pn0DsZVDRaHGAU4GJV4eC8wOwcJsSaWFVfmHmKU4GBWEuH9ZgQU4k1J
	rKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgAssriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6
	YklqdmpqQWoRzBYmDk6pBkbXYOk++ax+xoapK6rXr7W3vPL0DJvRksN9C8WOHMywVPV2OjpD
	kG3/zOc/21i+e28JW9xaoLBo84q1939v23L45jbvdxkyYRdO//j5bdsJCSeD2C2nM+e9PW/4
	UMF727IlMmuvb567Tn/T4c6mH/t9UpdezN5t7zAz9KP4T15PpfZbNtqfv144ocRSnJFoqMVc
	VJwIAHXgA4NWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 11:13 AM, Jingoo Han wrote:
> 
> Use devm_regulator_register() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/regulator/twl-regulator.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

[.....]

> @@ -1217,7 +1217,6 @@ static int twlreg_remove(struct platform_device *pdev)
>  	struct regulator_dev *rdev = platform_get_drvdata(pdev);
>  	struct twlreg_info *info = rdev->reg_data;
> 
> -	regulator_unregister(rdev);
>  	kfree(info);
>  	return 0;
>  }

kfree(info) is kfree(rdev->reg_data).
The following would be right.
  1. kfree(rdev->reg_data)
  2. regulator_unregister(rdev)

Also, regulator_unregister() does not access 'rdev->reg_data'.
So, it would not make the problem.

Best regards,
Jingoo Han

