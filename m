Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab3BZW37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:29:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43372 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3BZW36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:29:58 -0500
Date: Tue, 26 Feb 2013 17:29:55 -0500 (EST)
Message-Id: <20130226.172955.926853809838377302.davem@davemloft.net>
To: gdt@gdt.id.au
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/net/asix_devices: Add USBNET HG20F9 ethernet dongle
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130226.172856.235525833921140241.davem@davemloft.net>
References: <1361852232.23197.4.camel@andromache.adelaide.aarnet.edu.au>
	<20130226.172856.235525833921140241.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 26 Feb 2013 14:30:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1QMTxLQ001095

From: David Miller <davem@davemloft.net>
Date: Tue, 26 Feb 2013 17:28:56 -0500 (EST)

> Applied, thanks Glen.

Actually, I had to revert, this doesn't even compile against
current sources:

  CC [M]  drivers/net/usb/asix_devices.o
drivers/net/usb/asix_devices.c:941:14: error: ¡asix_rx_fixup¢ undeclared here (not in a function)
make[1]: *** [drivers/net/usb/asix_devices.o] Error 1
make: *** [drivers/net/usb/asix_devices.o] Error 2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
