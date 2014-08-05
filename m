Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaHEUGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:06:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57957 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaHEUGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:06:36 -0400
Date: Tue, 05 Aug 2014 13:06:35 -0700 (PDT)
Message-Id: <20140805.130635.2042284107609253943.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: j.dumon@option.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dcbw@redhat.com
Subject: Re: [PATCH] net/usb/hso: Add support for Option GTM671WFS
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407143509-27683-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1407143509-27683-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Aug 2014 13:06:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon,  4 Aug 2014 11:11:49 +0200

> After this patch:
> 
> [   32.985530] hso: drivers/net/usb/hso.c: Option Wireless
> [   33.000452] hso 2-1.4:1.7: Not our interface
> [   33.001849] usbcore: registered new interface driver hso
> 
> root@qt5022:~# ls /dev/ttyHS*
> /dev/ttyHS0  /dev/ttyHS1  /dev/ttyHS2  /dev/ttyHS3  /dev/ttyHS4
> /dev/ttyHS5
> 
> root@qt5022:~# lsusb -d 0af0: -vvv
 ...
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Applied, thanks.
