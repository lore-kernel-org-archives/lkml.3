Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaKDSDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:03:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaKDSC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:02:59 -0500
Date: Tue, 4 Nov 2014 10:02:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: sostalle <sean.stalley@intel.com>
Cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 10/10] added kernel build, configuration, and TODO files
Message-ID: <20141104180258.GB3940@kroah.com>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-11-git-send-email-stephanie.s.wallick@intel.com>
 <20141103212404.GD7379@kroah.com>
 <54591319.c3b5440a.7374.5f85SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54591319.c3b5440a.7374.5f85SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:55:19AM -0800, sostalle wrote:
> >On Mon, Nov 03, 2014 at 01:24:04PM -0800, Greg KH wrote:
> >>On Mon, Nov 03, 2014 at 12:42:57PM -0800, Stephanie Wallick wrote:
> >> --- /dev/null
> >> +++ b/drivers/staging/mausb/TODO
> >> @@ -0,0 +1,14 @@
> >> +TODO:
> >> +	- checkpatch.pl cleanups
> >
> >Is this still true?
> >
> 
> checkpatch.pl reports:
> total: 7 errors, 208 warnings, 10489 lines checked

Ok, fair enough.

> >And why does this need to be a staging driver?  What's wrong with making
> >it a "real" driver now?
> >
> 
> The short answer is: We don't think it's ready to be "real".
> 
> We didn't want to release it as a "real" driver because:
> 	- It's not stable enough yet.
> 	- It doesn't implement all the features required by the MA USB spec.
> 	- The MA USB spec isn't standalone. It requires a supplemental spec
> 	  to define media-specific behavior, like how MA USB packets are
> 	  encapsulated, how to discover MA USB devices on a network, etc.
> 	  So far, no media-specific specifications have been published.
> 	- There are no commercially-available Media Agnostic USB devices.
> 
> We wanted to release it to staging now because:
> 	- We have received requests from multiple companies for our host MA USB
> 	  driver. Putting it in staging seemed the best way to distribute it.
> 	- We feel that releasing what we have to staging now could promote
> 	  collaboration on one driver & help prevent duplicate work.

Ok, please include that information in the first email, it's much more
helpful :)

Can you resend this series, and cc: the linux-usb mailing list, and
address the "what about usbip?" questions as well?

thanks,

greg k-h
