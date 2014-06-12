Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaFLSFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:05:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53409 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaFLSFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:05:20 -0400
Date: Thu, 12 Jun 2014 11:05:19 -0700 (PDT)
Message-Id: <20140612.110519.583755215428272991.davem@davemloft.net>
To: varkabhadram@gmail.com
Cc: netdev@vger.kernel.org, alex.bluesman.smirnov@gmail.com,
        dbaryshkov@gmail.com, linux-zigbee-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, varkab@cdac.in
Subject: Re: [PATCH net-next] mrf24j40: separate h/w init and add checkings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140612.110324.932062947770396872.davem@davemloft.net>
References: <1402564248-20606-1-git-send-email-varkab@cdac.in>
	<20140612.110324.932062947770396872.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Jun 2014 11:05:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5CI5a9S008144

From: David Miller <davem@davemloft.net>
Date: Thu, 12 Jun 2014 11:03:24 -0700 (PDT)

> From: Varka Bhadram <varkabhadram@gmail.com>
> Date: Thu, 12 Jun 2014 14:40:48 +0530
> 
>> separate the mrf24j40 hardware initialisation from probe()
>> and adds the sanity checkings.
>> 
>> These checkings are required if somebody hasn't a right spi configuration 
>> the probe function should fail. So we have to return from there.
>> 
>> Signed-off-by: Varka Bhadram <varkab@cdac.in>
> 
> Applied, thanks.

Reverted, did you even compile test this change?

drivers/net/ieee802154/mrf24j40.c: In function ¡mrf24j40_probe¢:
drivers/net/ieee802154/mrf24j40.c:741:10: error: ¡err_hw_init¢ undeclared (first use in this function)
drivers/net/ieee802154/mrf24j40.c:741:10: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/ieee802154/mrf24j40.c:759:1: warning: label ¡err_hw_init¢ defined but not used [-Wunused-label]
drivers/net/ieee802154/mrf24j40.c:702:5: warning: unused variable ¡val¢ [-Wunused-variable]
make[1]: *** [drivers/net/ieee802154/mrf24j40.o] Error 1
make: *** [drivers/net/ieee802154/mrf24j40.o] Error 2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
