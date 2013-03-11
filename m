Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3CKXuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:50:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9172 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3CKXuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:50:20 -0400
X-AuditID: cbfee68d-b7f786d000005188-d3-513e6dba28d1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1363034823.3137.110.camel@x61.thuisdomein>
In-reply-to: <1363034823.3137.110.camel@x61.thuisdomein>
Subject: Re: [PATCH] backlight: fix typo "MACH_SAM9...EK" three times
Date: Tue, 12 Mar 2013 08:50:18 +0900
Message-id: <008b01ce1eb3$2f8bbf70$8ea33e50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4emlrz+ka1LIIIQkatCbtJCJdJLwAGHtDQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zQ91duXaBBud/6lvMWb+GzaJz5jVG
	ixN9H1gtLu+aw2ax6NYZZovdu56yOrB5fPgY53Fixm8Wjz3zf7B6bNz+hMnj8ya5ANYoLpuU
	1JzMstQifbsErowXi6+yFuzjqfj3fjJTA+Mkri5GTg4JAROJ458esUHYYhIX7q0Hsrk4hASW
	MUr8XPqREabo2uNV7BCJ6YwS2xc9ZYRwfjFKtC3dwQ5SxSagJvHly2EwW0QgRGLrm6/MIEXM
	AvMZJV7cvskMkhASMJeYMrEXbB+ngIXE+587WUBsYQFXiV9XX4HZLAKqEpsWPQer5xWwldj5
	eAojhC0o8WPyPbAaZgF1iUnzFjFD2PISm9e8BbI5gE5Vl3j0VxfiBiOJ1nunWSFKRCT2vXgH
	drSEwEt2iUcLlrNC7BKQ+Db5EAtEr6zEpgPMEB9LShxccYNlAqPELCSbZyHZPAvJ5llIVixg
	ZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERK1vTsYbx+wPsSYDLR+IrOUaHI+MOrzSuIN
	jc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAYItvprPDu
	bdHnxem1l9RnxLmfVv33oUmRq0AvgK/OUYjrCZuImdKhmc+Cl2cdr1rFezozK/dkwq9cVm/p
	gOulRurpmgVa/9vZGjQ+hjFpBIWsb21NN0k6UfJrmuM8a9GSR2HWdS9EJH2Cc9vD1h7pzP2i
	vNhC4NLMH8ns25bwfnt4/6/zOyWW4oxEQy3mouJEAD3WoOzwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQd1duXaBBq+2aFvMWb+GzaJz5jVG
	ixN9H1gtLu+aw2ax6NYZZovdu56yOrB5fPgY53Fixm8Wjz3zf7B6bNz+hMnj8ya5ANaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZLxZfZS3Yx1Px7/1kpgbGSVxdjJwc
	EgImEtcer2KHsMUkLtxbz9bFyMUhJDCdUWL7oqeMEM4vRom2pTvAqtgE1CS+fDkMZosIhEhs
	ffOVGaSIWWA+o8SL2zeZQRJCAuYSUyb2soHYnAIWEu9/7mQBsYUFXCV+XX0FZrMIqEpsWvQc
	rJ5XwFZi5+MpjBC2oMSPyffAapgF1CUmzVvEDGHLS2xe8xbI5gA6VV3i0V9diBuMJFrvnWaF
	KBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kR
	nBKeSe9gXNVgcYhRgINRiYdX4ZttoBBrYllxZe4hRgkOZiUR3soUu0Ah3pTEyqrUovz4otKc
	1OJDjMlAj05klhJNzgemq7ySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbB
	bGHi4JRqYJyh/P+x+O7755T9dZ9lX3zYGaF/8dmDN9tum2XmvuPw/BU8I1HHrp21Uq/3n8Ch
	NW+DD+5LmzjPw2nyx6r5/jHOy7VjFT5U8SX+/O2+wP9+QunjtKYTPXOWX56+5UrSjoD726P/
	fbYukFm04omX0+WYRzLvr+//m54hbb8oePUWlXsNCgbrdRuVWIozEg21mIuKEwFr+FtGTQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 12, 2013 5:47 AM, Paul Bolle wrote:
> 
> Fix three typos (originally) introduced by commit
> a9a84c37d1ee50db8f3752b117caf2b48dcd4f8a ("atmel_lcdfb: backlight
> control").
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

CC'ed Andrew Morton.

It looks good.

Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han


> ---
> 0) Tested by grepping the tree.
> 
> 1) So two of these typos were introduced in v2.6.25. (The third was
> introduced in commit 915190f7d4f08e413e5fde6b0abcd5375aeacdf4 ("[ARM]
> 5614/1: at91: atmel_lcdfb: add at91sam9g10 support to atmel LCD
> driver")). Checking these commits reveals that the default value of 'y'
> has never been set automatically in all releases since v2.6.25! Perhaps
> this line might as well be dropped.
> 
>  drivers/video/backlight/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index db10d01..a4481df 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -161,7 +161,7 @@ if BACKLIGHT_CLASS_DEVICE
>  config BACKLIGHT_ATMEL_LCDC
>  	bool "Atmel LCDC Contrast-as-Backlight control"
>  	depends on FB_ATMEL
> -	default y if MACH_SAM9261EK || MACH_SAM9G10EK || MACH_SAM9263EK
> +	default y if MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK
>  	help
>  	  This provides a backlight control internal to the Atmel LCDC
>  	  driver.  If the LCD "contrast control" on your board is wired
> --
> 1.7.11.7
> 


