Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab3LSXwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:52:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36841 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab3LSXwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:52:31 -0500
Date: Thu, 19 Dec 2013 18:52:29 -0500 (EST)
Message-Id: <20131219.185229.2032027165558895489.davem@davemloft.net>
To: rashika.kheria@gmail.com
Cc: sgruszka@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH v3 6/8] drivers: net: Mark functions as static in
 4965-debug.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <b5de1ef19267bbdb0b6f8b36f74b7f59f833cffd.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
	<b5de1ef19267bbdb0b6f8b36f74b7f59f833cffd.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 15:52:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJNqmtR008826

From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Thu, 19 Dec 2013 14:24:38 +0530

> This patch marks the function il4965_ucode_rx_stats_read(),
> il4965_ucode_tx_stats_read() and il4965_ucode_general_stats_read() in
> 4965-debug.c as static because they are not used outside this file.
> 
> Thus, it also removes the following warnings in
> wireless/iwlegacy/4965-debug.c:
> 
> drivers/net/wireless/iwlegacy/4965-debug.c:59:1: warning: no previous prototype for ¡il4965_ucode_rx_stats_read¢ [-Wmissing-prototypes]
> drivers/net/wireless/iwlegacy/4965-debug.c:471:1: warning: no previous prototype for ¡il4965_ucode_tx_stats_read¢ [-Wmissing-prototypes]
> drivers/net/wireless/iwlegacy/4965-debug.c:637:1: warning: no previous prototype for ¡il4965_ucode_general_stats_read¢ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
