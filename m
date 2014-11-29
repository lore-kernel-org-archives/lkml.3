Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaK2WLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 17:11:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60408 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751555AbaK2WLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 17:11:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB development list <linux-usb@vger.kernel.org>
Subject: Re: [Update][PATCH] USB / PM: Drop CONFIG_PM_RUNTIME from the USB core
Date: Sat, 29 Nov 2014 23:33:07 +0100
Message-ID: <1620629.NGrQGDcfut@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1411291233560.23420-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1411291233560.23420-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 29, 2014 12:34:36 PM Alan Stern wrote:
> On Sat, 29 Nov 2014, Rafael J. Wysocki wrote:
> 
> > > There are also one or two places in Documentation/usb that mention 
> > > CONFIG_PM_RUNTIME.
> > 
> > I found this in Documentation/usb/power-management.txt:
> > 
> > "Note: Dynamic PM support for USB is present only if the kernel was
> >  built with CONFIG_USB_SUSPEND enabled (which depends on
> >  CONFIG_PM_RUNTIME).  System PM support is present only if the kernel
> >  was built with CONFIG_SUSPEND or CONFIG_HIBERNATION enabled.
> > 
> >  (Starting with the 3.10 kernel release, dynamic PM support for USB is
> >  present whenever the kernel was built with CONFIG_PM_RUNTIME enabled.
> >  The CONFIG_USB_SUSPEND option has been eliminated.)"
> > 
> > but I'm quite unsure how to change it.  What about:
> > 
> > "System PM support is present only if the kernel was built with CONFIG_SUSPEND
> >  or CONFIG_HIBERNATION enabled.  Dynamic PM support for USB is present whenever
> >  the kernel was built with CONFIG_PM enabled.
> > 
> >  [Historically, dynamic PM support for USB was present only if the kernel
> >  had been built with CONFIG_USB_SUSPEND enabled (which depended on
> >  CONFIG_PM_RUNTIME).  Starting with the 3.10 kernel release, dynamic PM support
> >  for USB was present whenever the kernel was built with CONFIG_PM_RUNTIME
> >  enabled.  The CONFIG_USB_SUSPEND option had been eliminated.]
> 
> That sounds fine.  Thanks.

OK, thanks.

I'll add that to the patch and resend it, then.

Rafael

