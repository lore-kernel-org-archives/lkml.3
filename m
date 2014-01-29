Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaA2HhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 02:37:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49271 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaA2HhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 02:37:04 -0500
Date: Tue, 28 Jan 2014 23:37:03 -0800 (PST)
Message-Id: <20140128.233703.360671975054752022.davem@davemloft.net>
To: rashika.kheria@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 2/2] drivers: ide: Include appropriate header file in
 ide-pio-blacklist.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <2ec755ae03ae9f912f40a12a241f997909f380a1.1387278225.git.rashika.kheria@gmail.com>
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
	<2ec755ae03ae9f912f40a12a241f997909f380a1.1387278225.git.rashika.kheria@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0T7bHTg019254

From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Tue, 17 Dec 2013 16:41:11 +0530

> Include appropriate header file include/linux/ide.h in file
> ide-pio-blacklist.c because function ide_scan_pio_blacklist() has it's
> prototype declaration in include/linux/ide.h.
> 
> This eliminates the following warning in ide-pio-blacklist.c:
> drivers/ide/ide-pio-blacklist.c:85:5: warning: no previous prototype for ¡ide_scan_pio_blacklist¢ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Applied.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
