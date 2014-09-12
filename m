Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbaILBiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 21:38:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23154 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaILBio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 21:38:44 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfee68d-f79c46d000000b84-85-54124ea1949e
Content-transfer-encoding: 8BIT
Message-id: <54124EA1.8060507@samsung.com>
Date: Fri, 12 Sep 2014 10:38:41 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 2/4] Input: misc: Add haptic driver on max77693
References: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
 <1410440062-19963-3-git-send-email-jaewon02.kim@samsung.com>
 <20140911171002.GC13083@core.coreip.homeip.net>
In-reply-to: <20140911171002.GC13083@core.coreip.homeip.net>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWyRsSkUHehn1CIweleC4vrX56zWhxe9ILR
	4v7Xo4wWNz99Y7W4vGsOm8XpblYHNo+ds+6ye9y5tofNY97JQI++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKWL1Lr+ATW8WVu++ZGhgvsXYxcnJICJhItFzvhbLFJC7cW8/WxcjFISSwlFHi
	yv9FzF2MHGBFu/aEgNQICSxilLh4WBTE5hUQlPgx+R4LSAmzgLzEkUvZIGFmATOJRy3rmCHK
	XzNKPHknB1GuJbGo5SMLiM0ioCrR0PoUrIZNQFvi+/rFYCeICoRJPPt1kAnEFhHQl9g++xcj
	yDnMAusZJW4e+sMGkhAWcJM4dmkjM8SdOxklTj/+BJbgFLCR+NdyiR0kISFwil3i29VDUOsE
	JL5NPsQC8YysxKYDzBAPS0ocXHGDZQKj2Cwk/8xC+GcWkn8WMDKvYhRNLUguKE5KLzLUK07M
	LS7NS9dLzs/dxAiMsdP/nvXuYLx9wPoQowAHoxIPbwWLYIgQa2JZcWXuIUZToCMmMkuJJucD
	IzmvJN7Q2MzIwtTE1NjI3NJMSZxXUepnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGTPaq
	jd8mP1D3nKicUGIrm1XgXPwirkJE+dLntAuVufOu/jk1MfjlbHP23ymLf1uuZ7ZaXM3GwuG4
	I7ZsVlszn4Xpz67Q91f3z6/Zq7OL193knd/Hy0k/jjrYuc2ZM+1zmc0nDt6rb05ON11g8+Jl
	Ov8iB8nc5f0HD4kcmyBec7hcQeNsVQO3EktxRqKhFnNRcSIAFu5UiawCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAd2FfkIhBu1XDCyuf3nOanF40QtG
	i/tfjzJa3Pz0jdXi8q45bBanu1kd2Dx2zrrL7nHn2h42j3knAz36tqxi9Pi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bqXXoFn9gqrtx9z9TAeIm1i5GDQ0LA
	RGLXnpAuRk4gU0ziwr31bCC2kMAiRomLh0VBbF4BQYkfk++xgJQzC8hLHLmUDRJmFjCTeNSy
	jhmi/DWjxJN3chDlWhKLWj6ygNgsAqoSDa1PwWrYBLQlvq9fzApiiwqESTz7dZAJxBYR0JfY
	PvsXYxcjF9DM9YwSNw/9AbtBWMBN4tiljcwgCSGBnYwSpx9/AktwCthI/Gu5xD6BUWAWkvtm
	Idw3C8l9CxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/AzqR2MKxssDjEKcDAq8fBW
	sAiGCLEmlhVX5h5ilOBgVhLhfaAlFCLEm5JYWZValB9fVJqTWnyI0RTovYnMUqLJ+cDkklcS
	b2hsYmZkaWRuaGFkbK4kznug1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgZH7mfzJ7d+u/NbMFH15
	VtlYeuoUdW13hq+psYkL1xr1XZY6/+SGZElvsNmU39tKYq9vyewoWL52b/+DCYmqFZEn5Lb5
	1W1wlFGOe3312MME5f5au/8TN3ytmH8zq3Ti9nfXCmdEv5nz8sY3l/X6U37e9mlPfbpapUb2
	4q6UTbM7/OYrq2sv+LpTiaU4I9FQi7moOBEA7EzkffYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmity Torokhov.

2014년 09월 12일 02:10에 Dmitry Torokhov 이(가) 쓴 글:
> On Thu, Sep 11, 2014 at 09:54:20PM +0900, Jaewon Kim wrote:
>> This patch add max77693-haptic device driver to support the haptic controller
>> on MAX77693. The MAX77693 is a Multifunction device with PMIC, CHARGER, LED,
>> MUIC, HAPTIC and the patch is haptic device driver in the MAX77693. This driver
>> support external pwm and LRA(Linear Resonant Actuator) motor. User can control
>> the haptic driver by using force feedback framework.
>>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> How do we want to merge this?
>
thanks for review.

Please merge this input device patch only.
Another patchs will be merged by lee jones.


thanks
Jaewon Kim
