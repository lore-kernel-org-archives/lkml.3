Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaA0Gmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:42:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56290 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaA0Gmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:42:53 -0500
Date: Sun, 26 Jan 2014 22:42:53 -0800 (PST)
Message-Id: <20140126.224253.171312551216917580.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: tedheadster@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/apne: Remove unused variable ei_local
From: David Miller <davem@davemloft.net>
In-Reply-To: <1390733063-9077-1-git-send-email-geert@linux-m68k.org>
References: <1390733063-9077-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0R6h2PW007201

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 26 Jan 2014 11:44:23 +0100

> drivers/net/ethernet/8390/apne.c: In function ¡apne_probe1¢:
> drivers/net/ethernet/8390/apne.c:215: warning: unused variable ¡ei_local¢
> 
> Introduced by commit c45f812f0280c13f1b7992be5e0de512312a9e8f ("8390 :
> Replace ei_debug with msg_enable/NETIF_MSG_* feature"), which added the
> variable without using it.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
