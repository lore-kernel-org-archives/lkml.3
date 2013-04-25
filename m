Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab3DYPty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:49:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39210 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758511Ab3DYPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:49:52 -0400
Date: Thu, 25 Apr 2013 11:49:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sedat Dilek <sedat.dilek@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 24 [ PM: Device 1-1.2 failed to resume
 async: error -32 ]
In-Reply-To: <CA+icZUX96ADfV5rxce+2t4J870BvZTPGOCCSgVcJ8_Hc2RMxeg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1304251145110.948-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Sedat Dilek wrote:

> [ Run logging on USB-bus #1 ]
> 
> # cat /sys/kernel/debug/usb/usbmon/1u > /tmp/usbmon-1u.txt <--- USB-bus #01
> 
> [ Do suspend plus resume ]
> 
> ...
> 
> [ Check /tmp/usbmon-1u.txt file ]
> 
> ...
> 
> File attached!

That also looks normal.  Did you have CONFIG_USB_DEBUG enabled during 
this test?  If you did, you could try turning it back off to see if the 
original problem returns while still doing a usbmon trace.

Alan Stern

