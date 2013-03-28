Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3C1Vkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:40:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46134 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3C1Vkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:40:41 -0400
Date: Thu, 28 Mar 2013 17:40:39 -0400 (EDT)
Message-Id: <20130328.174039.1409554953798783786.davem@davemloft.net>
To: alex.mihai.c@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, honkiko@gmail.com,
        tgraf@suug.ch
Subject: Re: [PATCH net-next] audit: pass int* to nlmsg_next
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364506289-9146-1-git-send-email-alex.mihai.c@gmail.com>
References: <1364506289-9146-1-git-send-email-alex.mihai.c@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 28 Mar 2013 14:40:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2SLeoeF024713

From: Alexandru Copot <alex.mihai.c@gmail.com>
Date: Thu, 28 Mar 2013 23:31:29 +0200

> Commit 941912133025926307c7a65b203fa38403b1063a replaced the macros
> NLMSG_NEXT with calls to nlmsg_next which produces this warning:
> 
> kernel/audit.c: In function ¡audit_receive_skb¢:
> kernel/audit.c:928:3: warning: passing argument 2 of ¡nlmsg_next¢ makes pointer from integer without a cast
> In file included from include/net/rtnetlink.h:5:0,
>                  from include/net/neighbour.h:28,
>                  from include/net/dst.h:17,
>                  from include/net/sock.h:68,
>                  from kernel/audit.c:55:
> include/net/netlink.h:359:1: note: expected ¡int *¢ but argument is of type ¡int¢
> 
> Fix this by sending the intended pointer.
> 
> Signed-off-by: Alexandru Copot <alex.mihai.c@gmail.com>

Applied, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
