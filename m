Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaDYIy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:54:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45597 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaDYIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:54:55 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-a9-535a22ddf3af
From: Jingoo Han <jg1.han@samsung.com>
To: "'Peter Griffin'" <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Milo Kim'" <milo.kim@ti.com>, "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
 <1398342509-10243-10-git-send-email-peter.griffin@linaro.org>
In-reply-to: <1398342509-10243-10-git-send-email-peter.griffin@linaro.org>
Subject: Re: [PATCH 09/13] video/backlight: LP8788 needs PWM
Date: Fri, 25 Apr 2014 17:54:53 +0900
Message-id: <000601cf6064$061e5140$125af3c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9fuehrFSv8VPDzTLWqcJuPw5fQxwAqgR1A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zse5dpahgg3/3FCz+TjrGbnF050Qm
	i8sLL7Fa3P96lNHi/aFnzBYn+j6wWlzeNYfNYvmvdSwWG2b8Y7FY9/AFk8X6+bfYHLg9fv+a
	xOixc9Zddo9XF+6weNy5tofN4/a/x8wefVtWMXocv7GdyePzJrkAjigum5TUnMyy1CJ9uwSu
	jBub37IX7OauuN+f3sC4nbOLkZNDQsBE4vaKVewQtpjEhXvr2boYuTiEBJYxSrx50gmU4AAr
	+nFIFiI+nVHi8rz3bCANQgK/GSW2HdMGsdkE1CS+fDkMNkhEwEfi9sTpYDazwHUmiXU3aiGa
	Oxgl5u1ZywKS4BTwkth2+AoziC0sYCNxd+cEsAYWAVWJJYs/sYLYvAK2EgtnfGSCsAUlfky+
	xwIxVEti/c7jTBC2vMTmNW+ZIQ5Vl3j0VxfiBiOJLRf3Q5WLSOx78Y4R5AYJgbkcEgvnnmGF
	2CUg8W3yIRaIXlmJTQeYIQEhKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6
	kZFecWJucWleul5yfu4mRkgC6NvBePOA9SHGZKD1E5mlRJPzgQkkryTe0NjMyMLUxNTYyNzS
	jDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwrtu82Gv107oJunf9bi0/Llgz
	l9f0StrinBMTDY1CdrY9PRPUe6Y6T95L4lGFxLnmm4s3/CkoLOFZK3qFdWt4vcehNi/XCof4
	P1YNar8Xsudc07361y22sfP09DTF2Xe1P118+f+zxKcGj6lKR1uVWUXlJG//V/QoqXtacGRb
	6r/LrNkPTupMUWIpzkg01GIuKk4EAI/ntQkWAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jQd27SlHBBos/S1v8nXSM3eLozolM
	FpcXXmK1uP/1KKPF+0PPmC1O9H1gtbi8aw6bxfJf61gsNsz4x2Kx7uELJov182+xOXB7/P41
	idFj56y77B6vLtxh8bhzbQ+bx+1/j5k9+rasYvQ4fmM7k8fnTXIBHFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QKcqKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDNubH7LXrCbu+J+f3oD43bOLkYODgkBE4kfh2S7GDmB
	TDGJC/fWs3UxcnEICUxnlLg87z0bSEJI4DejxLZj2iA2m4CaxJcvh9lBbBEBH4nbE6eD2cwC
	15kk1t2ohWjuYJSYt2ctC0iCU8BLYtvhK8wgtrCAjcTdnRPAGlgEVCWWLP7ECmLzCthKLJzx
	kQnCFpT4MfkeC8RQLYn1O48zQdjyEpvXvGWGOFpd4tFfXYgbjCS2XNwPVS4ise/FO8YJjEKz
	kEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOL08k97BuKrB4hCj
	AAejEg/vBNnIYCHWxLLiytxDjBIczEoivDMkooKFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0
	OR+Y+vJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgXHqqtYF
	r7KbFkzhmHgn9p+4W/iruNPLFwuybHxyoVFJntE0P3muxssVPmtWq8iH8tmkssakZxz7nrts
	QQOr+dwj2Y0b20qNS3z3nDO63qa/z/T8+//pF7gXfT8qVpTattCX9VuNiAnzz965BtoMzxnj
	/mzw++Nq+W/uFJXooGwX5/CkuPXyxkosxRmJhlrMRcWJAGfp57JzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 24, 2014 9:28 PM, Peter Griffin wrote:
> 
> The LP8788 driver cannot be successfully built if we don't
> enable the PWM subsystem. This patch makes that dependency
> explicit in Kconfig and prevents broken randconfig builds.
> 
> Based on Arnd Bergmann patch but split out into seperate
> commits per driver based on feedback.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Cc: Milo Kim <milo.kim@ti.com>
> Cc: Jingoo Han <jg1.han@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/backlight/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 4791af7..ac6bc28 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -393,7 +393,7 @@ config BACKLIGHT_LP855X
> 
>  config BACKLIGHT_LP8788
>  	tristate "Backlight driver for TI LP8788 MFD"
> -	depends on BACKLIGHT_CLASS_DEVICE && MFD_LP8788
> +	depends on BACKLIGHT_CLASS_DEVICE && MFD_LP8788 && PWM
>  	help
>  	  This supports TI LP8788 backlight driver.
> 
> --
> 1.7.9.5

