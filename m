Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3C1Ofh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:35:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46334 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753231Ab3C1Off (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:35:35 -0400
Date: Thu, 28 Mar 2013 10:35:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Udo van den Heuvel <udovdh@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: 3.8.4: ohci question
In-Reply-To: <CAErSpo5J9+2GF5afT3hUb6u8r1nwQi68mRja8Fq6BO-pb=zDhQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303281034160.1652-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Bjorn Helgaas wrote:

> [+cc linux-usb]
> 
> On Wed, Mar 27, 2013 at 11:37 AM, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
> > Hello,
> >
> > When my dmesg gives me a growing number of lines like the one below,
> > what is going on?
> >
> >  ohci_hcd 0000:00:12.0: urb ffff88023025c500 path 2 ep1in 6c160000 cc 6
> > --> status -71
> >
> > Please let me know!

-71 errors indicate a low-level problem on the USB bus.  Generally it
means that the device isn't sending any packets.  Maybe the device's
firmware has crashed or maybe it has been disconnected.

Alan Stern

