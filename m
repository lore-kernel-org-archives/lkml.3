Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab3BMJjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:39:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:25341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab3BMJjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:39:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,655,1355126400"; 
   d="scan'208";a="290504801"
Date: Wed, 13 Feb 2013 10:39:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>, "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 01/12 v3] mei: Rename mei_device to mei_host
Message-ID: <20130213093907.GM20996@sortiz-mobl>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
 <20130212212935.GJ20996@sortiz-mobl>
 <20130212213823.GA20745@kroah.com>
 <201302122309.01176.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302122309.01176.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 11:09:00PM +0000, Arnd Bergmann wrote:
> On Tuesday 12 February 2013, gregkh@linuxfoundation.org wrote:
> > > 
> > > > Please let's find something that makes both hw and Linux happy
> > > I still believe it makes sense to use mei_device for what we add to the MEI
> > > bus. I'd be fine with mei_bus_device as well, but that would somehow look
> > > a bit awkward. Greg, Arnd, any preference ?
> > 
> > "mei_device" works the best for me.  Tomas, what you think of as a "MEI
> > Device" really is a "MEI Controller", it bridges the difference between
> > the PCI bus and your new MEI bus, so you will need to start thinking of
> > these things a bit differently now that you have created your own little
> > virtual bus.
> 
> Yes, I agree. mei_bus_device would also work as the name for the controller,
> but not for the devices attached to it IMO.
Tomas, I propose to switch to mei_controller instead of mei_host and keep the
mei_device name for the devices we attach to the MEI bus.
Does that work for you ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
