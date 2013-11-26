Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3KZHz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:55:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43645 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3KZHzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:55:55 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-d7-52945409951f
Message-id: <52945409.5040502@samsung.com>
Date: Tue, 26 Nov 2013 16:55:53 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: gpio: Request gpio pin before modifying its state
References: <1385141161-7785-1-git-send-email-linux@roeck-us.net>
In-reply-to: <1385141161-7785-1-git-send-email-linux@roeck-us.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWyRsSkWJczZEqQQe9TI4vLu+awWTxZeIbJ
	4nbjCjYHZo+d3xvYPfq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvjaMN99oKDbBU/W9czNjAu
	Ze1i5OSQEDCReL5kIyOELSZx4d56ti5GLg4hgaWMEh0XF7B0MXKAFW2e6wcRn84o0dm+kx3C
	ecUo0TZxOzNIN6+AlsT6r0uYQGwWAVWJSYteg9lsQPH9L26wgdiiAmESK6dfYYGoF5T4Mfke
	mC0ioCbRfKoFrIZZwFPi9K0usJnCAn4SXf/+sYIcISTgKLH8USqIySngJLGyKQCiWkdif+s0
	qE55ic1r3jKDnCYhMI9d4svlbywQ5whIfJt8COoXWYlNB5gh/pWUOLjiBssERrFZSA6ahWTs
	LCRjFzAyr2IUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIjJvT/5717mC8fcD6EGMy0MqJzFKi
	yfnAuMsriTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BsZMt+ATVjWbRFM+Kr98FqXJFrjgWtDmBhlh9ayZG1neer9wkSlPqrLrPl948XBG6P5Cqzkd
	qszVrHnt/W6q57isF6Y88df7ve9d8JySOXGxpY6b2/Y4TFvNk3FTxiSmw7Cig2++wqut6k1e
	TDPlp66YFPaq4OKDWYbXWDne9E86s/NkFx9zgRJLcUaioRZzUXEiAKMA9C2xAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQV3OkClBBh1TdCwu75rDZvFk4Rkm
	i9uNK9gcmD12fm9g9+jbsorR4/MmuQDmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwhrGjKMN99kLDrJV/Gxdz9jAuJS1i5GDQ0LARGLzXL8uRk4gU0ziwr31bF2MXBxCAtMZ
	JTrbd7JDOK8YJdombmcGqeIV0JJY/3UJE4jNIqAqMWnRazCbDSi+/8UNNhBbVCBMYuX0KywQ
	9YISPybfA7NFBNQkmk+1gNUwC3hKnL7VBTZTWMBPouvfP7CDhAQcJZY/SgUxOQWcJFY2BUBU
	60jsb50G1SkvsXnNW+YJjAKzkCyYhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGCo/KZ1A7GlQ0WhxgFOBiVeHglOicHCbEmlhVX5h5ilOBgVhLhdb0PFOJNSaysSi3Kjy8q
	zUktPsSYDPT/RGYp0eR8YMLIK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFq
	EcwWJg5OqQbGRTXiOzNY9VXNm/P/TfDKvpl40dNp0oP0yaKv+B5NeekYOW9HU9IahtaDOu/4
	gy/MP9fSWLLuYKr6ja6tnPWPq1gPXHuW4Fq4RPZyT+Wq566RDz1+e+1j2jRz1b4oEYc1Kzrt
	n9wKK7/8YPYm+x0mcgLWnusC75rqbPi2Lqi4dpbndP2XPZO+KrEUZyQaajEXFScCAB6yIYwO	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On 11/23/2013 02:26 AM, Guenter Roeck wrote:
> Commit 338de0ca (extcon: gpio: Use gpio driver/chip debounce if supported)
> introduced a call to gpio_set_debounce() before actually requesting the
> respective gpio pin from the gpio subsystem.
> 
> The gpio subsystem expects that a gpio pin was requested before modifying its
> state. Not doing so results in a warning from gpiolib, and the gpio pin is
> auto-requested. This in turn causes the subsequent devm_gpio_request_one()
> to fail. So devm_gpio_request_one() must be called prior to calling
> gpio_set_debounce().
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/extcon/extcon-gpio.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 

Applid it on extcon-next branch.

Thanks,
Chanwoo Choi

