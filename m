Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3FCHNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:13:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37938 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FCHNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:13:02 -0400
Date: Mon, 03 Jun 2013 00:13:01 -0700 (PDT)
Message-Id: <20130603.001301.239203578028894121.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: nsujir@broadcom.com, mchan@broadcom.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        guohanjun@huawei.com, liuj97@gmail.com
Subject: Re: [PATCH] tg3: remove redundant pm init code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369818032-36272-1-git-send-email-wangyijing@huawei.com>
References: <1369818032-36272-1-git-send-email-wangyijing@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r537DJbk005061

From: Yijing Wang <wangyijing@huawei.com>
Date: Wed, 29 May 2013 17:00:32 +0800

> Pci_enable_device() will set device pm state to D0, so
> it's no need to do it again in tg3_init_one().
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

This patch introduces a warning:

drivers/net/ethernet/broadcom/tg3.c: In function ¡tg3_init_one¢:
drivers/net/ethernet/broadcom/tg3.c:17231:13: warning: ¡pm_cap¢ may be used uninitialized in this function [-Wuninitialized]
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
