Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763608Ab3DDRCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:02:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58097 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763518Ab3DDRCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:02:04 -0400
Date: Thu, 4 Apr 2013 13:02:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-kernel@vger.kernel.org, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH 0/5 v3] USB: Kconfig cleanups
In-Reply-To: <1365091048-16229-1-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1304041301270.1324-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Apr 2013, Florian Fainelli wrote:

> 
> These 5 patches contain my Kconfig cleanup on which I based the removal
> of the USB_ARCH_HAS_* patches. They have been suggested by Alan Stern
> as part of an earlier conversations.
> 
> Let me know what you think about it so I can post subsequent work based
> on it.
> 
> Thanks! Fainelli (5):
>   USB: regroup all depends on USB within an if USB block
>   USB: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO} depends on architecture
>     symbol
>   USB: enclose EHCI HCD drivers within an if USB_EHCI_HCD block
>   USB: enclose all depends on USB_OHCI_HCD within an if USB_OHCI_HCD
>     block
>   USB: enclose USB_XHCI_HCD related symbols within a if USB_XHCI_HCD
>     block

They all look good now.  You can add my Acked-by to the remaining ones.

Alan Stern

