Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3CKBfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 21:35:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41905 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3CKBfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 21:35:45 -0400
X-AuditID: cbfee68d-b7f786d000005188-fe-513d34f09f23
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Jiri Slaby'" <jslaby@suse.cz>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1362867404.3137.44.camel@x61.thuisdomein>
In-reply-to: <1362867404.3137.44.camel@x61.thuisdomein>
Subject: RE: [PATCH] tty: serial: fix typo "ARCH_S5P6450"
Date: Mon, 11 Mar 2013 10:35:43 +0900
Message-id: <04f801ce1df8$bf644ec0$3e2cec40$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4dE8qKFDeObznERCSmnEUOrXegnAA5OCqg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ90PJraBBju/81tc3jWHzeLM4l52
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKWvWljL7jBXvHnwwH2BsaZbF2MnBwSAiYS99e9ZoWw
	xSQu3FsPFOfiEBJYxihx9MkDFpiiRwd/sEIkFjFKPOr8zQzh/GWUmH2rmQmkik1AQ+Lw+2fs
	ILaIQLXEgm2TGEFsZoFkiQ0n+5lBbCEBM4lTaxeD1XAKmEu0vvgFdoawgKXE20PbwM5gEVCV
	2DBzL1icV8BWYt3hr0wQtqDEj8n3gC7iAJqpLjFlSi7EeHmJzWveMoOEJYDCj/7qgpgiAkYS
	T5eoQ1SISOx78Y4R5GIJgVXsEsu/djFCbBKQ+Db5EAtEq6zEpgPMEO9KShxccYNlAqPELCR7
	ZyHsnYVk7ywkGxYwsqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECImv3h2Mtw9YH2JMBto+
	kVlKNDkfGJ95JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamAsNY3ODXkxg+XVS2GnnlvRB0+vXPfQ9NjHbW8eJa4QZ7iywCDm4fqEc213ZaYnJvld
	MLYM8TvToyNXUfpv/a+Tl7R+lMsl9QpvWM67eeq3c4fdLk39detMtJ/APM/5CjJaq5oUVXbt
	Stzoc7iI42anyuc3bHffZ+bX/HwhvWXSrZNqG62nLNu1XomlOCPRUIu5qDgRAJ0Jfs7FAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgO4HE9tAgxn3eSwu75rDZnFmcS+7
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZy960sRfcYK/4
	8+EAewPjTLYuRk4OCQETiUcHf7BC2GISF+6tB4pzcQgJLGKUeNT5mxnC+csoMftWMxNIFZuA
	hsTh98/YQWwRgWqJBdsmMYLYzALJEhtO9jOD2EICZhKn1i4Gq+EUMJdoffELbJuwgKXE20Pb
	wLaxCKhKbJi5FyzOK2Arse7wVyYIW1Dix+R7LF2MHEAz1SWmTMmFGC8vsXnNW2aQsARQ+NFf
	XRBTRMBI4ukSdYgKEYl9L94xTmAUmoVkziyEObOQzJmFpGMBI8sqRtHUguSC4qT0XEO94sTc
	4tK8dL3k/NxNjODofSa1g3Flg8UhRgEORiUe3gk6toFCrIllxZW5hxglOJiVRHhXbrIJFOJN
	SaysSi3Kjy8qzUktPsSYDPTlRGYp0eR8YGLJK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBA
	emJJanZqakFqEcwWJg5OqQZGF/Hs4r5yi3fs8SsvRC/gnSZ8+/uEiPD1Nc95drJaL5trIq28
	eWnmj+tWFoveaz5x8Vac/XPyvicfH9a/99PSOuxit/ti85zPCpfsxbZLnOsXL/ukfW/+aw9W
	0eOTXxXWvDk39fpOI/83XLvfbDBrjw15ySr4qKMxrjHDQWenobJZYYfReutFSizFGYmGWsxF
	xYkAxri0kiIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> This could have been either ARCH_S5P64X0 or CPU_S5P6450. Looking at
> commit 2555e663b367b8d555e76023f4de3f6338c28d6c ("ARM: S5P64X0: Add UART
> serial support for S5P6450") - which added this typo - makes clear this
> should be CPU_S5P6450.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

> ---
> Bravely untested.
> 
>  drivers/tty/serial/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index cf9210d..40ddbe4 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -218,7 +218,7 @@ config SERIAL_SAMSUNG_UARTS_4
>  config SERIAL_SAMSUNG_UARTS
>  	int
>  	depends on PLAT_SAMSUNG
> -	default 6 if ARCH_S5P6450
> +	default 6 if CPU_S5P6450
>  	default 4 if SERIAL_SAMSUNG_UARTS_4 || CPU_S3C2416
>  	default 3
>  	help
> --
> 1.7.11.7

