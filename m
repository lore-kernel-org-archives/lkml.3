Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaFTO56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:57:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46360 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752850AbaFTO54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:57:56 -0400
Date: Fri, 20 Jun 2014 10:57:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [usb resume regression] in 3.16-rc1
In-Reply-To: <CADDKRnBqPVg63sbaWX-w4Log_Sr+DFth5nURY7T=nRh6UxymWg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1406201056270.1160-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Jörg Otte wrote:

> 2014-06-19 19:35 GMT+02:00 Alan Stern <stern@rowland.harvard.edu>:
> > On Thu, 19 Jun 2014, Jörg Otte wrote:
> >
> >> I don't know how to do this.
> >
> > To enable dynamic debugging (as root):
> >
> >     echo 'module usbcore =p' >/sys/kernel/debug/dynamic_debug/control
> >     echo 'module ehci_hcd =p' >/sys/kernel/debug/dynamic_debug/control
> >
> > Do this before you carry out the suspend, and post the resulting dmesg
> > log.
> >
> > Alan Stern
> >
> here it is.

Now I see the reason for the regression.  There already is a patch to 
fix it:

	http://marc.info/?l=linux-usb&m=140304702623966&w=2

The fix will probably be included in 3.16-rc2 or -rc3.

Alan Stern

