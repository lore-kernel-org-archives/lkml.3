Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaCKQYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:24:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49224 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753030AbaCKQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:24:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ySj/vuEvYXOt0l70rIXBW
Date: Tue, 11 Mar 2014 09:24:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, bcousson@baylibre.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v9 0/9] USB Host support for OMAP5 uEVM
Message-ID: <20140311162428.GA7177@atomide.com>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
 <531ECDCB.4060700@ti.com>
 <20140311120259.GI21216@lee--X1>
 <531EFE97.1090202@ti.com>
 <20140311130715.GM21216@lee--X1>
 <531F0B49.2070008@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531F0B49.2070008@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140311 06:13]:
> On 03/11/2014 03:07 PM, Lee Jones wrote:
> > 
> >>>>> This patchset brings up USB Host ports and Ethernet port on
> >>>>> the OMAP5 uEVM board.
> >>>>>
> >>>>> It also does some cleanup with respect to DT clock binding
> >>>>> for the mfd/omap-usb-host driver.
> >>>>>
> >>>>> Please queue these for -next.
> >>>>>
> >>>>> Lee,
> >>>>>
> >>>>> I've folded some platform data dependent patches with mfd patches
> >>>>> so that they don't break functionality when applied individually.
> >>>>> You can safely pull in all MFD patches (1 to 6).
> >>>>>
> >>>>> Tony & Benoit,
> >>>>>
> >>>>> Can you please accept patches 7, 8 and 9?
> >>>>
> >>>> Tony has already picked up 7,8 and 9 through omap-soc tree.
> >>>>
> >>>> Since you acked most patches except 5 and 6, are you fine if Tony takes
> >>>> all the patches 1 to 4 in this series via omap-soc tree?
> >>>>
> >>>> What about patches 5 and 6?
> >>>
> >>> Any patches which are orthogonal can just be sucked into whichever tree
> >>> they belong in. If there are inter-subsystem dependencies I'd prefer
> >>> to take them and issue a immutable branch pull-request to the other
> >>> maintainers.
> >>>
> >> Awesome. That would be great, thanks.
> > 
> > That does mean I need a) all of the Maintainer Acks and b) you to tell
> > me which ones need to go through a single tree.
> > 
> 
> You need to take patches 1 to 6 in the MFD tree. Out of these, patches 1 to 4
> need to be shared with Tony as an immutable branch.
> 
> Tony, could you please Ack patches 1 to 4? Thanks.

Changes in 1 to 6 look OK to me, so for those please feel free to add:

Acked-by: Tony Lindgren <tony@atomide.com>
