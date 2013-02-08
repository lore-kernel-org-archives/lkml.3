Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947011Ab3BHUXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:23:48 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:62583 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946902Ab3BHUXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:23:47 -0500
Date: Fri, 8 Feb 2013 12:23:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        jkosina@suse.cz, jslaby@suse.cz, khali@linux-fr.org,
        mchehab@redhat.com, perex@perex.cz, sameo@linux.intel.com,
        tiwai@suse.de, w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH 08/15] drivers/misc/cb710: add missing GENERIC_HARDIRQS
 dependency
Message-ID: <20130208202343.GA20690@kroah.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
 <1360167843-3587-9-git-send-email-heiko.carstens@de.ibm.com>
 <20130208202300.GA20633@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208202300.GA20633@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 12:23:00PM -0800, Greg KH wrote:
> On Wed, Feb 06, 2013 at 05:23:56PM +0100, Heiko Carstens wrote:
> > CB710_CORE (drivers/misc/cb710/core.c) calls devm_request_irq() and
> > therefore needs a GENERIC_HARDIRQS dependency to prevent a link
> > error on s390.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > ---
> >  drivers/misc/cb710/Kconfig |    2 +-
> >  drivers/mmc/host/Kconfig   |    2 +-
> 
> I've deleted the drivers/mmc/ portion of this patch, as I don't think
> you ment to include it in this one.

Nevermind, it is needed, I put it back...

