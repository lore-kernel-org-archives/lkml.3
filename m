Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaJSCtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 22:49:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50469 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaJSCtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 22:49:04 -0400
Date: Sat, 18 Oct 2014 22:48:59 -0400 (EDT)
Message-Id: <20141018.224859.1970689329257045675.davem@davemloft.net>
To: markus@trippelsdorf.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141019021554.GD22068@x4>
References: <20141018.001844.1317443518545745039.davem@davemloft.net>
	<20141019021554.GD22068@x4>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Oct 2014 19:49:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9J2nbWh017934

From: Markus Trippelsdorf <markus@trippelsdorf.de>
Date: Sun, 19 Oct 2014 04:15:54 +0200

> On 2014.10.18 at 00:18 -0400, David Miller wrote:
>> 
>> Please pull, thanks a lot.
> 
> In file included from net/core/sock.c:140:0:
> include/net/tcp.h: In function ¡tcp_v6_iif¢:
> include/net/tcp.h:738:32: error: ¡union <anonymous>¢ has no member named ¡h6¢
>   return TCP_SKB_CB(skb)->header.h6.iif;

Already fixed in the 'net' tree.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
