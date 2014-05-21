Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaEUHEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:04:25 -0400
Received: from mx10.pku.edu.cn ([162.105.129.173]:60075 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751073AbaEUHEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:04:24 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.331
Date: Wed, 21 May 2014 15:04:12 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: sunzc522@gmail.com
Cc: linux-kernel@vger.kernel.org, gxt@mprc.pku.edu.cn,
        gang chen 5i5j <gang.chen.5i5j@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-fbdev@vger.kernel.org
Message-ID: <498531946.39988.1400655852161.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <1400652811-5206-1-git-send-email-sunzc522@gmail.com>
Subject: =?gbk?B?UmU6IFtQQVRDSF0gZHJpdmVycy92aWRlby9mYmRldi9mYi1wdXYzLmM6IEFkZCBoZWFkZXIgZmlsZXMgZm9yDQogZnVuY3Rpb24gdW5pZmJfbW1hcA==?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- sunzc522@gmail.com 写道：
> From: Zhichuang SUN <sunzc522@gmail.com>
> 
> Function unifb_mmap calls functions which are defined in linux/mm.h
> and asm/pgtable.h
> 
> The related error (for unicore32 with unicore32_defconfig):
> 	CC      drivers/video/fbdev/fb-puv3.o
> 	drivers/video/fbdev/fb-puv3.c: In function 'unifb_mmap':
> 	drivers/video/fbdev/fb-puv3.c:646: error: implicit declaration of
> 				      function 'vm_iomap_memory'
> 	drivers/video/fbdev/fb-puv3.c:646: error: implicit declaration of
> 				      function 'pgprot_noncached'
> 
> Signed-off-by: Zhichuang Sun <sunzc522@gmail.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Joe Perches <joe@perches.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/fbdev/fb-puv3.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/fbdev/fb-puv3.c b/drivers/video/fbdev/fb-puv3.c
> index 6db9ebd..88fa2e7 100644
> --- a/drivers/video/fbdev/fb-puv3.c
> +++ b/drivers/video/fbdev/fb-puv3.c
> @@ -18,8 +18,10 @@
>  #include <linux/fb.h>
>  #include <linux/init.h>
>  #include <linux/console.h>
> +#include <linux/mm.h>
>  
>  #include <asm/sizes.h>
> +#include <asm/pgtable.h>
>  #include <mach/hardware.h>
>  
>  /* Platform_data reserved for unifb registers. */
> -- 
> 1.7.0.4
> 

