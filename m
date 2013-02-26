Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab3BZEXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:23:49 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:54806 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab3BZEXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:23:47 -0500
Date: Mon, 25 Feb 2013 20:23:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Glen Turner <gdt@gdt.id.au>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/net/asix_devices: Add USBNET HG20F9 ethernet dongle
Message-ID: <20130226042343.GA27766@kroah.com>
References: <1361852232.23197.4.camel@andromache.adelaide.aarnet.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361852232.23197.4.camel@andromache.adelaide.aarnet.edu.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 02:47:12PM +1030, Glen Turner wrote:
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

That is the best "add a new device id" changelog entry I have _ever_
seen.  Wonderful job:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
