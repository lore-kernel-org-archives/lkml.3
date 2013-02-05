Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3BEQ4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:56:44 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40144 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3BEQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:56:42 -0500
Date: Tue, 5 Feb 2013 08:58:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, linux@arm.linux.org.uk, sameo@linux.intel.com,
        balbi@ti.com, stern@rowland.harvard.edu, eballetbo@gmail.com,
        javier@dowhile0.org, sshtylyov@mvista.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY
 driver
Message-ID: <20130205165851.GA1081@kroah.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <5110ECF3.7010908@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110ECF3.7010908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 01:28:51PM +0200, Roger Quadros wrote:
> Hi Tony & Greg,
> 
> What's the best way to get these patches in?
> 
> All patches have been acked by respective maintainers.
> 
> If Tony can Ack the arch/arm/mach-omap2 stuff then should I send a
> pull request directly to Greg? or the other way round?
> 
> Tony, 
> fyi, these patches should not interfere with the dw3c/musb stuff
> sent by Felipe & Kishon.

I'm fine with Tony just taking them all if he wants to.

thanks,

greg k-h
