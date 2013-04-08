Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935564Ab3DHSXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:23:16 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:37868 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935406Ab3DHSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:23:14 -0400
Date: Mon, 8 Apr 2013 11:23:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, arnd@arndb.de,
        linux-usb@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH 0/5 v3] USB: Kconfig cleanups
Message-ID: <20130408182311.GA12889@kroah.com>
References: <1365091048-16229-1-git-send-email-florian@openwrt.org>
 <20130408163242.GA2184@kroah.com>
 <5163098E.7000604@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5163098E.7000604@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 08:16:46PM +0200, Florian Fainelli wrote:
> Le 08/04/2013 18:32, Greg KH a écrit :
> >On Thu, Apr 04, 2013 at 05:57:23PM +0200, Florian Fainelli wrote:
> >>
> >>These 5 patches contain my Kconfig cleanup on which I based the removal
> >>of the USB_ARCH_HAS_* patches. They have been suggested by Alan Stern
> >>as part of an earlier conversations.
> >>
> >>Let me know what you think about it so I can post subsequent work based
> >>on it.
> >
> >This series doesn't apply to my tree at the moment.  Can you refresh it
> >based on linux-next and resend it, with Alan's acks added?
> 
> Sure, it was based on usb-next, I will refresh that, thanks!

usb-next is best, sorry, I didn't realize that.  That's what I need to
apply it to, but it didn't work due to changes in the gadget tree.

thanks,

greg k-h
