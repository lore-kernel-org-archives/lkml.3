Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3LSXwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:52:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36847 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab3LSXwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:52:37 -0500
Date: Thu, 19 Dec 2013 18:52:36 -0500 (EST)
Message-Id: <20131219.185236.196101381723148304.davem@davemloft.net>
To: rashika.kheria@gmail.com
Cc: sgruszka@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH v3 7/8] drivers: net: Mark functions as static in
 debug.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <8e5f8e06430a9d822c4d5a1a3a7a3454eb75281c.1387382457.git.rashika.kheria@gmail.com>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
	<8e5f8e06430a9d822c4d5a1a3a7a3454eb75281c.1387382457.git.rashika.kheria@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 15:52:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJNqnZp008830

From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Thu, 19 Dec 2013 14:25:34 +0530

> This patch marks the function il_clear_traffic_stats() in debug.c as
> static because they are not used outside this file.
> 
> Thus, it also removes the following warnings in
> wireless/iwlegacy/debug.c:
> 
> drivers/net/wireless/iwlegacy/debug.c:35:1: warning: no previous prototype for ¡il_clear_traffic_stats¢ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
