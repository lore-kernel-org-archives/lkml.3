Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbaGDMyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:54:47 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:42297 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaGDMyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:54:45 -0400
Message-ID: <53B6A41D.1030000@cogentembedded.com>
Date: Fri, 04 Jul 2014 16:54:53 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: xuwei <xuwei5@hisilicon.com>, Li Zefan <lizefan@huawei.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] MAINTAINERS:ARM:hisi: add Hisilicon SoC family
References: <53B66A9F.6040404@hisilicon.com>
In-Reply-To: <53B66A9F.6040404@hisilicon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/04/2014 12:49 PM, xuwei wrote:

> Introduce a new mach-hisi that will support Hisilicon SoCs based on ARMv7
> and I am taking maintainership for it.

> Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
> ---
>   MAINTAINERS | 8 ++++++++
>   1 file changed, 8 insertions(+)

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 134483f..a4f700a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -972,6 +972,14 @@ F:	arch/arm/mach-pxa/hx4700.c
>   F:	arch/arm/mach-pxa/include/mach/hx4700.h
>   F:	sound/soc/pxa/hx4700.c
>
> +ARM/Hisilicon SoC support

    This line is traditionally written in upper case.

> +M:	Wei Xu <xuwei5@hisilicon.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +W:	www.hisilicon.com

    How about http://?

> +S:	Supported
> +T:	git git://github.com/hisilicon/linux-hisi.git
> +F:	arch/arm/mach-hisi/
> +

WBR, Sergei

