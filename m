Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3A3S6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:58:40 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43118 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3A3S6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:58:38 -0500
Date: Wed, 30 Jan 2013 13:58:15 -0500
From: "John L. Males" <jlmales@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re[04]: Kernel Failure - 3.4.24
Message-Id: <20130130135815.33c9855b.jlmales@gmail.com>
In-Reply-To: <51084005.2050506@linutronix.de>
References: <20130116184221.aaa9e2aa.jlmales@gmail.com>
	<51055256.6030602@linutronix.de>
	<20130128145708.3c241dc8.jlmales@gmail.com>
	<51084005.2050506@linutronix.de>
Reply-To: jlmales@gmail.com
Organization: Toronto, Ontario
X-Mailer: Sylpheed 3.1.3 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sebastian,

Message replied to:

Date: Tue, 29 Jan 2013 22:32:53 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: jlmales@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Failure - 3.4.24


> On 01/28/2013 08:57 PM, John L. Males wrote:
> > I was not suggesting you are responsible for the bug at
> > all. On
> Okay then :)
> 
> > I have no custom patches to the kernel.
> okay. 
> 
> > I looked at the RedHat bug 468794.  The bug seems to
> > indicate it was never fixed.  The bug was reported against 
> > 2.6.27.4-47.rc3.fc10.i686 #1 on 2008-10-27 21:34:04 EDT and
> > was closed 2009-12-18 01:40:33 EST.  The differences are a
> > bug of at least 5 years ago and a 2.6 kernel verses 5 years
> > later and current at time stable kernel 3.4.24 from
> > kernel.org with no patches I applied when this kernel
> > failure I encountered occurred.  If this is the same bug
> > then there is a bug that may have been about for a while or
> > perhaps a regression.  The fact is the RedHat bug 468794
> > was never fixed.
> 
> Lets see. According to the backtrace it seems that the kernel
> was not able to write the buffer back to disk. The RH bug
> says that someone unplugged the device without an unmount of
> the disk.

Yes I read that someone unplugged the device without an unmount
of the device in the RedHat log.

> 
> My question are:
> - what were you doing by the time this happened?

I plugged the USB device into my laptop, then removed it.  There
was no user activity related to activity on the device.  If
there was activity, as opposed to user based activity, to
warrant the kernel needing to write a buffer to the USB flash
drive it was not a result of any user activity to the USB
drive.  Based on your findings in the back trace the kernel was
not able to write a buffer to the USB device from what happened
at the time.  I would be concerned that the kernel thought
there was a buffer to write when the user, which was me,
performed no activity upon the USB device.  The person who owns
the USB device knows next to nothing about computers, let alone
Windows or Linux, so I would be the only one performing any
actions related to the device.


> - can you reproduce it (reliably)?

No, I did try exactly what I did when the kernel failure
happened and sadly could not recreate the issue.  I know how
important that question is and tried a few times to cause the
problem.  I was hoping the kernel failure information would
have information indicating the cause of the failure.  I often
placed my system in hibernate such that my system will go a
month or bit more before I will reboot my kernel or to boot a
newly compiled kernel.  I know for a while in the early 3.2.x
releases doing so caused the kernel some issues and the system
would need to be rebooted or would just reboot on its own.
There are a number of variable to this.  I do not know if this
USB failure is an artifact of that often necessary practive I
have to place my system in hibernate almost daily, sometimes a
few times during the day.

As an FYI I had a full kernel opps a few 3.2.x versions ago.
It was my first one in years.  I was hoping there would be a
file of the information that displayed on the screen.  My
research after the kernel opps suggests one has to write down
the information on the screen from a kernel opps, which I did
not do as I did not think I would need to anymore.  The reason I
mention this is that kernel opps was with a USB device as
well.  The difference was it was a USB Wireless BGN device that
I have used many times over the last 12 months with a number
of 3.2.x kernels with no kernel opps/failure, just odd
functional issues that seem to resolve in later kernel
versions. The kernel opps that occurred with this Wireless BGN
device only occurred once with that exact older 3.2.x kernel
version and I have no clue why.  I have no information I know
of about that kernel opps that might help with this kernel
failure.  I did not know I needed to write down the screen from
the opps.  I therefore cannot provide the kernel opps
information that might share some common findings with the
kernel failure of this issue.  I suspect there may be nothing
in common, but without the kernel opps information we will not
know for certain. 

The USB device was a MP3 player that acts like a flash USB
drive when it is plugged into a computer.  This means one can
copy to/from, rename, delete files using the command line or
any file manager one uses.

> - Is this *new* meaning is there a kernel where did not
> happen?

I am not sure where the "new" reference you are referring to is
from.  That said, the only time this person's MP3 player/USB
flash was used was with the kernel.org 3.2.24 kernel I noted.

The only other USB problem I had was once with a USB Wireless
BGN device that has see alot of activity on my system and had
one opps on a 3.2.x kernel prior to 3.2.24 and again only once
on that kernel version. 

> 
> Sebastian

I know you know, but for those that do not, I am not on the
LKML.  It would be appreciated if I was copied in on any LKML
replies.

As always if there is more information or clarification needed
please ask.


Regards,

John L. Males
Toronto, Ontario
Canada
30 January 2013 13:58


==============================================================
2013-01-30 13:09:05.479017366-0500-EST

30 Jan 13:09:05 ntpdate[17854]: ntpdate 4.2.6p2@1.2194-o Sun
Oct 17 13:35:14 UTC 2010 (1)

30 Jan 13:09:32 ntpdate[17863]: step time server 142.4.209.106
offset -7.350323 sec

Linux 3.4.24-kernel.org-jlm-010-amd64 #1 SMP PREEMPT Sun Dec 23
10:06:41 EST 2012

Modified Debian GNU/Linux 6.0.3 (squeeze)
(Evaluating alternatives to Debian)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEJbUcACgkQ+V/XUtB6aBAh4ACeKQIM7vMWliG9iHpUfmhwQPKo
58sAoMiUS1AgNtfj0oBBPydcP60m3dyH
=8sUO
-----END PGP SIGNATURE-----
