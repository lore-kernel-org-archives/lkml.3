Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaGBDLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 23:11:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:6639 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaGBDLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 23:11:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,586,1400050800"; 
   d="scan'208";a="556191004"
Date: Wed, 2 Jul 2014 08:41:19 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Belisko Marek <marek.belisko@gmail.com>
Subject: Re: Power Supply Subsystem Maintainer
Message-ID: <20140702031119.GA385@jenny-desktop>
References: <20140630111640.GA13774@jenny-desktop>
 <CAAfyv376J=oayov74bWdDmd+kDCwLJWAw5SMYRZGwbNP6rmEbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv376J=oayov74bWdDmd+kDCwLJWAw5SMYRZGwbNP6rmEbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton,

Appreciate your help to sort out the power supply maintainer issue. The
subsystem is not active after February 2014. No response from maintainer and the 
last commit on git://git.infradead.org/battery-2.6 was on 2014-02-01. Appreciate
your help.

-Jenny

On Mon, Jun 30, 2014 at 01:26:46PM +0200, Belisko Marek wrote:
> Same on my side (some pending patches) but there was already
> discussion: https://lkml.org/lkml/2014/5/16/504
> 
> On Mon, Jun 30, 2014 at 1:16 PM, Jenny Tc <jenny.tc@intel.com> wrote:
> > Hi all,
> >
> > I have few pending patches on power supply subsystem. So far I haven't seen
> > any response from the power supply maintainers. As per the MAINTAINERS entry,
> > the susbsystem is owned by "Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>".
> > But not sure he still maintains the susbsystem, as I don't see any response
> > from him. Also the last commit I could see on git://git.infradead.org/battery-2.6
> > is on Feb this year.  I would appreciate if anyone could clarify who really
> > maintains the power supply subsystem.
> >
> > Thanks
> > Jenny
> >
