Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaI2UEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:04:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33459 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaI2UEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:04:40 -0400
Date: Mon, 29 Sep 2014 16:04:36 -0400 (EDT)
Message-Id: <20140929.160436.1932620234954504510.davem@davemloft.net>
To: antoine.tenart@free-electrons.com
Cc: sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/10] net: pxa168_eth: add device tree support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411742036-23520-3-git-send-email-antoine.tenart@free-electrons.com>
References: <1411742036-23520-1-git-send-email-antoine.tenart@free-electrons.com>
	<1411742036-23520-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Sep 2014 13:04:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8TK4mmY016833

From: Antoine Tenart <antoine.tenart@free-electrons.com>
Date: Fri, 26 Sep 2014 16:33:48 +0200

> @@ -1603,6 +1620,12 @@ static int pxa168_eth_suspend(struct platform_device *pdev, pm_message_t state)
>  #define pxa168_eth_suspend NULL
>  #endif
>  
> +static const struct of_device_id pxa168_eth_of_match[] = {
> +	{ .compatible = "marvell,pxa168-eth" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, pxa168_eth_of_match)
> +
>  static struct platform_driver pxa168_eth_driver = {

You didn't even compile test this change with module support enabled.

drivers/net/ethernet/marvell/pxa168_eth.c:1670:1: error: expected ¡,¢ or ¡;¢ before ¡static¢

MODULE_DEVICE_TABLE() must be completed with a trailing ';'
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
