Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3A2GUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:20:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28378 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3A2GUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:20:21 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-ad-51076a243591
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>
References: <CAK9yfHybC6ZgGwxa_i=LrMpU_q9M4aaMraTqK63B+fw11NBqRA@mail.gmail.com>
In-reply-to: <CAK9yfHybC6ZgGwxa_i=LrMpU_q9M4aaMraTqK63B+fw11NBqRA@mail.gmail.com>
Subject: RE: Failure due to missing (Exynos related) pinctrl patch
Date: Mon, 28 Jan 2013 22:20:15 -0800
Message-id: <05ed01cdfde8$b529fc00$1f7df400$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIQEhSOcfF2dxL6YkpdblpHwBx89JfbrGxQ
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zfV2VLPZAgxVN7BaXd81hs5hxfh+T
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlvF+xiKfjLXXFs936WBsYpXF2MnBwSAiYSd24vYIew
	xSQu3FvP1sXIxSEksIxRYu2ynYxdjBxgRW9aJSDi0xkl1j/5wgjh/GWUuHZtLyNIN5uAhsTh
	98/AJokIREl8ampkAbGZBVIk3mz7yQZiCwkESHxauZIJxOYUCJZ4sfsJK4gtLOAksevlE7A5
	LAKqEp3bF4PV8ApYSvy+c54RwhaU+DH5HtRMLYn1O48zQdjyEpvXvGWG+EBBYsfZ14wQNxhJ
	fPp2khWiRlxi0oOH7CBHSwisY5f4d/U/M8QyAYlvkw+xQHwpK7HpANQcSYmDK26wTGCUmIVk
	9Swkq2chWT0LyYoFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MUKiTGoH48oGi0OMAhyM
	Sjy8DQvYAoVYE8uKK3MPMUpwMCuJ8L4TZw8U4k1JrKxKLcqPLyrNSS0+xJgMdOxEZinR5Hxg
	AsgriTc0NjYxMzE1Mbc0NTclTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxSDYzcac86FTLe
	/5bbdDbo8/5bH02PlUt9/velsWrak7Bv7k63n2z8aKP+zjf476o0dkHGEMt9OQ9Xzd6Sy3HI
	eIu/GU+zusoZxd+W8yfE5jGcsJss1tC8I+/HR8WoKIupsVLxP86d29R8eEtptpnXcz3WpE9y
	OcnaF69rGmycpLAy8pGbiJTGrCdKLMUZiYZazEXFiQC/quN+9gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQV2VLPZAg5ULmS0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz3i7YxVLwl7vi
	2O79LA2MU7i6GDk4JARMJN60SnQxcgKZYhIX7q1n62Lk4hASmM4osf7JF0YI5y+jxLVrexlB
	qtgENCQOv3/GDmKLCERJfGpqZAGxmQVSJN5s+8kGYgsJBEh8WrmSCcTmFAiWeLH7CSuILSzg
	JLHr5ROwOSwCqhKd2xeD1fAKWEr8vnOeEcIWlPgx+R7UTC2J9TuPM0HY8hKb17xlhrhUQWLH
	2deMEDcYSXz6dpIVokZcYtKDh+wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5x
	Ym5xaV66XnJ+7iZGcAw/k9rBuLLB4hCjAAejEg9vwwK2QCHWxLLiytxDjBIczEoivO/E2QOF
	eFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YXvJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRA
	SCA9sSQ1OzW1ILUIZgsTB6dUA2PPnaPl9/fYfWU3L7y0WOb0dePUbxZHXq6b0TLDUi9Wfce7
	DYY7U/qjKt+EGQtuPWVbtlkquCR7fUPQE/8HK+/46mtUOMnv3xX/3WtqYLOw4upVRx+3nb+T
	dNgsRiFger/TihuXdb8IsW0q/joxwHPCOu/ZFxOTEpaempq/z1iwNHhPmNCU6NNKLMUZiYZa
	zEXFiQBvJmm3JQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Kamat wrote:
> 
> Hi Linus, Kukjin,
> 
> Patch titled "pinctrl: exynos: change PINCTRL_EXYNOS option"
> (linux-next commit Id: 7452b64d) which is present in linux-next is
> missing in the mainline kernel. This patch is required along with the
> patch "gpio: samsung: fix pinctrl condition for exynos and exynos5440"
> (mainline commit Id: e4a5da51) which has already made it into
> mainline. Without the missing patch we get the following boot up
> warnings and subsequent failures with dt boot on 4412 based board:
> 
>  WARNING: at drivers/gpio/gpio-samsung.c:3102
> samsung_gpiolib_init+0x29c/0x2e8()
>  Unknown SoC in gpio-samsung, no GPIOs added
>  Modules linked in:
>  [<c00142dc>] (unwind_backtrace+0x0/0xf8) from [<c00202bc>]
> (warn_slowpath_common+0x4c/0x64)
>  [<c00202bc>] (warn_slowpath_common+0x4c/0x64) from [<c0020368>]
> (warn_slowpath_fmt+0x30/0x40)
>  [<c0020368>] (warn_slowpath_fmt+0x30/0x40) from [<c028b924>]
> (samsung_gpiolib_init+0x29c/0x2e8)
>  [<c028b924>] (samsung_gpiolib_init+0x29c/0x2e8) from [<c000862c>]
> (do_one_initcall+0x34/0x174)
>  [<c000862c>] (do_one_initcall+0x34/0x174) from [<c0275960>]
> (kernel_init_freeable+0xfc/0x1c8)
>  [<c0275960>] (kernel_init_freeable+0xfc/0x1c8) from [<c01c0a5c>]
> (kernel_init+0x8/0xe4)
>  [<c01c0a5c>] (kernel_init+0x8/0xe4) from [<c000e158>]
> (ret_from_fork+0x14/0x3c)
> 
Sachin, thanks for your information.

Linus, can you check following again?

https://lkml.org/lkml/2013/1/18/461

Thanks.

- Kukjin


