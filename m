Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaBKSoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:44:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaBKSn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:43:56 -0500
Date: Tue, 11 Feb 2014 10:45:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUGREPORT] Linux USB 3.0
Message-ID: <20140211184511.GA32425@kroah.com>
References: <CA+O4pCJAL_Dqrt0mF5rbErBXbLTALx8Rrs1+vB3JmT=+rT0jCg@mail.gmail.com>
 <CA+O4pC+bHC1Bo4ERSfos8fL+FdnwXTTu_EE=rfd9eFkY7432Jg@mail.gmail.com>
 <CA+O4pCJ5xUQwRem3rvZbvv7K8BEnMW983Qq_vR0tVzwAwmVS6A@mail.gmail.com>
 <CA+O4pCJ9dFuwrcVF2b5MsreUb4NJX8t6664i3XHM9CYrdN7VzA@mail.gmail.com>
 <20140120193510.GC5545@xanatos>
 <CA+O4pC+inTZBSVJDBs4PfaDv0et3ZT+eN-1epThRJMztdgQryQ@mail.gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6B8058@AcuExch.aculab.com>
 <CA+O4pCKedNsBcLoVP6T0BHT6sq00D+XNHLT790UDgdx-r7TL4Q@mail.gmail.com>
 <52F80C28.5040709@gmail.com>
 <CA+O4pCL8gUqFs7zTJZ+0UftOq_jALpg=rsmz3hSypOPr2qZg7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+O4pCL8gUqFs7zTJZ+0UftOq_jALpg=rsmz3hSypOPr2qZg7Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 07:29:47PM +0100, Markus Rechberger wrote:
> On Mon, Feb 10, 2014 at 12:15 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> > On 08/02/14 03:00 AM, Markus Rechberger wrote:
> >>
> >> On Tue, Feb 4, 2014 at 10:31 AM, David Laight <David.Laight@aculab.com>
> >> wrote:
> >>>
> >>> From: Markus Rechberger
> >>>>>>
> >>>>>> Dec 27 23:23:50 solist kernel: [   36.118245] xhci_hcd 0000:00:14.0:
> >>>>>> ERROR Transfer event TRB DMA
> >>>>
> >>>> ptr
> >>>>>
> >>>>>
> >>>>> These messages might be harmless.  The 3.0 kernel contains a fix for
> >>>>> Intel Panther Point xHCI hosts that suppresses those messages, commit
> >>>>> ad808333d8201d53075a11bc8dd83b81f3d68f0b "Intel xhci: Ignore spurious
> >>>>> successful event."
> >>>>>
> >>>>> A later commit extends that to all xHCI 1.0 hosts, commit
> >>>>> 07f3cb7c28bf3f4dd80bfb136cf45810c46ac474 "usb: host: xhci: Enable
> >>>>> XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0"  That was
> >>>>> queued for 3.11 and marked to be backported into stable kernels as old
> >>>>> as 3.0.
> >>>
> >>>
> >>> I see the same error message on the 0.96 ASMedia controller when
> >>> the rx buffers for the ax88179_178a driver cross 64k boundaries.
> >>>
> >>> So this isn't confined to 1.0 controllers.
> >>>
> >>
> >> Sarah,
> >>
> >> since there is no response yet, is there anyone at Intel dedicated at
> >> working on USB 3.0?
> >> We are also getting more and more negative USB 3.0 feedback with Linux
> >
> >
> > Still nobody appears to have provided the requested debugging information
> > that was requested. So there is not much that can be done upstream to debug
> > things based only on vague reports, especially when not using current kernel
> > versions.
> >
> 
> Next kernel crash report, this time a Synology NAS System:
> http://support.sundtek.com/index.php/topic,1511.0.html

That kernel has a closed source kernel module loaded, no community
member can look at it, sorry, please get support from the company that
wrote that module.

greg k-h
