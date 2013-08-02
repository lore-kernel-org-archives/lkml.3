Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3HBINg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:13:36 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39096 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3HBINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:13:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/m18tX8qg3ByssrC5nQibL
Date: Fri, 2 Aug 2013 01:13:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mel Gorman <mgorman@suse.de>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130802081315.GA7656@atomide.com>
References: <20130731073802.GT7656@atomide.com>
 <20130731152131.GW2296@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731152131.GW2296@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mel Gorman <mgorman@suse.de> [130731 08:28]:
> On Wed, Jul 31, 2013 at 12:38:03AM -0700, Tony Lindgren wrote:
> > Hi all,
> > 
> > Probably the biggest kernel data bloat issue is in the ARM land, but
> > it also seems that it's becoming a Linux generic issue too, so I
> > guess it could be discussed in either context.
> > 
> 
> Would scripts/bloat-o-meter highlight where the growth problems are?

Well to some extent yes, the board/SoC/driver specific options are
often behind Kconfig options. So if you want to limit the set of
supported SoCs and drivers for the kernel you can optimize it out.

The bloat-o-meter won't help for things like checking that a device
tree binding really describes the hardware, and is not just pointing
to a table of defined registers in the device driver.

A lot of the board specific, SoC specific, driver specific, debug
specifc and so on "data" should not be in the kernel to start with
and we can provide the same level of supported features in the kernel.

Regards,

Tony
