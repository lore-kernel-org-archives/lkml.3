Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaKDONR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:13:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:18006 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaKDONP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:13:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616835508"
Date: Tue, 4 Nov 2014 16:12:23 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Timur Tabi <timur@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Message-ID: <20141104141223.GL1618@lahna.fi.intel.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
 <4832015.R1NooRni06@vostro.rjw.lan>
 <CACRpkdaZYubzEKVKiG4vCnh2kDr7CfRvaXcJNHSFtSUaRdXW4A@mail.gmail.com>
 <1905537.TSPKRBptT4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1905537.TSPKRBptT4@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 03:16:28PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 04, 2014 02:48:27 PM Linus Walleij wrote:
> > On Tue, Nov 4, 2014 at 2:31 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > > On Tuesday, November 04, 2014 11:39:07 AM Mika Westerberg wrote:
> > 
> > >> For reference the latest ACPI _DSD patches can be found here
> > >>
> > >> https://lkml.org/lkml/2014/10/21/762
> > >
> > > Actually, it's better to pull the device-properties branch:
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git device-properties
> > >
> > > because that contains the lastest changes.  It will be rebased in the future,
> > > though, so don't merge it into your "immutable" branches.
> > 
> > I've landed these two patches for v3.19, I guess we can wait for the
> > device properties to land properly upstream before proceeding
> > with ACPI support ...?
> 
> That would be reasonable IMO.

I agree.

Just wanted to let Timur know that we can support similar bindings in
ACPI world in the future.
