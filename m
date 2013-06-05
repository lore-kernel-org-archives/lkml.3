Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3FELrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:47:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30407 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3FELq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:46:57 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-7a-51af252f7df2
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Sylwester Nawrocki'" <sylvester.nawrocki@gmail.com>,
        linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "=?UTF-8?Q?'Heiko_St=C3=BCbner'?=" <heiko@sntech.de>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1370088225-5187-1-git-send-email-sylvester.nawrocki@gmail.com>
In-reply-to: <1370088225-5187-1-git-send-email-sylvester.nawrocki@gmail.com>
Subject: RE: [PATCH 1/2 RESEND] gpio: samsung: Remove OF support for s3c24xx
Date: Wed, 05 Jun 2013 20:46:55 +0900
Message-id: <08e201ce61e2$60c1a650$2244f2f0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5ewCZSwta8eihaSLCAQgN/2GyRVQDIhXsA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zY1191fWBBs2b5S3+P3rNanG26Q27
	xZQ/y5ksLu+aw2Yx4/w+JovDb9pZLeZ93snkwO6xc9Zddo871/awefRtWcXosf3aPGaPz5vk
	AlijuGxSUnMyy1KL9O0SuDJmzexmL7jAXtGx4zlLA+NKti5GTg4JAROJ5iOPmCBsMYkL99YD
	xbk4hASWMUoc2n2KCaZo5s5pTBCJRYwSK5smsYMkhAT+Mko82BsDYrMJaEgcfv8MLC4iECwx
	4VoXO0gDs8BNRonudxPZIBq8JS4+u8YKYnMK+Ej82vQYzBYGsl9dXwfWzCKgKnGy6x1LFyMH
	B6+ArcSzlWBH8AoISvyYfI8FxGYWUJeYNG8RM4StLfHk3QVWkHIJoPijv7oQJxhJnFnziA2i
	RERi34t3jBC/vGWX+Lc3CGKTgMS3yYdYIFplJTYdYIYokZQ4uOIGywRGiVlIFs9CsngWksWz
	kGxYwMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMkdifsYLx3wPoQYzLQ+onMUqLJ+cDY
	zyuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo9eu
	h+fXntVKzKsRjak0zvGLEmQ5Uc1uoNUru+xC6rLVBZeW5YeqciyqOfvcOLPlRyKr1E+dY3Jv
	Ngv+Ctln6yYh7b8j79mExgc7V8777lRRlHb8PM9Fm1umGpIiMYdjZq3btPbccyPZ/V0r6p5/
	1d1273N54MS/ZgpBhao7D+xjYXgR16nRrcRSnJFoqMVcVJwIALgDElvzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAV191fWBBleWSVv8f/Sa1eJs0xt2
	iyl/ljNZXN41h81ixvl9TBaH37SzWsz7vJPJgd1j56y77B53ru1h8+jbsorRY/u1ecwenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmDWzm73gAntFx47nLA2M
	K9m6GDk5JARMJGbunMYEYYtJXLi3HijOxSEksIhRYmXTJHaQhJDAX0aJB3tjQGw2AQ2Jw++f
	gcVFBIIlJlzrYgdpYBa4ySjR/W4iG0SDt8TFZ9dYQWxOAR+JX5seg9nCQPar6+vAmlkEVCVO
	dr1j6WLk4OAVsJV4thLsCF4BQYkfk++xgNjMAuoSk+YtYoawtSWevLvAClIuARR/9FcX4gQj
	iTNrHrFBlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvX
	S87P3cQITg3PpHYwrmywOMQowMGoxMP7gWFdoBBrYllxZe4hRgkOZiUR3ku/gUK8KYmVValF
	+fFFpTmpxYcYk4H+nMgsJZqcD0xbeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1O
	TS1ILYLZwsTBKdXA6DCp8KKzqrnjgly+DWI+DasY2eqUruyznab74UhPnU/5RjnWkMdhc99c
	7HRcw9609fbn3QvTzwgXTFP/IT93ZeOVr5Ps/c7XiDvrrRGJnpnQL5Z343KKZHeohdj1qtdK
	1c5BJk8/ay7P6FgjbMHC8j34Ua55x5fMFf3aC6OW/78xtWeRV42ZEktxRqKhFnNRcSIAXzz/
	OVEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sylwester Nawrocki wrote:
> 
> From: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> There is no users of this code and there is already a pinctrl
> driver written for s3c24xx which is going to be used on any
> s3c24xx DT platforms. Hence this has been effectively a dead
> code in mainline.
> 
> This reverts commit 172c6a13653ac8cd6a231293b87c93821e90c1d6
> gpio: samsung: add devicetree init for s3c24xx arches
> 
> Cc: Heiko Stübner <heiko@sntech.de>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Heiko Stuebner <heiko@sntech.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> This patch was supposed to be merged through the Samsung tree
> (https://patchwork.kernel.org/patch/2450291) but it seem to
> have slipped through the cracks.
> 
Oh, OK. Let me apply into the samsung tree.

Thanks for your gentle reminder.

- Kukjin

