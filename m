Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbbAFArP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 19:47:15 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52165 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300AbbAFArO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 19:47:14 -0500
X-Sasl-enc: +OqSw25LSXFCCLYZd3RCXzfGPlFSE3+4EI2Mtg5R2Qv1 1420505233
Date: Mon, 5 Jan 2015 19:47:13 -0500
From: Christoph Jaeger <cj@linux.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: yann.morin.1998@free.fr, akpm@linux-foundation.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dborkman@redhat.com, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] kconfig: use bool instead of boolean for type definition
 attributes
Message-ID: <20150106004713.GD1513@betelgeuse.hsd1.ma.comcast.net>
References: <1419108071-11607-1-git-send-email-cj@linux.com>
 <20150105194305.GB1513@betelgeuse.hsd1.ma.comcast.net>
 <1420499197.14308.45.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420499197.14308.45.camel@x220>
X-Homepage: http://christophjaeger.info
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 12:06:37AM +0100, Paul Bolle wrote:
> On Mon, 2015-01-05 at 14:43 -0500, Christoph Jaeger wrote:
> > (adding Michal Marek)
> 
> Yann added no commits in 2014. And I actually think Yann reacted to
> almost no patches last year. Perhaps none at all. What's going on?

Dunno, but at least Michal seems to be up and running.

> > On Sat, Dec 20, 2014 at 03:41:11PM -0500, Christoph Jaeger wrote:
> > > Support for keyword 'boolean' will be dropped later on.
> > > 
> > > No functional change.
> > > 
> > > Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
> > > Signed-off-by: Christoph Jaeger <cj@linux.com>
> > > ---
> > >  arch/mips/pmcs-msp71xx/Kconfig      |  6 +++---
> > >  drivers/connector/Kconfig           |  2 +-
> > >  drivers/hwmon/Kconfig               |  2 +-
> > >  drivers/hwmon/pmbus/Kconfig         |  2 +-
> > >  drivers/i2c/Kconfig                 |  4 ++--
> > >  drivers/iio/Kconfig                 |  4 ++--
> > >  drivers/isdn/hardware/mISDN/Kconfig |  2 +-
> > >  drivers/md/Kconfig                  |  4 ++--
> > >  drivers/md/persistent-data/Kconfig  |  2 +-
> > >  drivers/net/ethernet/ti/Kconfig     |  4 ++--
> > >  drivers/net/usb/Kconfig             | 12 ++++++------
> > >  drivers/net/wireless/rt2x00/Kconfig |  6 +++---
> > >  drivers/pci/pcie/aer/Kconfig        |  2 +-
> > >  drivers/rtc/Kconfig                 |  8 ++++----
> > >  drivers/spi/Kconfig                 |  6 +++---
> > >  drivers/staging/board/Kconfig       |  2 +-
> > >  drivers/staging/emxx_udc/Kconfig    |  2 +-
> > >  drivers/staging/iio/Kconfig         |  4 ++--
> > >  drivers/tty/serial/Kconfig          |  2 +-
> > >  drivers/usb/gadget/Kconfig          | 34 +++++++++++++++++-----------------
> > >  drivers/usb/gadget/legacy/Kconfig   |  2 +-
> > >  drivers/usb/gadget/udc/Kconfig      |  4 ++--
> > >  drivers/usb/phy/Kconfig             |  2 +-
> > >  init/Kconfig                        |  4 ++--
> > >  lib/Kconfig                         | 30 +++++++++++++++---------------
> > >  mm/Kconfig                          | 22 +++++++++++-----------
> > >  net/Kconfig                         | 14 +++++++-------
> > >  net/sched/Kconfig                   |  2 +-
> > >  net/switchdev/Kconfig               |  2 +-
> > >  security/integrity/Kconfig          |  4 ++--
> > >  security/integrity/evm/Kconfig      |  2 +-
> > >  31 files changed, 99 insertions(+), 99 deletions(-)
> 
> A quick grep, after applying this patch onto next-20150105, only showed
> two remaining uses of "boolean". Both were in kernel/livepatch/Kconfig.
> I assume that file was added after this patch was submitted. So that's
> fine.

Yes. Since livepatch is supposed to get merged not until 3.20, I'll submit a
separate patch to the livepatch folks in order to get rid of these.

~Christoph
