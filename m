Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaI1VBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:01:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47475 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaI1VBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:01:52 -0400
Date: Sun, 28 Sep 2014 17:01:50 -0400 (EDT)
Message-Id: <20140928.170150.1279138730834841306.davem@davemloft.net>
To: m.grzeschik@pengutronix.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 0/5] ARCNET: add support for EAE multi interfac card
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140928.164421.1247481867383564525.davem@davemloft.net>
References: <1411566113-15583-1-git-send-email-m.grzeschik@pengutronix.de>
	<20140928.164421.1247481867383564525.davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Sep 2014 14:01:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8SL2BWk009918

From: David Miller <davem@davemloft.net>
Date: Sun, 28 Sep 2014 16:44:21 -0400 (EDT)

> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Date: Wed, 24 Sep 2014 15:41:48 +0200
> 
>> this series adds support for the PLX Bridge based multi interface
>> pci cards and adds support to change device address on com200xx chips
>> during runtime.
>> 
>> This series is based on v3.17-rc6.
> 
> Series applied to net-next, thanks.

I had to revert, this breaks the build:

drivers/net/arcnet/com20020_cs.c:115:8: error: redefinition of ¡struct com20020_dev¢
 struct com20020_dev {
        ^
In file included from drivers/net/arcnet/com20020_cs.c:43:0:
include/linux/com20020.h:66:8: note: originally defined here
 struct com20020_dev {
        ^
make[3]: *** [drivers/net/arcnet/com20020_cs.o] Error 1
make[2]: *** [drivers/net/arcnet] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
