Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaKFBPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:15:00 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19424 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaKFBO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:14:58 -0500
X-AuditID: cbfee691-f79b86d000004a5a-79-545acb900e78
Message-id: <545ACB8F.3080508@samsung.com>
Date: Thu, 06 Nov 2014 10:14:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: myungjoo.ham@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rongjun.ying@csr.com, Baohua.Song@csr.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RESEND PATCH 0/2] Add dt support for extcon gpio driver
References: <1415201388-32060-1-git-send-email-george.cherian@ti.com>
In-reply-to: <1415201388-32060-1-git-send-email-george.cherian@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkRHfC6agQg8ULBCxezrzKajH/yDlW
	i/43C1ktTh1czmpx7tVKRovLu+awWcxe0s9isfT6RSaL240r2CwmTF/LYtG69wi7xb4Lf1gd
	eDzWzFvD6HG5r5fJY9fOOaweK5d/YfPYtKqTzaNvyypGj+M3tjN5fN4kF8ARxWWTkpqTWZZa
	pG+XwJWxfvVWxoIPrBVfFp1maWA8zdLFyMkhIWAicXbaXihbTOLCvfVsXYxcHEICSxklNv15
	wAhTdOPffFaIxCJGiU/fehghnNeMEodmvwBr5xXQkli+Zh0riM0ioCqxZcIVJhCbDSi+/8UN
	NhBbVCBMYuX0K1D1ghI/Jt8Ds0WAavovdTOBDGUWmMYk8W76NbDVwgKuEptW7AYrEgKyb31e
	BjaUU8BN4sTURrChzAI6Evtbp0HZ8hKb17xlBhkkIdDKIdF4cjoTxEUCEt8mHwIaxAGUkJXY
	dIAZ4jVJiYMrbrBMYBSbheSmWUjGzkIydgEj8ypG0dSC5ILipPQiU73ixNzi0rx0veT83E2M
	wFg+/e/ZxB2M9w9YH2IU4GBU4uEVPBEVIsSaWFZcmXuI0RToionMUqLJ+cCEkVcSb2hsZmRh
	amJqbGRuaaYkzqsj/TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyOP0YW+Q+rGeSYsrr01
	WjWWatcnLncM7b66Y8o2nfrA5mnT5OSftVw5t8p1o0DG/vnzvk2MmsD0zffnrV3OXTk/E6Nr
	w5yi5y84seS9uxxj0ZJVYsEq3+fZHGLeeKjAb8WV5n/3GrhUAi+EeMeGMEg8W3LXOyXMoufM
	lao3xsqyIW23uAwso5VYijMSDbWYi4oTASlpQ5/gAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd0Jp6NCDHpbOCxezrzKajH/yDlW
	i/43C1ktTh1czmpx7tVKRovLu+awWcxe0s9isfT6RSaL240r2CwmTF/LYtG69wi7xb4Lf1gd
	eDzWzFvD6HG5r5fJY9fOOaweK5d/YfPYtKqTzaNvyypGj+M3tjN5fN4kF8AR1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0r5JCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY/3qrYwFH1grviw6zdLAeJqli5GTQ0LAROLG
	v/msELaYxIV769m6GLk4hAQWMUp8+tbDCOG8ZpQ4NPsFWAevgJbE8jXrwDpYBFQltky4wgRi
	swHF97+4wQZiiwqESaycfgWqXlDix+R7YLYIUE3/pW4mkKHMAtOYJN5Nv8YIkhAWcJXYtGI3
	WJEQkH3r8zKwoZwCbhInpjaCDWUW0JHY3zoNypaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxjBieKZ9A7GVQ0WhxgFOBiVeHh3HI0KEWJNLCuuzD3E
	KMHBrCTC++Y4UIg3JbGyKrUoP76oNCe1+BCjKTAIJjJLiSbnA5NYXkm8obGJmZGlkbmhhZGx
	uZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGRqOGOktrW46Z95N+7Hz+YwrDVcXbmxg/1t+b
	O6Fk+qW98981dDgF579+mKKiUPdEN82OZ8IZnSmZM7Wak1Yv6t/B5pM51cOE7+0tiWMJol7b
	33z+sDR5Z6HTzBVBTE/vqNzP63ux2rr05v5feaEf30x/+dQ58OFrO6Fk5QMVjXuWXv9Q4LT3
	ZJISS3FGoqEWc1FxIgBZBY4NKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 11/06/2014 12:29 AM, George Cherian wrote:
> This series
>         - Adds dt support to extcon-gpio driver.
> 	- Add cable name support in case of dt.
> 
> George Cherian (2):
>   extcon: gpio: Add dt support for the driver
>   extcon: gpio: Add support for using cable names
> 
>  drivers/extcon/extcon-gpio.c       | 87 +++++++++++++-------------------------
>  include/linux/extcon/extcon-gpio.h | 59 --------------------------
>  2 files changed, 29 insertions(+), 117 deletions(-)
>  delete mode 100644 include/linux/extcon/extcon-gpio.h
> 

I'm so sorry for late reply because I'm busy for other jobs.

But, I will review this patchset and test it on my board
within 3~4 days.

Best Regards,
Chanwoo Choi

