Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaHFOqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:46:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaHFOq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:46:29 -0400
Date: Wed, 6 Aug 2014 07:45:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Max Vozeler <max@vozeler.com>
Cc: Valentina Manea <valentina.manea.m@gmail.com>, tulinizer@gmail.com,
        stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        f.manzan@gmail.com, kurt@garloff.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com, MHoffman@luxotticaretail.com
Subject: Re: [PATCH 0/3] usbip: move usbip out of staging
Message-ID: <20140806144556.GC14247@kroah.com>
References: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
 <20140318203324.GA25579@kroah.com>
 <20140806122210.GC4763@x201t.vpn.hinterhof.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806122210.GC4763@x201t.vpn.hinterhof.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 02:22:10PM +0200, Max Vozeler wrote:
> Hi everyone,
> 
> On Tue, Mar 18, 2014 at 01:33:24PM -0700, Greg KH wrote:
> > On Tue, Mar 18, 2014 at 10:11:20PM +0200, Valentina Manea wrote:
> > > After migrating userspace code to libudev, converting usbip-host
> > > to a device driver and various bug fixes and enhancements, USB/IP
> > > is fully functional and can be moved out of staging.
> > > 
> > > This patch series moves it as following:
> > > * userspace code to tools/usb/usbip
> > > * kernel code to drivers/usb/usbip
> > > 
> > > Besides this, a warning generated in the kernel code is solved.
> > 
> > Like Joe said, use -M please.
> > 
> > Also, I'm not going to be able to do this until after 3.15-rc1 is out,
> > due to changes to this code base in multiple trees.
> > 
> > So can you resend when -rc1 is out?
> 
> What happened to this series, should it be resent?

Well, nothing is going to happen unless it is, so if you want to see it
merged, I suggest redoing it and resending it :)

thanks,

greg k-h
