Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaEEH5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:57:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44546 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaEEH5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:57:14 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-e5-5367445894bc
Message-id: <1399276631.15737.1.camel@AMDC1943>
Subject: Re: [PATCH 3/4] misc: exynos-chipid: Add Exynos Chipid driver support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, Arnd Bergmann <arnd@arndb.de>,
        t.figa@samsung.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 05 May 2014 09:57:11 +0200
In-reply-to: <1399097500-4052-4-git-send-email-pankaj.dubey@samsung.com>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
 <1399097500-4052-4-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xq7oRLunBBnueyVn8nXSM3aJ58Xo2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGuxaOsXdov1M16zOHB6tDT3sHn8/jWJ0WP/3DXs
	HpuX1Hv0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxrUNM1gLFrFVbH49namBcQJrFyMHh4SA
	icTy6wpdjJxAppjEhXvr2boYuTiEBJYySpxsussE4XxmlPh1fRE7SBWvgL7EkV3rmEBsYQE/
	idOzJoPF2QSMJTYvX8IGYosIaEt0Xr7HCtLMLNDEJHHpzhawBhYBVYm9p1tYQWxOAQ+J088m
	Q21oZZQ4u/kN2CRmAXWJSfMWMUPcpCwxb/8xJojNghI/Jt9jgaiRl9i85i3zBEaBWUhaZiEp
	m4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkBj4soNx8TGrQ4wCHIxKPLyBQSnB
	QqyJZcWVuYcYJTiYlUR4ZzGmBwvxpiRWVqUW5ccXleakFh9iZOLglGpgZDny8zbf7ymbdZiX
	Cv9NWy8k8/HUgowGdYlHvuYfT7zcMy9h1gzHo1tPVQSeW+g56V3f8svPnN7Lp1mp8exZrNVc
	foa/xPl5dR7HScO+a/v4zyfkGTul782MsL16vGyuYzD//m7VlNs+Sjl3KlI0dTabyUc9f7rU
	vGrF76Mf5GNWuhjVTXv4SYmlOCPRUIu5qDgRAGQB0lRfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sob, 2014-05-03 at 15:11 +0900, Pankaj Dubey wrote:
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 7eb4b69..48c8fb5 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -55,3 +55,4 @@ obj-$(CONFIG_SRAM)		+= sram.o
>  obj-y				+= mic/
>  obj-$(CONFIG_GENWQE)		+= genwqe/
>  obj-$(CONFIG_ECHO)		+= echo/
> +obj-$(CONFIG_EXYNOS_CHIPID)	+= exynos-chipid.o
> diff --git a/drivers/misc/exynos-chipid.c b/drivers/misc/exynos-chipid.c
> new file mode 100644
> index 0000000..eb23339
> --- /dev/null
> +++ b/drivers/misc/exynos-chipid.c
> @@ -0,0 +1,83 @@
> +/*
> + * Copyright (c) 2014-2015 Samsung Electronics Co., Ltd.
> + *	      http://www.samsung.com/

I wonder why this is copyrighted in the future (2015)?

Best regards,
Krzysztof


