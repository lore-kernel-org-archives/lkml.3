Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab3BFRMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:12:10 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:36192 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753990Ab3BFRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:12:07 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/b+WEtx1RI1nnmG2/A9ZlX
Date: Wed, 6 Feb 2013 09:11:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux@arm.linux.org.uk,
        sameo@linux.intel.com, balbi@ti.com, stern@rowland.harvard.edu,
        eballetbo@gmail.com, javier@dowhile0.org, sshtylyov@mvista.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY
 driver
Message-ID: <20130206171153.GY25185@atomide.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <5110ECF3.7010908@ti.com>
 <20130205165851.GA1081@kroah.com>
 <20130205171743.GG25185@atomide.com>
 <51122730.5030801@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51122730.5030801@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130206 01:53]:
> On 02/05/2013 07:17 PM, Tony Lindgren wrote:
> > * Greg KH <gregkh@linuxfoundation.org> [130205 09:00]:
> >> On Tue, Feb 05, 2013 at 01:28:51PM +0200, Roger Quadros wrote:
> >>> Hi Tony & Greg,
> >>>
> >>> What's the best way to get these patches in?
> >>>
> >>> All patches have been acked by respective maintainers.
> >>>
> >>> If Tony can Ack the arch/arm/mach-omap2 stuff then should I send a
> >>> pull request directly to Greg? or the other way round?
> >>>
> >>> Tony, 
> >>> fyi, these patches should not interfere with the dw3c/musb stuff
> >>> sent by Felipe & Kishon.
> >>
> >> I'm fine with Tony just taking them all if he wants to.
> > 
> > OK. Roger, can you please do me a pull request with these
> > against v3.8-rc6?
> > 
> 
> Tony,
> 
> Since this depends on [1] and [2] which are both in linux-next, should
> I base it on linux-next?

Maybe you can base it on some commit in Greg's USB tree?
Just check with Greg that whatever you use as a base is an
immutable commit and OK to use as a base.
 
> Another option is to defer this to 3.10 merge window, along with the
> DT adaptation for OMAP USB Host.

Once you have a branch ready that builds and boots, let's see how
badly that conflicts with other branches we have queued up. If it's
trivial only, then maybe Greg can pick up the patches. If not, we
can still try to merge it in later on during the merge window as
it would be nice to get USB to usable point with DT.

Regards,

Tony
 
> [1] [PATCH v9 00/20] OMAP USB Host cleanup
> https://lkml.org/lkml/2013/1/23/155
> 
> [2] [PATCH v2 0/6] USB: Add support for multiple PHYs of same type
> https://lkml.org/lkml/2013/1/24/876
