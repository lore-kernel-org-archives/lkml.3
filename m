Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3JWBsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:48:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47038 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3JWBsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:48:00 -0400
X-AuditID: cbfee691-b7f866d000001b8c-f9-52672acee5a6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Johan Hovold'" <jhovold@gmail.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
 <1382462819-28576-3-git-send-email-jhovold@gmail.com>
In-reply-to: <1382462819-28576-3-git-send-email-jhovold@gmail.com>
Subject: Re: [PATCH 2/9] backlight: atmel-pwm-bl: fix gpio polarity in remove
Date: Wed, 23 Oct 2013 10:47:58 +0900
Message-id: <001a01cecf91$e67fb620$b37f2260$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7PS/WUgNmKml7oTTu1vQ1Ao3Gc7QARa/jw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zY91zWulBBq2nrSxeHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yWizY+IjRgcNjwa+tLB47Z91l99gz/werR9+WVYwe
	nzfJBbBGcdmkpOZklqUW6dslcGV0fFrMXPCAuWJ36yGWBsYm5i5GTg4JAROJRTOms0PYYhIX
	7q1n62Lk4hASWMYo8fnMT1aYovu9c6AS0xklHn24yAKSEBL4xSjx/QIbiM0moCbx5cthsEki
	QPaT3iPsIA3MAhcYJY6/fMII0VApMevibbCpnAJOEi8PrgGLCwv4Siy/8wYsziKgKrH05kog
	m4ODV8BW4tEqJ5Awr4CgxI/J98D2MgtoSazfeZwJwpaX2LzmLTNIuYSAusSjv7oQJxhJdN5r
	Y4UoEZHY9+IdI8g5EgIf2SXaHy1hhlglIPFt8iEWiF5ZiU0HoIEiKXFwxQ2WCYwSs5BsnoVk
	8ywkm2chWbGAkWUVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRkgMT9zBeP+A9SHGZKD1E5ml
	RJPzgSkgryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoYq36zx/hP4FmQ8zaBa8kNsYD0v8nzJxj+Ks5OCIy6e1Z7ken1J2I68tKvj8yx+3a/W++P
	wRn1nDeTdV6E321+OPHP3S2V8Tv8epW1rmdPrNTLeTBXXJVZer+jx8fJPy3q3NN+Mgh8KH7G
	W/qte5OJmtrk/mPfr+ySmriLgTum77HdvtC/m3IDlFiKMxINtZiLihMBnOQV7/cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd1zWulBBu3PTC1eHtK0uLzwEqvF
	3lXSFif6PrBaXN41h83i2+Vmdovdu56yWizY+IjRgcNjwa+tLB47Z91l99gz/werR9+WVYwe
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6Pi0mLngAXPF7tZD
	LA2MTcxdjJwcEgImEvd757BB2GISF+6tB7K5OIQEpjNKPPpwkQUkISTwi1Hi+wWwIjYBNYkv
	Xw6zg9giQPaT3iPsIA3MAhcYJY6/fMII0VApMevibVYQm1PASeLlwTVgcWEBX4nld96AxVkE
	VCWW3lwJZHNw8ArYSjxa5QQS5hUQlPgx+R7YXmYBLYn1O48zQdjyEpvXvGUGKZcQUJd49FcX
	4gQjic57bawQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL
	89L1kvNzNzGCE8Qz6R2MqxosDjEKcDAq8fBatqcFCbEmlhVX5h5ilOBgVhLhbfYFCvGmJFZW
	pRblxxeV5qQWH2JMBvpzIrOUaHI+MHnllcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEk
	NTs1tSC1CGYLEwenVAMj31Rfn3SjQDuJDfydIcE+LSsOTmetX7ird+ujA5JxJ2IPexfHHnn9
	W+XwqxprD5GTTm6Pr08QeJCw/n5bacQT9b+Ot5ZvScn3nrRimtF8G98Zqnf8T8+xKeUos/GU
	mPvLxbd8/dU4za7AS5u3Ssot/3RmWpDZU4/93xpjb+5/PtH3YM9x57LZSizFGYmGWsxFxYkA
	evM/0VQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 23, 2013 2:27 AM, Johan Hovold wrote:
> 
> Make sure to honour gpio polarity also at remove so that the backlight
> is actually disabled on boards with active-low enable pin.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/video/backlight/atmel-pwm-bl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)


