Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbaE3QGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:06:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55192 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932378AbaE3QF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:05:57 -0400
X-Sasl-enc: 6fab5p2zXpzclKrxkdofOqmwmnHT04+QWVa1CvbZrHPs 1401465956
Date: Fri, 30 May 2014 09:09:33 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 12/15] pci: Add pci_fixup_suspend_late quirk pass.
Message-ID: <20140530160933.GA11279@kroah.com>
References: <1401117492-2870-1-git-send-email-andreas.noever@gmail.com>
 <1401117492-2870-13-git-send-email-andreas.noever@gmail.com>
 <20140528223637.GY11907@google.com>
 <CAMxnaaVwSev1EuEUghxFFzp0M2mMy3qYHgJA+rXpLhiJQH7Psg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMxnaaVwSev1EuEUghxFFzp0M2mMy3qYHgJA+rXpLhiJQH7Psg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 04:33:20PM +0200, Andreas Noever wrote:
> On Thu, May 29, 2014 at 12:36 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Mon, May 26, 2014 at 05:18:09PM +0200, Andreas Noever wrote:
> >
> > Please adjust the subject to match the drivers/pci convention, i.e., change
> >
> >   pci: Add pci_fixup_suspend_late quirk pass.
> >
> > to
> >
> >   PCI: Add pci_fixup_suspend_late quirk pass
> >
> >> Add pci_fixup_suspend_late as a new pci_fixup_pass. The pass is called
> >> from suspend_noirq and poweroff_noirq. Using the same pass for suspend
> >> and hibernate is consistent with resume_early which is called by
> >> resume_noirq and restore_noirq.
> >>
> >> The new quirk pass is required for Thunderbolt support on Apple
> >> hardware.
> >>
> >> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
> >
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Thanks for reading through the series. I will make those changes for
> the next version.
> 
> > I assume you'll merge this along with the rest of the series, not through
> > my PCI tree.
> Agreed, since I am the only user of this pass. Can you tell me whose
> tree normally carries new drivers?

That's mine.  But if Matthew wants to take this in his trees, I'll have
no objection.

thanks,

greg k-h
