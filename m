Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3LSXwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:52:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36834 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab3LSXwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:52:25 -0500
Date: Thu, 19 Dec 2013 18:52:23 -0500 (EST)
Message-Id: <20131219.185223.661280204547522817.davem@davemloft.net>
To: rashika.kheria@gmail.com
Cc: sgruszka@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH v3 5/8] drivers: net: Mark functions as static in
 3945-debug.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <f6dd170a28455058d1d236425150d40baa3df0b3.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
	<f6dd170a28455058d1d236425150d40baa3df0b3.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 15:52:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJNrccg008850

From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Thu, 19 Dec 2013 14:23:49 +0530

> This patch marks the function il3945_ucode_rx_stats_read(),
> il3945_ucode_tx_stats_read() and il3945_ucode_general_stats_read() in
> 3945-debug.c as static because they are not used outside this file.
> 
> Thus, it also removes the following warnings in
> wireless/iwlegacy/3945-debug.c:
> 
> drivers/net/wireless/iwlegacy/3945-debug.c:52:1: warning: no previous prototype for ¡il3945_ucode_rx_stats_read¢ [-Wmissing-prototypes]
> drivers/net/wireless/iwlegacy/3945-debug.c:317:1: warning: no previous prototype for ¡il3945_ucode_tx_stats_read¢ [-Wmissing-prototypes]
> drivers/net/wireless/iwlegacy/3945-debug.c:407:1: warning: no previous prototype for ¡il3945_ucode_general_stats_read¢ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
