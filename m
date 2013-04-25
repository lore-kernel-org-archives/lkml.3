Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab3DYRCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:02:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39303 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932627Ab3DYRCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:02:22 -0400
Date: Thu, 25 Apr 2013 13:02:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sedat Dilek <sedat.dilek@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 24 [ PM: Device 1-1.2 failed to resume
 async: error -32 ]
In-Reply-To: <CA+icZUVUd=0oFhPt8Gneze1UyZ5vyGxoEDnBNrya0+mn99nQkA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1304251301190.948-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Sedat Dilek wrote:

> > That also looks normal.  Did you have CONFIG_USB_DEBUG enabled during
> > this test?  If you did, you could try turning it back off to see if the
> > original problem returns while still doing a usbmon trace.
> >
> 
> As my system works as "expected" after suspend-resume and as you
> pointed out "this is harmless" I am not really willing to do more
> "homework".
> 
> The ipc-sem-next issue has stolen quite bit of my time.
> 
> Thanks for the usbmon hint, now I know for next USB issues what to do.
> And I have never tried my USB-XHCI interface :-).
> 
> /me is just an encouraged Linux-kernel hobbyist.

Okay.  Don't lose hope; lots of people face unexpected issues like 
this.  Good luck!

Alan Stern

