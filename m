Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbbAFDmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:42:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37243 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbbAFDmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:42:39 -0500
Date: Mon, 05 Jan 2015 22:42:35 -0500 (EST)
Message-Id: <20150105.224235.1941007145649816230.davem@davemloft.net>
To: fkan@apm.com
Cc: patches@apm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: eth: xgene: change APM X-Gene SoC platform
 ethernet to support ACPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <20150105.224137.894770670718334587.davem@davemloft.net>
References: <1420508576-10480-1-git-send-email-fkan@apm.com>
	<20150105.224137.894770670718334587.davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Jan 2015 19:42:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t063glUf010565

From: David Miller <davem@davemloft.net>
Date: Mon, 05 Jan 2015 22:41:37 -0500 (EST)

> From: Feng Kan <fkan@apm.com>
> Date: Mon,  5 Jan 2015 17:42:56 -0800
> 
>> This adds support for APM X-Gene ethernet driver to use ACPI table to derive
>> ethernet driver parameter.
>> 
>> Signed-off-by: Feng Kan <fkan@apm.com>
> 
> Applied.

Actually, reverted, this breaks the build:

drivers/net/ethernet/apm/xgene/xgene_enet_main.c:1031:28: warning: ¡xgene_enet_of_match¢ defined but not used [-Wunused-variable]
 static struct of_device_id xgene_enet_of_match[] = {
                            ^
In file included from drivers/net/ethernet/apm/xgene/xgene_enet_main.h:32:0,
                 from drivers/net/ethernet/apm/xgene/xgene_enet_main.c:22:
include/linux/module.h:138:40: error: ¡__mod_of__xgene_enet_match_device_table¢ aliased to undefined symbol ¡xgene_enet_match¢
   extern const struct type##_device_id __mod_##type##__##name##_device_table \
                                        ^
drivers/net/ethernet/apm/xgene/xgene_enet_main.c:1036:1: note: in expansion of macro ¡MODULE_DEVICE_TABLE¢
 MODULE_DEVICE_TABLE(of, xgene_enet_match);
 ^
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
