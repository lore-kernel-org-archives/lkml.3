Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaIBBIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 21:08:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaIBBIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 21:08:35 -0400
Date: Mon, 01 Sep 2014 18:08:34 -0700 (PDT)
Message-Id: <20140901.180834.2149952137973916395.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-08-28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140828181713.GL13758@tuxdriver.com>
References: <20140828181713.GL13758@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Sep 2014 18:08:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 28 Aug 2014 14:17:14 -0400

> Please pull this batch of fixes intended for the 3.17 stream.
> 
> For the Bluetooth/6LowPAN/802.15.4 bits, Johan says:
> 
> 'It contains a connection reference counting fix for LE where a
> connection might stay up even though it should get disconnected.
> 
> The other 802.15.4 6LoWPAN related patches were sent to the bluetooth
> tree by Alexander Aring and described as follows by him:
> 
> "
> these patches contains patches for the bluetooth branch.
> 
> This series includes memory leak fixes and an errno value fix.
> Also there are two patches for sending and receiving 1280 6LoWPAN
> packets, which makes the IEEE 802.15.4 6LoWPAN stack more RFC
> compliant.
> "'
> 
> Along with that...
> 
> Alexey Khoroshilov fixes a use-after-free bug on at76c50x-usb.
> 
> Hauke Mehrtens adds a PCI ID to bcma.
> 
> Himangi Saraogi fixes a silly "A || A" test in rtlwifi.
> 
> Larry Finger adds a device ID to rtl8192cu.
> 
> Maks Naumov fixes a strncmp argument in ath9k.
> 
> Álvaro Fernández Rojas adds a PCI ID to ssb.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
