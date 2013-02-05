Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3BERRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:17:53 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48680 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437Ab3BERRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:17:52 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18d43JwWy0LIgLp3zdLtzxo
Date: Tue, 5 Feb 2013 09:17:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Roger Quadros <rogerq@ti.com>, linux@arm.linux.org.uk,
        sameo@linux.intel.com, balbi@ti.com, stern@rowland.harvard.edu,
        eballetbo@gmail.com, javier@dowhile0.org, sshtylyov@mvista.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY
 driver
Message-ID: <20130205171743.GG25185@atomide.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <5110ECF3.7010908@ti.com>
 <20130205165851.GA1081@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205165851.GA1081@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@linuxfoundation.org> [130205 09:00]:
> On Tue, Feb 05, 2013 at 01:28:51PM +0200, Roger Quadros wrote:
> > Hi Tony & Greg,
> > 
> > What's the best way to get these patches in?
> > 
> > All patches have been acked by respective maintainers.
> > 
> > If Tony can Ack the arch/arm/mach-omap2 stuff then should I send a
> > pull request directly to Greg? or the other way round?
> > 
> > Tony, 
> > fyi, these patches should not interfere with the dw3c/musb stuff
> > sent by Felipe & Kishon.
> 
> I'm fine with Tony just taking them all if he wants to.

OK. Roger, can you please do me a pull request with these
against v3.8-rc6?

Regards,

Tony
