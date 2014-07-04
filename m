Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbaGDRj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:39:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaGDRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:39:27 -0400
Date: Fri, 4 Jul 2014 10:39:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] GenWQE: patches to improve RAS features (v2)
Message-ID: <20140704173910.GD25992@kroah.com>
References: <1403713327-27976-1-git-send-email-klebers@linux.vnet.ibm.com>
 <1403772933.25754.1.camel@oc7383187364.ibm.com>
 <1404459427.11076.2.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404459427.11076.2.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 09:37:07AM +0200, Frank Haverkamp wrote:
> Hi Greg,
> 
> Am Donnerstag, den 26.06.2014, 10:55 +0200 schrieb Frank Haverkamp:
> > Hi Kleber,
> > 
> > Am Mittwoch, den 25.06.2014, 13:22 -0300 schrieb Kleber Sacilotto de
> > Souza:
> > > Hi,
> > > 
> > > I'm sending a v2 of this patch series, removing the patch that bumps the
> > > driver version number, and including a trivial one that removes an unnecessary
> > > include.
> > > 
> > > Kleber Sacilotto de Souza (4):
> > >   GenWQE: Add sysfs interface for bitstream reload
> > >   GenWQE: Add support for EEH error recovery
> > >   GenWQE: Improve hardware error recovery
> > >   GenWQE: Remove unecessary include
> > > 
> > >  Documentation/ABI/testing/sysfs-driver-genwqe |    9 +
> > >  drivers/misc/genwqe/Kconfig                   |    6 +
> > >  drivers/misc/genwqe/card_base.c               |  215 +++++++++++++++++++++++--
> > >  drivers/misc/genwqe/card_base.h               |    2 +
> > >  drivers/misc/genwqe/card_ddcb.c               |   24 +++-
> > >  drivers/misc/genwqe/card_debugfs.c            |    7 +
> > >  drivers/misc/genwqe/card_dev.c                |    5 +
> > >  drivers/misc/genwqe/card_sysfs.c              |   25 +++
> > >  drivers/misc/genwqe/card_utils.c              |   10 ++
> > >  include/uapi/linux/genwqe/genwqe_card.h       |    1 +
> > >  10 files changed, 285 insertions(+), 19 deletions(-)
> > > 
> > 
> > Thanks for resubmitting the patches.
> > 
> > Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
> > 
> 
> ping. Do you already have an idea when you might find the time to review
> Klebers patches?

When I return from vacation on Monday I will start to work on my very
large backlog of patches...

thanks,

greg k-h
