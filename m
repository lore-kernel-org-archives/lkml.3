Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbbAEXGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:06:41 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:52559 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbbAEXGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:06:39 -0500
Message-ID: <1420499197.14308.45.camel@x220>
Subject: Re: [PATCH] kconfig: use bool instead of boolean for type
 definition attributes
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Jaeger <cj@linux.com>
Cc: yann.morin.1998@free.fr, akpm@linux-foundation.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dborkman@redhat.com, Michal Marek <mmarek@suse.cz>
Date: Tue, 06 Jan 2015 00:06:37 +0100
In-Reply-To: <20150105194305.GB1513@betelgeuse.hsd1.ma.comcast.net>
References: <1419108071-11607-1-git-send-email-cj@linux.com>
	 <20150105194305.GB1513@betelgeuse.hsd1.ma.comcast.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2015 23:06:37.0211 (UTC) FILETIME=[41C76EB0:01D0293C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 14:43 -0500, Christoph Jaeger wrote:
> (adding Michal Marek)

Yann added no commits in 2014. And I actually think Yann reacted to
almost no patches last year. Perhaps none at all. What's going on?

> On Sat, Dec 20, 2014 at 03:41:11PM -0500, Christoph Jaeger wrote:
> > Support for keyword 'boolean' will be dropped later on.
> > 
> > No functional change.
> > 
> > Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
> > Signed-off-by: Christoph Jaeger <cj@linux.com>
> > ---
> >  arch/mips/pmcs-msp71xx/Kconfig      |  6 +++---
> >  drivers/connector/Kconfig           |  2 +-
> >  drivers/hwmon/Kconfig               |  2 +-
> >  drivers/hwmon/pmbus/Kconfig         |  2 +-
> >  drivers/i2c/Kconfig                 |  4 ++--
> >  drivers/iio/Kconfig                 |  4 ++--
> >  drivers/isdn/hardware/mISDN/Kconfig |  2 +-
> >  drivers/md/Kconfig                  |  4 ++--
> >  drivers/md/persistent-data/Kconfig  |  2 +-
> >  drivers/net/ethernet/ti/Kconfig     |  4 ++--
> >  drivers/net/usb/Kconfig             | 12 ++++++------
> >  drivers/net/wireless/rt2x00/Kconfig |  6 +++---
> >  drivers/pci/pcie/aer/Kconfig        |  2 +-
> >  drivers/rtc/Kconfig                 |  8 ++++----
> >  drivers/spi/Kconfig                 |  6 +++---
> >  drivers/staging/board/Kconfig       |  2 +-
> >  drivers/staging/emxx_udc/Kconfig    |  2 +-
> >  drivers/staging/iio/Kconfig         |  4 ++--
> >  drivers/tty/serial/Kconfig          |  2 +-
> >  drivers/usb/gadget/Kconfig          | 34 +++++++++++++++++-----------------
> >  drivers/usb/gadget/legacy/Kconfig   |  2 +-
> >  drivers/usb/gadget/udc/Kconfig      |  4 ++--
> >  drivers/usb/phy/Kconfig             |  2 +-
> >  init/Kconfig                        |  4 ++--
> >  lib/Kconfig                         | 30 +++++++++++++++---------------
> >  mm/Kconfig                          | 22 +++++++++++-----------
> >  net/Kconfig                         | 14 +++++++-------
> >  net/sched/Kconfig                   |  2 +-
> >  net/switchdev/Kconfig               |  2 +-
> >  security/integrity/Kconfig          |  4 ++--
> >  security/integrity/evm/Kconfig      |  2 +-
> >  31 files changed, 99 insertions(+), 99 deletions(-)

A quick grep, after applying this patch onto next-20150105, only showed
two remaining uses of "boolean". Both were in kernel/livepatch/Kconfig.
I assume that file was added after this patch was submitted. So that's
fine.
 

Paul Bolle

