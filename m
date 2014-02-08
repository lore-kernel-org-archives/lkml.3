Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaBHNG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 08:06:27 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:45416 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaBHNGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 08:06:25 -0500
MIME-Version: 1.0
In-Reply-To: <CA+O4pCKedNsBcLoVP6T0BHT6sq00D+XNHLT790UDgdx-r7TL4Q@mail.gmail.com>
References: <CA+O4pCJAL_Dqrt0mF5rbErBXbLTALx8Rrs1+vB3JmT=+rT0jCg@mail.gmail.com>
	<CA+O4pC+bHC1Bo4ERSfos8fL+FdnwXTTu_EE=rfd9eFkY7432Jg@mail.gmail.com>
	<CA+O4pCJ5xUQwRem3rvZbvv7K8BEnMW983Qq_vR0tVzwAwmVS6A@mail.gmail.com>
	<CA+O4pCJ9dFuwrcVF2b5MsreUb4NJX8t6664i3XHM9CYrdN7VzA@mail.gmail.com>
	<20140120193510.GC5545@xanatos>
	<CA+O4pC+inTZBSVJDBs4PfaDv0et3ZT+eN-1epThRJMztdgQryQ@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B8058@AcuExch.aculab.com>
	<CA+O4pCKedNsBcLoVP6T0BHT6sq00D+XNHLT790UDgdx-r7TL4Q@mail.gmail.com>
Date: Sat, 8 Feb 2014 14:06:24 +0100
Message-ID: <CA+O4pCJMN=Zpew_0c+nmoPGdSxKFk_x016StY1MKda4xcaxMXw@mail.gmail.com>
Subject: Re: [BUGREPORT] Linux USB 3.0
From: Markus Rechberger <mrechberger@gmail.com>
To: David Laight <David.Laight@aculab.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next one, just today (unfortunately it's in German):
http://support.sundtek.com/index.php/topic,1505.msg11020.html#msg11020

This guy is using Ubuntu with Linux 3.13.0-8-generic
The system seems to freeze completely after some time.
Since the driver is using the usbdevfs interface the problem is in the usbcore.

On Sat, Feb 8, 2014 at 10:00 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Tue, Feb 4, 2014 at 10:31 AM, David Laight <David.Laight@aculab.com> wrote:
>> From: Markus Rechberger
>>> >> Dec 27 23:23:50 solist kernel: [   36.118245] xhci_hcd 0000:00:14.0: ERROR Transfer event TRB DMA
>>> ptr
>>> >
>>> > These messages might be harmless.  The 3.0 kernel contains a fix for
>>> > Intel Panther Point xHCI hosts that suppresses those messages, commit
>>> > ad808333d8201d53075a11bc8dd83b81f3d68f0b "Intel xhci: Ignore spurious
>>> > successful event."
>>> >
>>> > A later commit extends that to all xHCI 1.0 hosts, commit
>>> > 07f3cb7c28bf3f4dd80bfb136cf45810c46ac474 "usb: host: xhci: Enable
>>> > XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0"  That was
>>> > queued for 3.11 and marked to be backported into stable kernels as old
>>> > as 3.0.
>>
>> I see the same error message on the 0.96 ASMedia controller when
>> the rx buffers for the ax88179_178a driver cross 64k boundaries.
>>
>> So this isn't confined to 1.0 controllers.
>>
>
> Sarah,
>
> since there is no response yet, is there anyone at Intel dedicated at
> working on USB 3.0?
> We are also getting more and more negative USB 3.0 feedback with Linux
>
> Best Regards,
> Markus
