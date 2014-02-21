Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaBUCSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:18:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaBUCSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:18:35 -0500
Date: Thu, 20 Feb 2014 18:21:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI
 specified resources
Message-ID: <20140221022113.GA28043@kroah.com>
References: <1392939912-7446-1-git-send-email-kys@microsoft.com>
 <20140220234702.GA28682@kroah.com>
 <357c655260924e10b157020ebe47b89f@BY2PR03MB299.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <357c655260924e10b157020ebe47b89f@BY2PR03MB299.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:19:22AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, February 20, 2014 3:47 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in getting ACPI specified
> > resources
> > 
> > On Thu, Feb 20, 2014 at 03:45:12PM -0800, K. Y. Srinivasan wrote:
> > > Fix a bug in the resource walking code.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > ---
> > >  drivers/hv/vmbus_drv.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > Fails to apply to my char-misc-next branch (if you want it in
> > 3.14-final, that's where it belongs...):
> > 	checking file drivers/hv/vmbus_drv.c
> > 	Hunk #1 FAILED at 899.
> > 	1 out of 1 hunk FAILED
> 
> Greg,
> 
> This patch is based on this commit:
> 
> commit 90f3453585479d5beb75058da46eb573ced0e6ac
> 
>     Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I just got your char-misc-next branch and it does not have the needed commit.

Then I guess this isn't 3.14-final material, right?

Please resend it when you have determined which branch it should go
into, it's out of my queue now.

greg k-h
