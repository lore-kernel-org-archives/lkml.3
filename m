Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaGMODB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:03:01 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53866 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaGMOCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:02:52 -0400
X-Auth-Info: uwQ7dGQbw2Z3uiYcdMxTT93NVPkY4YTPQGJQmdZOunc=
From: Marek Vasut <marex@denx.de>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH] drivers/staging/iio/adc/Kconfig: Let MXS_LRADC depend on HAS_IOMEM
Date: Sun, 13 Jul 2014 15:27:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: jic23@kernel.org, Richard Weinberger <richard@nod.at>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, lars@metafoo.de,
        knaack.h@gmx.de, rdunlap@infradead.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <53C27126.50208@gmail.com>
In-Reply-To: <53C27126.50208@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407131527.38792.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 13, 2014 at 01:44:38 PM, Chen Gang wrote:
> MXS_LRADC need HAS_IOMEM, so let it depend on HAS_IOMEM
> 
> The related error (with allmodconfig under score):
> 
>     MODPOST 1365 modules
>   ERROR: "devm_ioremap_resource" [drivers/staging/iio/adc/mxs-lradc.ko]
> undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
