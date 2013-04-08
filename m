Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935163Ab3DHQct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:32:49 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53035 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab3DHQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:32:45 -0400
Date: Mon, 8 Apr 2013 09:32:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, arnd@arndb.de,
        linux-usb@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH 0/5 v3] USB: Kconfig cleanups
Message-ID: <20130408163242.GA2184@kroah.com>
References: <1365091048-16229-1-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365091048-16229-1-git-send-email-florian@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 05:57:23PM +0200, Florian Fainelli wrote:
> 
> These 5 patches contain my Kconfig cleanup on which I based the removal
> of the USB_ARCH_HAS_* patches. They have been suggested by Alan Stern
> as part of an earlier conversations.
> 
> Let me know what you think about it so I can post subsequent work based
> on it.

This series doesn't apply to my tree at the moment.  Can you refresh it
based on linux-next and resend it, with Alan's acks added?

thanks,

greg k-h
