Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071AbaJCWuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:50:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60477 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbaJCWuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:50:32 -0400
Date: Fri, 03 Oct 2014 15:52:38 -0700 (PDT)
Message-Id: <20141003.155238.29455136676718598.davem@davemloft.net>
To: gang.chen.5i5j@gmail.com
Cc: f.fainelli@gmail.com, leitec@staticky.com, andrew@lunn.ch,
        netdev@vger.kernel.org, richard@nod.at, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/dsa/Kconfig: Let NET_DSA_BCM_SF2 depend on
 HAS_IOMEM
From: David Miller <davem@davemloft.net>
In-Reply-To: <542D5DAC.4010001@gmail.com>
References: <542D5DAC.4010001@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Oct 2014 15:50:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s93MofVu019263

From: Chen Gang <gang.chen.5i5j@gmail.com>
Date: Thu, 02 Oct 2014 22:14:04 +0800

> NET_DSA_BCM_SF2 need HAS_IOMEM, so depend on it, the related error (with
> allmodconfig under um):
> 
>     CC [M]  drivers/net/dsa/bcm_sf2.o
>   drivers/net/dsa/bcm_sf2.c: In function ¡bcm_sf2_sw_setup¢:
>   drivers/net/dsa/bcm_sf2.c:487:3: error: implicit declaration of function ¡iounmap¢ [-Werror=implicit-function-declaration]
>      iounmap(*base);
>      ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
