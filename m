Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab3JKQMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:12:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330Ab3JKQML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:12:11 -0400
Date: Fri, 11 Oct 2013 09:12:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "ethan.zhao" <ethan.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: [PATCH] drivers/base/core.c: always output device renaming
 messages.
Message-ID: <20131011161210.GB32305@kroah.com>
References: <1381460298-1097-1-git-send-email-ethan.kernel@gmail.com>
 <20131011153544.GA14715@kroah.com>
 <CAErSpo7KHk66uxqerQfo60OLU=WVO6zMtfH24L8QPy9RcMHJ6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7KHk66uxqerQfo60OLU=WVO6zMtfH24L8QPy9RcMHJ6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 10:08:09AM -0600, Bjorn Helgaas wrote:
> [+cc Don, e1000-devel]
> 
> On Fri, Oct 11, 2013 at 9:35 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Oct 11, 2013 at 10:58:18AM +0800, ethan.zhao wrote:
> >> From: "ethan.zhao" <ethan.kernel@gmail.com>
> >>
> >> While loading ixgbevf driver,every vf detected will be output as the
> >> same name 'eth4':
> >>
> >>  ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver -
> >>  version 2.8.7
> >>  Copyright (c) 2009-2012 Intel Corporation.
> >>  ixgbevf 0000:20:10.0: enabling device (0000 -> 0002)
> >>  ixgbe 0000:20:00.0 eth0: VF Reset msg received from vf 0
> >>  ixgbevf 0000:20:10.0: irq 199 for MSI/MSI-X
> >>  ixgbevf 0000:20:10.0: irq 200 for MSI/MSI-X
> >>  ixgbevf: eth%d: ixgbevf_init_interrupt_scheme: Multiqueue Disabled: Rx Queue
> >>  count = 1, Tx Queue count = 1
> >
> > What is that message?  That's not good, "eth%d"?
> 
> Just a reminder that ixgbevf 2.8.7 is not the driver version that's in
> the kernel tree, so it's easy to spend time on mainline issue that
> have been fixed in the out-of-tree versions, or vice versa.
> 
> Per Don, the latest ixgbevf driver is here:
> https://sourceforge.net/projects/e1000/files/ixgbevf%20stable/

I hate to ask why isn't this merged upstream, but given that this is an
Intel network driver, I know the answer :(

Thanks for pointing this out, saved me a trip through the kernel tree...

greg k-h

> 
> Bjorn
