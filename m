Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaEBT4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:56:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37011 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaEBT4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:56:37 -0400
Date: Fri, 02 May 2014 15:56:35 -0400 (EDT)
Message-Id: <20140502.155635.1691085402453175737.davem@davemloft.net>
To: alchark@gmail.com
Cc: rl@hellgate.ch, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David.Laight@ACULAB.COM, mq@suse.cz
Subject: Re: [PATCH] net: via-rhine: Drop revision property, use quirks
 instead
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398882069-28872-1-git-send-email-alchark@gmail.com>
References: <1398859589-22346-1-git-send-email-alchark@gmail.com>
	<1398882069-28872-1-git-send-email-alchark@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 May 2014 12:56:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s42JuiKH023485

From: Alexey Charkov <alchark@gmail.com>
Date: Wed, 30 Apr 2014 22:21:09 +0400

> This adds two new flags to quirks and thus removes the need to carry
> revision in rhine_private. As a result, the init logic is simplified
> a bit.
> 
> This also fixes a compiler warning in OF code on 64bit due to pointer
> casting:
> 
>         drivers/net/ethernet/via/via-rhine.c: In function ¡rhine_init_one_platform¢:
>         drivers/net/ethernet/via/via-rhine.c:1132:13: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>           revision = (u32)match->data;
>                      ^
> 
> That code was added in commit 2d283862dc62daead9db0dc89cd0d0351e91f765
> ("net: via-rhine: add OF bus binding").
> 
> Tested in platform configuration on a VIA WM8950 APC Rock board.
> 
> Reported-by: Jan Moskyto Matejka <mq@suse.cz>
> Signed-off-by: Alexey Charkov <alchark@gmail.com>

This looks a lot better, applied, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
