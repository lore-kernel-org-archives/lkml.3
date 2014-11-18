Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaKRAya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:54:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKRAy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:54:28 -0500
Date: Mon, 17 Nov 2014 16:54:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Message-ID: <20141118005427.GB10271@kroah.com>
References: <546A829A.8030106@linaro.org>
 <20141118003028.GA11280@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118003028.GA11280@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 06:30:28PM -0600, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Nov 17, 2014 at 06:19:54PM -0500, Jorge Ramirez-Ortiz wrote:
> > Hi,
> > 
> > This patch adds USB3 support to the legacy gadget printer driver.
> > Applies cleanly on fc14f9c Linux 3.18-rc5.
> > 
> > Please could it be considered for inclusion?
> 
> sure, if you send it properly (see Documentation/SubmittingPatches),
> provide logs of your tests with a recent kernel (v3.18-rc5 would be just
> awesome) and Cc myself on your resubmission.
> 
> > diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/legacy/printer.c
> > index 6474081..625d905 100644
> > --- a/drivers/usb/gadget/legacy/printer.c
> > +++ b/drivers/usb/gadget/legacy/printer.c
> > @@ -3,6 +3,7 @@
> >   *
> >   * Copyright (C) 2003-2005 David Brownell
> >   * Copyright (C) 2006 Craig W. Nadler
> > + * Copyright (C) 2014 Linaro.org
> 
> I don't think the minimal change below constitutes enough to merit the
> copyright. If your lawyers tell you otherwise, let me know.
> 
> Greg, what's Linux Foundation's lawyers take on this ?

I'm not going to speak for the Linux Foundation here (we have no
in-house lawyers), but I have been advised that you need to modify/add
at least 1/3 of the file before you can add your copyright notice to a
file.  That's the rule I go by, and numerous lawyers I have asked about
this say it is a safe rule to follow.

Linaro should also be following those rules, last I checked with them,
so Jorge, you should go back and ask for clarification.

But then there's the issue that copyright notices in files really don't
mean anything, but I'm not going to get into that discussion right now :)

thanks,

greg k-h
