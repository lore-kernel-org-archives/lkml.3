Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaKLCBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:01:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:4396 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbaKLCBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:01:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,365,1413270000"; 
   d="scan'208";a="635413719"
Date: Tue, 11 Nov 2014 18:01:06 -0800
From: steph <stephanie.s.wallick@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Sean O. Stalley" <sean.stalley@intel.com>, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [V2 PATCH 03/10] added media agnostic (MA) data structures and
 handling
Message-ID: <20141112020106.GA2841@steph-desktop>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415671781-11351-3-git-send-email-stephanie.s.wallick@intel.com>
 <20141111043821.GD22068@kroah.com>
 <20141111224222.GB3415@sean.stalley.intel.com>
 <20141112011438.GA7216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112011438.GA7216@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:14:38AM +0900, Greg KH wrote:
> On Tue, Nov 11, 2014 at 02:42:22PM -0800, Sean O. Stalley wrote:
> > On Tue, Nov 11, 2014 at 01:38:21PM +0900, Greg KH wrote:
> > > On Mon, Nov 10, 2014 at 06:09:34PM -0800, Stephanie Wallick wrote:
> > > Yes, I am holding you to a higher standard than staging code normally
> > > is, and yes, it is purely because of the company you work for.  But I
> > > only do that because your company knows how to do this stuff right, and
> > > you have access to the resources and talent to help make this code
> > > right.  Other people and companies do not have the kind of advantage
> > > that you do.
> > 
> > We know we are fortunate to work for a company with so much talent and
> > resources and we don't mind being held to a higher standard. We have been
> > receiving multiple requests for our host driver and wanted to make it
> > available as soon as possible for others to use. We thought putting our
> > host driver into staging would be a good way to release it, but realize now
> > that it was premature. 
> 
> Does the code even work?  The number of basic mistakes in it seems to
> imply that it doesn't, but I could be mistaken.
> 

What is there works, but not everything in the MA USB Spec has been implemented
yet. 

> > We won't resubmit the driver until a senior kernel developer has signed off on it.
> 
> Good, go kick some of them and get them to review the code, _after_ at
> least addressing the issues that the community has raised, you don't
> want to waste their time finding the same things we just did :)
> 

Will do! We will most definitely fix the issues raised by the community before
having anyone else review the code. We appreciate everyone's time and feedback
:)


Thanks,
Stephanie
