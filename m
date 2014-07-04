Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaGDHcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:32:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26290 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaGDHcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:32:01 -0400
Message-ID: <53B6581C.4060001@huawei.com>
Date: Fri, 4 Jul 2014 15:30:36 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: xuwei <xuwei5@hisilicon.com>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS:ARM:hisi: add Hisilicon SoC family
References: <53B65397.40108@hisilicon.com>
In-Reply-To: <53B65397.40108@hisilicon.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/4 15:11, xuwei wrote:
> 
> Introduce a new mach-hisi that will support Hisilicon SoCs based on ARMv7
> and I am taking maintainership for it.
> 
> Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 134483f..c11c89b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -972,6 +972,14 @@ F:	arch/arm/mach-pxa/hx4700.c
>  F:	arch/arm/mach-pxa/include/mach/hx4700.h
>  F:	sound/soc/pxa/hx4700.c
>  
> +ARM/Hisilicon SoC support
> +M:	Wei Xu <xuwei5@hisilicon.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +W:	www.hisilicon.com
> +S:	Maintained

S:	Supported ?

Supported:   Someone is actually paid to look after this.
Maintained:  Someone actually looks after it.

> +T:	git git://github.com/hisilicon/linux-hisi.git
> +F:	arch/arm/mach-hisi/
> +
>  ARM/HP JORNADA 7XX MACHINE SUPPORT
>  M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
>  W:	www.jlime.com
> 

