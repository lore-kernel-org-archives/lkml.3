Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3J0RPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 13:15:35 -0400
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:45102
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685Ab3J0RPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 13:15:34 -0400
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.0 cv=D70fsYtj c=1 sm=1 a=rTb9Q+mClrhkGV9Ah9iRIA==:17
 a=jlPsK6Yxj2MA:10 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=xq3W2uTSAAAA:8
 a=N1CowNylAAAA:8 a=7NqCWP14w4AA:10 a=LxPcBZC12vJylu16ceMA:9 a=QEXdDO2ut3YA:10
 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
Message-ID: <1382897718.2598.37.camel@artifact>
Subject: Re: [PATCH] staging: Merge Crystal HD driver with linuxtv.org
From: Steven Newbury <steve@snewbury.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
        Manu Abraham <abraham.manu@gmail.com>
Date: Sun, 27 Oct 2013 18:15:18 +0000
In-Reply-To: <20131027162613.GA23822@kroah.com>
References: <1382891243.2598.10.camel@artifact>
	 <20131027155408.GA22705@kroah.com> <1382893938.2598.24.camel@artifact>
	 <20131027162613.GA23822@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-27 at 09:26 -0700, Greg KH wrote:
> On Sun, Oct 27, 2013 at 05:12:18PM +0000, Steven Newbury wrote:
> > > And these patches do a lot of new work to the driver, I'd rather see it
> > > get fixed up properly and moved out of staging first, before adding new
> > > support to it, otherwise why is it in staging at all?
> > 
> > That last part it a good question, it's been sitting there for 3 years,
> > I assume there are specific things that need improving to get it out of
> > staging?  Would the changes in this patch, without the support for new
> > hw support be sufficient to get that to happen?  I can't test it without
> > that support though...
> 
> See the TODO file for a list of things that need to be resolved.


> - Testing
I can do this for BCM70015 only, hopefully somebody else can test with other
hardware.

> - Cleanup return codes
Specifics?

> - Cleanup typedefs
For the existing staging driver, this one appears done to me.  For the new
code, I notice I've allowed a few to slip back in, I'll fix this.

> - Allocate an Accelerator device class specific Major number,
>   since we don't have any other open sourced accelerators, it is the only
>   one in that category for now.
>   A somewhat similar device is the DXR2/3
Is there a reason this hasn't happened?  (staging drivers don't get new major
numbers allocated?) Did nobody actually request a new class, or has there 
been no agreement on how to proceed?


> 
> I've been remiss in deleting some of the staging drivers lately, and
> this one was on my shortlist for removal, but if you have hardware for
> it, and want to adopt it, I'll gladly take the patches for getting your
> stuff to work if you are going to work toward getting it out of staging.
> 
I'll get it fixed up, I've an incentive to keep it working to keep my
wife happy! ;-) (It enables the network media box in our bedroom to work
with HD content without the fan screaming!)


