Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab3DYIYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:24:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50003 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab3DYIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:24:18 -0400
Date: Thu, 25 Apr 2013 04:24:17 -0400 (EDT)
Message-Id: <20130425.042417.1494106191618435733.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: isdn@linux-pingi.de, rusty@rustcorp.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn/sc: Fix incorrect module_param_array types
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366807597-24314-1-git-send-email-geert@linux-m68k.org>
References: <1366807597-24314-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 25 Apr 2013 01:24:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3P8ORFr026587

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 24 Apr 2013 14:46:37 +0200

> drivers/isdn/sc/init.c: In function ¡__check_irq¢:
> drivers/isdn/sc/init.c:36: warning: return from incompatible pointer type
> drivers/isdn/sc/init.c: In function ¡__check_ram¢:
> drivers/isdn/sc/init.c:37: warning: return from incompatible pointer type
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
