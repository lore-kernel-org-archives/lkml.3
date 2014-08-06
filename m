Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaHFM2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:28:23 -0400
Received: from imap.hinterhof.net ([80.69.43.37]:48442 "EHLO
	imap.hinterhof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaHFM2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:28:22 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 08:28:21 EDT
Date: Wed, 6 Aug 2014 14:22:10 +0200
From: Max Vozeler <max@vozeler.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Valentina Manea <valentina.manea.m@gmail.com>, tulinizer@gmail.com,
        stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        f.manzan@gmail.com, kurt@garloff.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com, MHoffman@luxotticaretail.com
Subject: Re: [PATCH 0/3] usbip: move usbip out of staging
Message-ID: <20140806122210.GC4763@x201t.vpn.hinterhof.net>
References: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
 <20140318203324.GA25579@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318203324.GA25579@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Tue, Mar 18, 2014 at 01:33:24PM -0700, Greg KH wrote:
> On Tue, Mar 18, 2014 at 10:11:20PM +0200, Valentina Manea wrote:
> > After migrating userspace code to libudev, converting usbip-host
> > to a device driver and various bug fixes and enhancements, USB/IP
> > is fully functional and can be moved out of staging.
> > 
> > This patch series moves it as following:
> > * userspace code to tools/usb/usbip
> > * kernel code to drivers/usb/usbip
> > 
> > Besides this, a warning generated in the kernel code is solved.
> 
> Like Joe said, use -M please.
> 
> Also, I'm not going to be able to do this until after 3.15-rc1 is out,
> due to changes to this code base in multiple trees.
> 
> So can you resend when -rc1 is out?

What happened to this series, should it be resent?

Do people agree that usbip is ready to migrate out of staging in
general?

The README lists these TODO items:

        - more discussion about the protocol
        - testing
        - review of the userspace interface
        - document the protocol

The protocol has been documented and discussed in some depth. Not
everybody seems to love it yet I don't think any significant flaws
have been shown in the protocol.

There can always be more testing. :)

That leaves the userspace interface. Is it good enough to be made
official?

If so it should probably be added to Documentation/ABI.

Thanks,

	Max
