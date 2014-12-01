Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaLABaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:30:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36930 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaLABaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:30:10 -0500
X-AuditID: cbfee691-f79b86d000004a5a-60-547bc4a0f583
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
Message-id: <547BC49F.8040402@samsung.com>
Date: Mon, 01 Dec 2014 10:30:07 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Subject: Re: [PATCH 1/2] Input: add regulator haptic driver
References: <1416490300-28865-1-git-send-email-jaewon02.kim@samsung.com>
 <1416490300-28865-2-git-send-email-jaewon02.kim@samsung.com>
 <20141128125051.GA3643@sirena.org.uk>
In-reply-to: <20141128125051.GA3643@sirena.org.uk>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkQHfBkeoQgz1XxS2mPnzCZnH9y3NW
	i8OLXjBafP7Qwm7Ru+Aqm8XNT99YLS7vmsNmMeP8PiYHDo+ds+6ye2xa1cnm0bdlFaPH501y
	ASxRXDYpqTmZZalF+nYJXBkXVkxkKbjJXvH5ZAtbA+Mcti5GTg4JAROJRXf3M0PYYhIX7q0H
	inNxCAksZZT4dPM6M0zRi5XnWSASixglvk1rZwJJ8AoISvyYfI8FxGYWMJN41LKOGcIWltjb
	uhAqri2xbOFrZojm14wS7ds6mSGatSSW3TrICGKzCKhKbGpoAzuJDajh+/rFrCC2qECExJU1
	c8BqRASUJa5+3wt2BbNAG5NE/5G9YAlhAWuJr5tfM0JsWM8osXfqcrAEp4CRxMrm6WAPSQhc
	YpfYcvMJC8Q6AYlvkw8B2RxACVmJTQeg/pSUOLjiBssERvFZSL6bheS7WUi+m4XkuwWMLKsY
	RVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxAqP19L9nE3cw3j9gfYhRgINRiYdXYn51iBBrYllx
	Ze4hRlOgiyYyS4km5wNTQl5JvKGxmZGFqYmpsZG5pZmSOK+O9M9gIYH0xJLU7NTUgtSi+KLS
	nNTiQ4xMHJxSDYyMd190KCX0WNf/3MjjJ3JB6v20u/wq8x2bQt+Wp1rke9m9kKr6GsRUzymT
	GbRt5627Dv+MgvpPp2ya7ZnHduJaTNX6kN0zVrf2vNbXTH304gHr9kruipOtOWdNa0x4erN/
	TlBlDXRlmrFpVv3qqnfbnD8VCx7Vcbde79xziavys0je5vKFB5VYijMSDbWYi4oTAfs83LbR	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t9jAd0FR6pDDLr+8ltMffiEzeL6l+es
	FocXvWC0+Pyhhd2id8FVNoubn76xWlzeNYfNYsb5fUwOHB47Z91l99i0qpPNo2/LKkaPz5vk
	AliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmHLpyjrFgOXvFow0rmBsY
	X7F2MXJySAiYSLxYeZ4FwhaTuHBvPVsXIxeHkMAiRolv09qZQBK8AoISPybfAyri4GAWkJc4
	cikbJMwsYCbxqGUdM0T9a0aJ9m2dzBD1WhLLbh1kBLFZBFQlNjW0sYHYbALaEt/XLwZbLCoQ
	IXFlzRywGhEBZYmr3/eygAxiFmhjkug/shcsISxgLfF182tGiA3rGSX2Tl0OluAUMJJY2Tyd
	bQKjwCwkB85COHAWkgMXMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO62dSOxhXNlgc
	YhTgYFTi4T04pzpEiDWxrLgy9xCjBAezkgjvOQ+gEG9KYmVValF+fFFpTmrxIUZToPcmMkuJ
	JucDU05eSbyhsYmZkaWRuaGFkbG5kjjvjZu5IUIC6YklqdmpqQWpRTB9TBycUg2MBxVTSkzO
	LJBtfj93W2pt6q/tn9X49hQ//rrknPW6DeFmQtP/vFq/vpBjwp3dBTJ5fLeN/HatPp+jwxWU
	wlbPw+hjdzhrfsmsT3m6R33jChe4v3b7aba3e58OU+/tg5z7q7fflc4/tyf5POOSPy9rcllt
	G+1Xr3hXzmTjvNdM8sOdBaWZl548V2Ipzkg01GIuKk4EAHCIP/MBAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

2014년 11월 28일 21:50에 Mark Brown 이(가) 쓴 글:
> On Thu, Nov 20, 2014 at 10:31:39PM +0900, Jaewon Kim wrote:
>
>> +	haptic->regulator = devm_regulator_get(&pdev->dev, "haptic");
>> +	if (IS_ERR(haptic->regulator)) {
>> +		dev_err(&pdev->dev, "failed to get regulator\n");
>> +		return PTR_ERR(haptic->regulator);
>> +	}
> This needs to be _get_exclusive() - the driver will be broken if
> something else shares the regualtor since it relies on both enabling and
> disabling the regulator and on setting the voltage for effects.  It's
> not like a power supply where leaving the device powered when it could
> be off is going to have no effect, if the power is left on then the
> haptic motor will continue to operate.

Thanks to review my patch.

Haptic regulator has to only be used in this driver.
So, it is right to change like your advice.
I will fix next version.

Thanks
Jaewon Kim.
