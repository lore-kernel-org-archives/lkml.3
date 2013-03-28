Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3C1RqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:46:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47651 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751160Ab3C1RqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:46:11 -0400
Date: Thu, 28 Mar 2013 13:46:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: 3.8.4: ohci question
In-Reply-To: <51546814.7080509@xs4all.nl>
Message-ID: <Pine.LNX.4.44L0.1303281345140.1652-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Udo van den Heuvel wrote:

> On 2013-03-28 15:35, Alan Stern wrote:
> >>> When my dmesg gives me a growing number of lines like the one below,
> >>> what is going on?
> >>>
> >>>  ohci_hcd 0000:00:12.0: urb ffff88023025c500 path 2 ep1in 6c160000 cc 6
> >>> --> status -71
> >>>
> >>> Please let me know!
> > 
> > -71 errors indicate a low-level problem on the USB bus.  Generally it
> > means that the device isn't sending any packets.  Maybe the device's
> > firmware has crashed or maybe it has been disconnected.
> 
> Could it be due to a defect in the mainboard?
> Or the device connected to that port?

Yes.  Or it could be due to any number of other things.  Do you want to 
post a complete dmesg log?

Alan Stern

