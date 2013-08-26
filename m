Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3HZTOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:14:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:28154 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab3HZTOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,961,1367996400"; 
   d="scan'208";a="393651564"
Date: Mon, 26 Aug 2013 12:14:11 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Message-ID: <20130826191411.GG5112@xanatos>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
 <20130821184042.GC3577@xanatos>
 <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
 <20130822004514.GB19747@xanatos>
 <CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 05:11:49AM +0000, Paul Zimmerman wrote:
> > From: Julius Werner
> > Sent: Wednesday, August 21, 2013 9:22 PM
> > 
> > > You need the USB 2.0 spec errata from 2011-11 that describes the changes
> > > made for BESL as well.  It's in the USB2-LPM-Errata-final.pdf and
> > > USB2_LinkPowerMangement_ECN[final].pdf files in this zip file:
> > >
> > > http://www.usb.org/developers/docs/usb_20_070113.zip
> > >
> > > I agree though, it's all a confusing mess for documentation on USB 2.0
> > > Link PM.
> > 
> > Thanks, I hadn't found that first one yet. Do you also have a link for
> > the updated XHCI specification or a separate erratum document
> > describing the PORTHLPMC register referenced in the BESL patches (they
> > don't exist on DWC3, but I'm still curious)?
> 
> Just to set the record straight :)
> 
> The PORTHLPMC registers do exist on DWC3, starting with the 1.90a version
> of the core or thereabouts. They only supported the HIRD flavor of LPM,
> though. Only fairly recently has support for BESL been added, around
> version 2.41a or so.

And the 2.41a version that supports BESL properly sets the BLC flag in
the USB 2.0 Protocol extended capabilities for all the USB 2.0 ports?
Has this functionality been well-tested?

Sarah Sharp
