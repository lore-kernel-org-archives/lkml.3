Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaHDQqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:46:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:46284 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaHDQqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:46:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,799,1400050800"; 
   d="scan'208";a="583219156"
Date: Mon, 4 Aug 2014 09:46:33 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, "Nyman, Mathias" <mathias.nyman@intel.com>
Subject: Re: Kernel Debugging Support
Message-ID: <20140804164633.GA28436@xanatos>
References: <CAPDOMVj5nifG8VQBB_UzNESBc+arxpCQ5sEOAYdb6Rr-KkDSHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVj5nifG8VQBB_UzNESBc+arxpCQ5sEOAYdb6Rr-KkDSHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 12:47:59AM -0400, Nick Krause wrote:
> Hey Sharp,

Hi Krause,

Please Cc the new xHCI driver maintainer, Mathias Nyman.  I'm officially
retired from USB development and have moved onto other projects. :)

> After reading around seems people want support for usb debugging in
> kgdb or other usb based solutions.

Yes, early boot USB debug over xHCI has been a low-priority feature
request.

Unfortunately, USB debug is an optional feature for xHCI host
controllers, so many of them don't have USB debug ports.  Even if it is
included, the USB debug ports are often either routed to internal USB
ports or not exposed on the board altogether.  Since it's not widely
available, it's not a high priority to implement.

> If you and the other developers are able to help me out a bit as I am
> new I can definitively write this
> area of kgdb support.

The kgdb support is all there.  It's the xHCI host controller driver
debug port support that is needed.

Hmm, I only see one commit from your email address in Greg's tree.  I
think you should work on some smaller clean ups and bug fixes, and get
some more patches into mainline before you go on to tackle a larger
feature like this.  Perhaps Mathias has a smaller task that would be
good for you to tackle?

There's a good tutorial here on how to create a kernel patch, and
respond properly to patch review and rework requests:

http://kernelnewbies.org/OPWfirstpatch

And here's my personal philosophy on how to create a patchset:

http://sarah.thesharps.us/2013/05/08/patchsets-for-dinner/

> Regards Nick
> P.S. If  you want Sharp I can change the commit message on my other
> commit you didn't like if me or you
> talk to Greg in order to remove in from mainline, if no that's OK too.

I don't understand what the above sentence means.  What commit message
are you referencing?  What do you mean by "remove in from mainline"?

Try again?

Sarah Sharp
