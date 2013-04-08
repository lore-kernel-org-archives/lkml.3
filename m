Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935529Ab3DHRDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:03:52 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50808 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935207Ab3DHRDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:03:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130408012253.GA2545@cbz-workstation>
References: <20130408012253.GA2545@cbz-workstation>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 8 Apr 2013 10:03:30 -0700
Message-ID: <CAAVeFuLrgTGoSU+OG2RWEVorcCSREG10hTMSAafNMZdFdG7APw@mail.gmail.com>
Subject: Re: [PATCH] gpio: update gpio Chinese documentation
To: Chen Baozi <baozich@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r38H3txr028951

2013/4/7 Chen Baozi <baozich@gmail.com>:
> Since the GENERIC_GPIO has been removed and the documentation of it
> has been modified, this patch updates the corresponding documentation of
> gpio in Chinese.
>
> Signed-off-by: Chen Baozi <baozich@gmail.com>
> ---
>  Documentation/zh_CN/gpio.txt | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

Integrated into my series, thanks. With this I guess I can send the
whole series again to Grant for him to integrate in his branch. It's
time if we want it to make it for 3.10.

Alex.


>
> diff --git a/Documentation/zh_CN/gpio.txt b/Documentation/zh_CN/gpio.txt
> index 4fa7b4e..d5b8f01 100644
> --- a/Documentation/zh_CN/gpio.txt
> +++ b/Documentation/zh_CN/gpio.txt
> @@ -84,10 +84,10 @@ GPIO 公约
>  控制器的抽象函数来实现它。(有一些可选的代码能支持这种策略的实现,本文档
>  后面会介绍，但作为 GPIO 接口的客户端驱动程序必须与它的实现无关。)
>
> -也就是说,如果在他们的平台上支持这个公约，驱动应尽可能的使用它。平台
> -必须在 Kconfig 中声明对 GENERIC_GPIO的支持 (布尔型 true)，并提供
> -一个 <asm/gpio.h> 文件。那些调用标准 GPIO 函数的驱动应该在 Kconfig
> -入口中声明依赖GENERIC_GPIO。当驱动包含文件:
> +也就是说,如果在他们的平台上支持这个公约，驱动应尽可能的使用它。同时，平台
> +必须在 Kconfig 中选择 ARCH_REQUIRE_GPIOLIB 或者 ARCH_WANT_OPTIONAL_GPIOLIB
> +选项。那些调用标准 GPIO 函数的驱动应该在 Kconfig 入口中声明依赖GENERIC_GPIO。
> +当驱动包含文件:
>
>         #include <linux/gpio.h>
>
> --
> 1.8.1.4
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
