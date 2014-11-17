Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaKQLHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:07:45 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:59146 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaKQLHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:07:43 -0500
Message-ID: <1416222455.4072.0.camel@arm.com>
Subject: Re: [PATCH] video: ARM CLCD: Remove duplicated include in
 amba-clcd.c
From: Pawel Moll <pawel.moll@arm.com>
To: Qiang Chen <qiang2.chen@sonymobile.com>
Cc: "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qcwj.lk@gmail.com" <qcwj.lk@gmail.com>
Date: Mon, 17 Nov 2014 11:07:35 +0000
In-Reply-To: <1416216301-15854-1-git-send-email-qiang2.chen@sonymobile.com>
References: <1416216301-15854-1-git-send-email-qiang2.chen@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-17 at 09:25 +0000, Qiang Chen wrote:
> This patch fixes duplicated include dma-mapping.h in
> drivers/video/fbdev/amba-clcd.c
> 
> Signed-off-by: Qiang Chen <qiang2.chen@sonymobile.com>
> ---
>  drivers/video/fbdev/amba-clcd.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/video/fbdev/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
> index 6ad23bd..32c0b6b 100644
> --- a/drivers/video/fbdev/amba-clcd.c
> +++ b/drivers/video/fbdev/amba-clcd.c
> @@ -27,7 +27,6 @@
>  #include <linux/bitops.h>
>  #include <linux/clk.h>
>  #include <linux/hardirq.h>
> -#include <linux/dma-mapping.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  #include <linux/of_graph.h>

Acked-by: Pawel Moll <pawel.moll@arm.com>

Thanks!

Pawel

