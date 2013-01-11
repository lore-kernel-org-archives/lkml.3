Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3AKSNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:13:41 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62177 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755258Ab3AKSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:13:39 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19WQPYx9HQjEZuqUyKw5Y1m
Date: Fri, 11 Jan 2013 10:13:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, sameo@linux.intel.com,
        kishon@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/14] mfd: omap-usb-host: Consolidate OMAP USB-HS
 platform data
Message-ID: <20130111181331.GM14149@atomide.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
 <1357836694-30788-2-git-send-email-rogerq@ti.com>
 <20130110234537.GB15458@atomide.com>
 <50EFDE10.9080902@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EFDE10.9080902@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130111 01:43]:
> Tony,
> 
> On 01/11/2013 01:45 AM, Tony Lindgren wrote:
> > * Roger Quadros <rogerq@ti.com> [130110 08:54]:
> >> Let's have a single platform data structure for the OMAP's High-Speed
> >> USB host subsystem instead of having 3 separate ones i.e. one for
> >> board data, one for USB Host (UHH) module and one for USB-TLL module.
> >>
> >> This makes the code much simpler and avoids creating multiple copies of
> >> platform data.
> > 
> > I can apply just this patch alone into an immutable branch that
> > we all can merge in as needed as long as we have acks for the USB
> > and MFD parts.
> > 
> > Or does this one need to be changed based on Alan's comments
> > on the EHCI lib related changes?
> > 
> 
> This does not depend on EHCI lib based changes but it depends on the
> OMAP USB Host cleanup series posted earlier.

Can we first apply just the minimal platform_data + board file + clock
changes?

That way I can apply those to some immutable tree for everybody to use,
and we cut off the dependency to the driver changes for the rest of the
patches. And then I'm off the hook for the rest of the patches :)

Tony
