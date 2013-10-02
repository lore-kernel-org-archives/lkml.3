Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3JBUoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:44:12 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50783 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3JBUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:44:10 -0400
Date: Wed, 2 Oct 2013 21:44:06 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Scott Wood <scottwood@freescale.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
Message-ID: <20131002204406.GE3029@lvm>
References: <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
 <20131002015355.GD63102@lvm>
 <1380681356.14271.57.camel@ul30vt.home>
 <20131002151413.GG63102@lvm>
 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
 <1380738758.12932.43.camel@snotra.buserror.net>
 <20131002184330.GC5108@cbox>
 <1380744842.12932.77.camel@snotra.buserror.net>
 <20131002202738.GC3029@lvm>
 <20131002203943.GB10871@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002203943.GB10871@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 01:39:43PM -0700, gregkh@linuxfoundation.org wrote:
> On Wed, Oct 02, 2013 at 09:27:38PM +0100, Christoffer Dall wrote:
> > > > What you're suggesting would let users specify that
> > > > a serial driver should handle a NIC hardware, no?  That sounds much much
> > > > worse to me.
> > > 
> > > The flag (and wildcard match, if applicable) would be set by the driver,
> > > not by the user.  Whereas PCI's "new_id" and the "new_compatible" being
> > > suggested in this thread would allow exactly that, assuming the driver
> > > doesn't reject the device in the probe function.
> > > 
> > ok, fair enough, but still, I don't see the _generic_ need for having a
> > kernel feature that allows some random driver to bind to a device, but
> > then again, I'm not an authority in this area.
> 
> Again, this is already there, and has been for years with no problems,
> so I really don't understand the issue you have with it.
> 
As I said, I'm not an authority, just sounded to me like we were trying
to build something very generic to solve a very specific case, but I
certainly don't want to invent problems that don't exist.

-Christoffer
