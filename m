Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaGDHhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:37:16 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:60345 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaGDHhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:37:13 -0400
Subject: Re: [PATCH 0/4] GenWQE: patches to improve RAS features (v2)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
In-Reply-To: <1403772933.25754.1.camel@oc7383187364.ibm.com>
References: <1403713327-27976-1-git-send-email-klebers@linux.vnet.ibm.com>
	 <1403772933.25754.1.camel@oc7383187364.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 04 Jul 2014 09:37:07 +0200
Message-ID: <1404459427.11076.2.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070407-8372-0000-0000-0000006D8ED3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Donnerstag, den 26.06.2014, 10:55 +0200 schrieb Frank Haverkamp:
> Hi Kleber,
> 
> Am Mittwoch, den 25.06.2014, 13:22 -0300 schrieb Kleber Sacilotto de
> Souza:
> > Hi,
> > 
> > I'm sending a v2 of this patch series, removing the patch that bumps the
> > driver version number, and including a trivial one that removes an unnecessary
> > include.
> > 
> > Kleber Sacilotto de Souza (4):
> >   GenWQE: Add sysfs interface for bitstream reload
> >   GenWQE: Add support for EEH error recovery
> >   GenWQE: Improve hardware error recovery
> >   GenWQE: Remove unecessary include
> > 
> >  Documentation/ABI/testing/sysfs-driver-genwqe |    9 +
> >  drivers/misc/genwqe/Kconfig                   |    6 +
> >  drivers/misc/genwqe/card_base.c               |  215 +++++++++++++++++++++++--
> >  drivers/misc/genwqe/card_base.h               |    2 +
> >  drivers/misc/genwqe/card_ddcb.c               |   24 +++-
> >  drivers/misc/genwqe/card_debugfs.c            |    7 +
> >  drivers/misc/genwqe/card_dev.c                |    5 +
> >  drivers/misc/genwqe/card_sysfs.c              |   25 +++
> >  drivers/misc/genwqe/card_utils.c              |   10 ++
> >  include/uapi/linux/genwqe/genwqe_card.h       |    1 +
> >  10 files changed, 285 insertions(+), 19 deletions(-)
> > 
> 
> Thanks for resubmitting the patches.
> 
> Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
> 

ping. Do you already have an idea when you might find the time to review
Klebers patches?

Thanks

Frank

