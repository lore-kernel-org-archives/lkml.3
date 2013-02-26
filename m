Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3BZW3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:29:01 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43358 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3BZW26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:28:58 -0500
Date: Tue, 26 Feb 2013 17:28:56 -0500 (EST)
Message-Id: <20130226.172856.235525833921140241.davem@davemloft.net>
To: gdt@gdt.id.au
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/net/asix_devices: Add USBNET HG20F9 ethernet dongle
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361852232.23197.4.camel@andromache.adelaide.aarnet.edu.au>
References: <1361852232.23197.4.camel@andromache.adelaide.aarnet.edu.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 26 Feb 2013 14:29:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glen Turner <gdt@gdt.id.au>
Date: Tue, 26 Feb 2013 14:47:12 +1030

> This USB ethernet adapter was purchased in anodyne packaging
> marked "USB2.0 to LAN" from the computer store adjacent to
> linux.conf.au 2013 in Canberra (Australia). A web search
> shows other recent purchasers in Lancaster (UK) and Seattle
> (USA). Just like an emergent virus, our age of e-commerce and
> airmail allows underdocumented hardware to spread around the
> world instantly using the vector of ridiculously low prices.
> 
> Paige Thompson, infected via eBay, discovered that the HG20F9
> is a copy of the Asix 88772B; many viruses copy the RNA of
> other viruses. See Paige's work at
> <https://github.com/paigeadele/HG20F9>.
> This patch uses her discovery to update the restructured Asix
> driver in the current kernel.
> 
> The spread of viruses is often accompanied by rumours. It is
> rumoured that the HG20F9 has extensions to to provide gigabit
> ethernet. This patch does not chase that chimera.
> 
> Just as some viruses inhabit seemingly-healthy cells, the
> HG20F9 uses the Vendor ID 0x066b assigned to Linksys Inc.
> For the present there is no clash of Product ID 0x20f9.
> 
> Signed-off-by: Glen Turner <gdt@gdt.id.au>

Applied, thanks Glen.
