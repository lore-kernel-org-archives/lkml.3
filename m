Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaDWBUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:20:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44849 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaDWBUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:20:30 -0400
Date: Tue, 22 Apr 2014 21:20:28 -0400 (EDT)
Message-Id: <20140422.212028.793102586006580743.davem@davemloft.net>
To: zlim.lnx@gmail.com
Cc: nico@fluxnic.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smc91x: fix compile error when SMC_DEBUG >= 2
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397879250-32041-1-git-send-email-zlim.lnx@gmail.com>
References: <1397879250-32041-1-git-send-email-zlim.lnx@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 22 Apr 2014 18:20:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3N1LYiN014302

From: Zi Shen Lim <zlim.lnx@gmail.com>
Date: Fri, 18 Apr 2014 20:47:30 -0700

> When SMC_DEBUG >= 2, we hit the following compilation error:
> 
> drivers/net/ethernet/smsc/smc91x.c:85:0:
> drivers/net/ethernet/smsc/smc91x.c: In function ¡smc_findirq¢:
> drivers/net/ethernet/smsc/smc91x.c:1784:9: error: ¡dev¢ undeclared (first use in this function)
>   DBG(2, dev, "%s: %s\n", CARDNAME, __func__);
>          ^
> Fix it by passing in the appropriate netdev pointer.
> 
> Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>

Applied, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
