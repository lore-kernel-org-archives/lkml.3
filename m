Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab3BFRsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:48:20 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40033 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3BFRsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:48:17 -0500
Date: Wed, 6 Feb 2013 09:48:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Roger Quadros <rogerq@ti.com>, linux@arm.linux.org.uk,
        sameo@linux.intel.com, balbi@ti.com, stern@rowland.harvard.edu,
        eballetbo@gmail.com, javier@dowhile0.org, sshtylyov@mvista.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY
 driver
Message-ID: <20130206174813.GB18681@kroah.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <5110ECF3.7010908@ti.com>
 <20130205165851.GA1081@kroah.com>
 <20130205171743.GG25185@atomide.com>
 <51122730.5030801@ti.com>
 <20130206171153.GY25185@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206171153.GY25185@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 09:11:54AM -0800, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130206 01:53]:
> > On 02/05/2013 07:17 PM, Tony Lindgren wrote:
> > > * Greg KH <gregkh@linuxfoundation.org> [130205 09:00]:
> > >> On Tue, Feb 05, 2013 at 01:28:51PM +0200, Roger Quadros wrote:
> > >>> Hi Tony & Greg,
> > >>>
> > >>> What's the best way to get these patches in?
> > >>>
> > >>> All patches have been acked by respective maintainers.
> > >>>
> > >>> If Tony can Ack the arch/arm/mach-omap2 stuff then should I send a
> > >>> pull request directly to Greg? or the other way round?
> > >>>
> > >>> Tony, 
> > >>> fyi, these patches should not interfere with the dw3c/musb stuff
> > >>> sent by Felipe & Kishon.
> > >>
> > >> I'm fine with Tony just taking them all if he wants to.
> > > 
> > > OK. Roger, can you please do me a pull request with these
> > > against v3.8-rc6?
> > > 
> > 
> > Tony,
> > 
> > Since this depends on [1] and [2] which are both in linux-next, should
> > I base it on linux-next?
> 
> Maybe you can base it on some commit in Greg's USB tree?
> Just check with Greg that whatever you use as a base is an
> immutable commit and OK to use as a base.

My public git trees should always be immutable and can be used as a
base.

thanks,

greg k-h
