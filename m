Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbaJCWuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:50:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60489 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090AbaJCWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:50:42 -0400
Date: Fri, 03 Oct 2014 15:52:49 -0700 (PDT)
Message-Id: <20141003.155249.1949814662829849172.davem@davemloft.net>
To: gang.chen.5i5j@gmail.com
Cc: samuel@sortiz.org, richard@nod.at, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/irda/Kconfig: Let SH_IRDA depend on
 HAS_IOMEM
From: David Miller <davem@davemloft.net>
In-Reply-To: <542D6218.3040609@gmail.com>
References: <542D6218.3040609@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Oct 2014 15:50:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s93Moscv019271

From: Chen Gang <gang.chen.5i5j@gmail.com>
Date: Thu, 02 Oct 2014 22:32:56 +0800

> SH_IRDA needs HAS_IOMEM, so depend on it. The related error(with
> allmodconfig under um):
> 
>     CC [M]  drivers/net/irda/sh_irda.o
>   drivers/net/irda/sh_irda.c: In function ¡sh_irda_probe¢:
>   drivers/net/irda/sh_irda.c:776:2: error: implicit declaration of function ¡ioremap_nocache¢ [-Werror=implicit-function-declaration]
>     self->membase = ioremap_nocache(res->start, resource_size(res));
>     ^
>   drivers/net/irda/sh_irda.c:776:16: warning: assignment makes pointer from integer without a cast [enabled by default]
>     self->membase = ioremap_nocache(res->start, resource_size(res));
>                   ^
>   drivers/net/irda/sh_irda.c:821:2: error: implicit declaration of function ¡iounmap¢ [-Werror=implicit-function-declaration]
>     iounmap(self->membase);
>     ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
