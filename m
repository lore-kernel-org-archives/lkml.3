Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbaJCWun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:50:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60484 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073AbaJCWuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:50:37 -0400
Date: Fri, 03 Oct 2014 15:52:44 -0700 (PDT)
Message-Id: <20141003.155244.867395296880140918.davem@davemloft.net>
To: gang.chen.5i5j@gmail.com
Cc: antoine.tenart@free-electrons.com, arnd@arndb.de, jason@lakedaemon.net,
        richard@nod.at, mw@semihalf.com, thomas.petazzoni@free-electrons.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ethernet/marvell/Kconfig: Let PXA168_ETH
 depend on HAS_IOMEM
From: David Miller <davem@davemloft.net>
In-Reply-To: <542D5FE5.2040400@gmail.com>
References: <542D5FE5.2040400@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Oct 2014 15:50:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s93MomOQ019267

From: Chen Gang <gang.chen.5i5j@gmail.com>
Date: Thu, 02 Oct 2014 22:23:33 +0800

> PXA168_ETH need HAS_IOMEM, so depend on it, the related error (with
> allmodconfig under um):
> 
>     CC [M]  drivers/net/ethernet/marvell/pxa168_eth.o
>   drivers/net/ethernet/marvell/pxa168_eth.c: In function ¡pxa168_eth_probe¢:
>   drivers/net/ethernet/marvell/pxa168_eth.c:1605:2: error: implicit declaration of function ¡iounmap¢ [-Werror=implicit-function-declaration]
>     iounmap(pep->base);
>     ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
