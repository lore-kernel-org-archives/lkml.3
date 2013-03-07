Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3CGACh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:02:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36661 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3CGACf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:02:35 -0500
X-AuditID: cbfee690-b7f6b6d000004563-87-5137d91a12e5
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1362609234.28137.2.camel@x61.thuisdomein>
In-reply-to: <1362609234.28137.2.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: S3C24XX: drop "select MACH_N35"
Date: Thu, 07 Mar 2013 09:02:33 +0900
Message-id: <013a01ce1ac7$11b287d0$35179770$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aurCip+GLFhybRkiPvctjLbE0YAAC6jhA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ12pm+aBBo+OMllMWneAyWLT42us
	Fpd3zWGzmHF+H5PF7cu8FotunWF2YPNoae5h8/i76gWzx+Yl9R4btz9h8vi8SS6ANYrLJiU1
	J7MstUjfLoErY07bapaCaewVk9rusjQwvmDtYuTkkBAwkTh8ZDsThC0mceHeerYuRi4OIYFl
	jBIzdt+EK7q0ewkLRGI6o8SUeXOgnL+MEi0HH7OBVLEJaEgcfv+MHcQWESiW2LznGtBYDg5m
	gWyJLa/ANggJmEmc2fcWLMwpYC6x4I4nSFhYwFLi1QqIXSwCqhJdh7czgti8ArYS1zYuZ4Ow
	BSV+TL7HAjFRXWLKlFyQMLOAvMTmNW+ZQcISQOFHf3Uh9htJzP75mx2iRERi34t3jCAHSwjc
	Y5c41b8BapWAxLfJh1ggemUlNh1ghvhWUuLgihssExglZiFZPAth8Swki2ch2bCAkWUVo2hq
	QXJBcVJ6kYlecWJucWleul5yfu4mRkikTtjBeO+A9SHGZKDtE5mlRJPzgZGeVxJvaGxsYmZi
	amJuaWpuSpqwkjiv/CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M00IcVodV7GsyPKfZ
	8mKSi6XcRs3qvxoxbzICfvyMEXd4fu6ha2R8X0P1vpqwoITK4udK+iv4dIT/RZ54pOprYCoa
	cfybQEjW5lPqy151SD81i53Ju5R11oN//3QdvpUsEzAK2OV0gnXmGgNbw+nXHs1aXSY0pSjr
	SzPjnTz9rAdzDh100ixUYinOSDTUYi4qTgQAWUkgtuoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV3Jm+aBBocnW1tMWneAyWLT42us
	Fpd3zWGzmHF+H5PF7cu8FotunWF2YPNoae5h8/i76gWzx+Yl9R4btz9h8vi8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8acttUsBdPYKya13WVpYHzB2sXIySEh
	YCJxafcSFghbTOLCvfVsXYxcHEIC0xklpsybwwLh/GWUaDn4mA2kik1AQ+Lw+2fsILaIQLHE
	5j3XmLoYOTiYBbIltrxiAgkLCZhJnNn3FizMKWAuseCOJ0hYWMBS4tWKm2B7WQRUJboOb2cE
	sXkFbCWubVzOBmELSvyYfI8FYqK6xJQpuSBhZgF5ic1r3jKDhCWAwo/+6kLsN5KY/fM3O0SJ
	iMS+F+8YJzAKzUIyaBbCoFlIBs1C0rGAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAa
	eCa9g3FVg8UhRgEORiUe3o055oFCrIllxZW5hxglOJiVRHjvLgEK8aYkVlalFuXHF5XmpBYf
	YkwGenMis5Rocj4wReWVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6YklqdmpqQWoRzBYm
	Dk6pBsb+E7bcJ/492z9XzNe9KfGgMLPrvAZL0cpPxxTnMt9bEROw16P4yoOUyLKNf/M8tzaL
	nlu2us4sQJit7kiXGqf3+5Vu7w7flypTlJWwzv3IPK8xeyHjCctD5yIFazuYs5fVeDP7OrMd
	Pv2yO/rkwawvu6KmpHPbeTH3r89acqOR50G5spGohBJLcUaioRZzUXEiAFj1+vRHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> The unused Kconfig symbol MACH_N35 was removed in commit
> 85fd6d63bf2927b9da7ab1b0d46723bfdb13808c ("ARM: S3C2410: move
> mach-s3c2410/* into mach-s3c24xx/"). But there is still one (pointless)
> select statement for that symbol. Drop it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/arm/mach-s3c24xx/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index 37f513d..7361b9d 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -320,7 +320,6 @@ config PM_H1940
> 
>  config MACH_N30
>  	bool "Acer N30 family"
> -	select MACH_N35
>  	select S3C_DEV_NAND
>  	select S3C_DEV_USB_HOST
>  	help
> --
> 1.7.11.7

Yes, right. Applied, thanks.

BTW, so the machine type can be removed at arch/arm/tools/mach-types as well.

- Kukjin

