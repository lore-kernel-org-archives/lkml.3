Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaJ0Wx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:53:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51611 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaJ0Wx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:53:57 -0400
Date: Mon, 27 Oct 2014 18:53:55 -0400 (EDT)
Message-Id: <20141027.185355.1412632964802440855.davem@davemloft.net>
To: robertoxmed@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: realtek: atp: checkpatch errors and
 warnings corrected
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141027.185211.1433818002293610983.davem@davemloft.net>
References: <1414084200-5377-1-git-send-email-robertoxmed@gmail.com>
	<20141027.185211.1433818002293610983.davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 15:53:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9RMs4Zq012573

From: David Miller <davem@davemloft.net>
Date: Mon, 27 Oct 2014 18:52:11 -0400 (EDT)

> From: Roberto Medina <robertoxmed@gmail.com>
> Date: Thu, 23 Oct 2014 19:10:00 +0200
> 
>> From: Roberto Medina <robertoxmed@gmail.com>
>> 
>> Several warnings and errors of coding style errors corrected.
>> 
>> Signed-off-by: Roberto Medina <robertoxmed@gmail.com>
> 
> Applied, thanks.

Wait, are you serious, you didn't even compile test this change?

For real?

In file included from drivers/net/ethernet/realtek/atp.c:146:0:
drivers/net/ethernet/realtek/atp.h:79:15: error: expected ¡;¢, identifier or ¡(¢ before ¡unsigned¢
 static inline unsigned char inbyte(unsigned short port)
               ^
drivers/net/ethernet/realtek/atp.h:79:15: error: ¡inline¢ in empty declaration

Don't even submit changes meant for inclusion if you're not even
willing to build test them.

And I'm very serious about this.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
