Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaGLB1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:27:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaGLB1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:27:08 -0400
Date: Fri, 11 Jul 2014 18:31:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH char-misc-next v3 2/8] misc: mic: add a bus driver for
 virtual MIC devices
Message-ID: <20140712013136.GA17540@kroah.com>
References: <cover.1405109401.git.sudeep.dutt@intel.com>
 <9f7cf168a23057b5a1a251f79e004bd449f9cb59.1405109402.git.sudeep.dutt@intel.com>
 <20140712012720.GA31863@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712012720.GA31863@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:27:20PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Jul 11, 2014 at 02:04:20PM -0700, Sudeep Dutt wrote:
> > This MIC virtual bus driver takes the responsibility of creating all
> > the virtual devices connected to the PCIe device on the host and the
> > platform device on the card. The MIC bus hardware operations provide
> > a way to abstract certain hardware details from the base physical devices.
> > Examples of devices added on the MIC virtual bus include host DMA and card DMA.
> > This abstraction enables using a common DMA driver on host and card.
> > 
> > Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
> > Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
> > Signed-off-by: Siva Yerramreddy <yshivakrishna@gmail.com>
> > ---
> >  drivers/misc/mic/Kconfig       |  17 ++++
> >  drivers/misc/mic/Makefile      |   1 +
> >  drivers/misc/mic/bus/Makefile  |   5 +
> >  drivers/misc/mic/bus/mic_bus.c | 218 +++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mic_bus.h        | 110 +++++++++++++++++++++
> >  5 files changed, 351 insertions(+)
> >  create mode 100644 drivers/misc/mic/bus/Makefile
> >  create mode 100644 drivers/misc/mic/bus/mic_bus.c
> >  create mode 100644 include/linux/mic_bus.h
> 
> Looks good, but no addition to scripts/mod/file2alias.c to allow
> autoloading of mic_bus drivers?
> 
> I'll take patches 1 and 2 here, as I need some acks from the DMA people
> on patch 3.

And I took 4-8 as well, as they seemed independant from patch 3.

thanks,

greg k-h
