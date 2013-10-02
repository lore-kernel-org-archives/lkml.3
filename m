Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JBUhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:37:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3JBUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:37:23 -0400
Date: Wed, 2 Oct 2013 13:37:35 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Christoffer Dall <christoffer.dall@linaro.org>
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
Message-ID: <20131002203735.GA10871@kroah.com>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
 <20131001200054.GA27330@kroah.com>
 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
 <20131002015355.GD63102@lvm>
 <1380681356.14271.57.camel@ul30vt.home>
 <20131002151413.GG63102@lvm>
 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
 <1380738758.12932.43.camel@snotra.buserror.net>
 <20131002184330.GC5108@cbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002184330.GC5108@cbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:43:30AM -0700, Christoffer Dall wrote:
> > What's wrong with a non-vfio-specific flag that a driver can set, that
> > indicates that the driver is willing to try to bind to any device on the
> > bus if explicitly requested via the existing sysfs bind mechanism?
> > 
> It sounds more hackish to me to invent some 'generic' flag to solve a
> very specific case.  What you're suggesting would let users specify that
> a serial driver should handle a NIC hardware, no?  That sounds much much
> worse to me.

You can do that today, with any PCI driver (or USB driver as well), just
use the bind/unbind files in sysfs and you had better "know" what you
are doing...

