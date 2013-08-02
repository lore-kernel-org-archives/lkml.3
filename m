Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab3HBHzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:55:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61759 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3HBHzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:55:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX185DIC209QUNjdHBy1tr6Lw
Date: Fri, 2 Aug 2013 00:55:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Greg KH <greg@kroah.com>, ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130802075514.GZ7656@atomide.com>
References: <20130731073802.GT7656@atomide.com>
 <20130731123351.GA30474@kroah.com>
 <20130731135346.GN5882@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731135346.GN5882@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Cooper <jason@lakedaemon.net> [130731 07:00]:
> On Wed, Jul 31, 2013 at 05:33:51AM -0700, Greg KH wrote:
> > On Wed, Jul 31, 2013 at 12:38:03AM -0700, Tony Lindgren wrote:
> > > Hi all,
> > > 
> > > Probably the biggest kernel data bloat issue is in the ARM land, but
> > > it also seems that it's becoming a Linux generic issue too, so I
> > > guess it could be discussed in either context.
> > 
> > Why is it specific to ARM?  What is so unique to ARM that causes it to
> > "bloat"?
> > 
> > And what exactly do you mean by "bloat"?
> 
> Perhaps he's referring to the multiplatform effort?  You'd get a lot of
> board code that wouldn't be used at each boot.  This should be declining
> though...

Yes that too, device tree and ACPI help there a great deal as we don't
need to build in board specific data for each supported board, but
instead have just one copy of the board specific data come from the
bootloader.

Regards,

Tony
