Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaLOQt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:49:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43661 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaLOQtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:49:25 -0500
Date: Mon, 15 Dec 2014 11:49:23 -0500 (EST)
Message-Id: <20141215.114923.1022314440021305631.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: viro@zeniv.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rds: Fix min() warning in
 rds_message_inc_copy_to_user()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418646102-32415-1-git-send-email-geert@linux-m68k.org>
References: <1418646102-32415-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Dec 2014 08:49:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBFGnXPV032691

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 15 Dec 2014 13:21:42 +0100

> net/rds/message.c: In function ¡rds_message_inc_copy_to_user¢:
> net/rds/message.c:328: warning: comparison of distinct pointer types lacks a cast
> 
> Use min_t(unsigned long, ...) like is done in
> rds_message_copy_from_user().
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Also applied, thanks Geert.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
