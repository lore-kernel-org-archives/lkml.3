Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122Ab3ECCCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 22:02:51 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55873 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945Ab3ECCCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 22:02:49 -0400
Date: Thu, 2 May 2013 19:00:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: linasvepstas@gmail.com, "Zhang, LongX" <longx.zhang@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Joseph.Liu@Emulex.Com" <Joseph.Liu@emulex.com>
Subject: Re: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
Message-ID: <20130503020039.GA29087@kroah.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <1367454625.2093.6.camel@ymzhang.sh.intel.com>
 <CAHrUA34H_B-ffebx6ueHgV1ax-PL_3hLZr1JGaP2NJZ7bYgvtw@mail.gmail.com>
 <1367541180.2093.10.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367541180.2093.10.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 08:33:00AM +0800, Yanmin Zhang wrote:
> On Wed, 2013-05-01 at 20:20 -0500, Linas Vepstas wrote:
> > Hi,
> > 
> > On 1 May 2013 19:30, Yanmin Zhang <yanmin_zhang@linux.intel.com>
> > wrote:
> >         On Fri, 2013-04-26 at 06:28 +0000, Zhang, LongX wrote:
> >         > From: Zhang Long <longx.zhang@intel.com>
> >         >
> >         > Specific pci device drivers might have many functions to
> >         call
> >         > pci_channel_offline to check device states. When slot_reset
> >         happens,
> >         > drivers' slot_reset callback might call such functions and
> >         eventually
> >         > abort the reset.
> >         >
> >         > The patch resets pdev->error_state to pci_channel_io_normal
> >         at
> >         > the begining of report_slot_reset.
> >         >
> >         > Thank Liu Joseph for pointing it out.
> >         
> >         Linas, Bjorn,
> >         
> >         Would you like to merge the patch to your testing tree?
> >         The patch resolves one issue pointed out by Joseph.
> > 
> > 
> > I'm not maintaining a tree at this time, and am not able to test.
> > Sorry.
> Thanks Linas.
> 
> Greg,
> 
> Would you like to merge it into your testing tree? Joseph Liu tested
> the patch and it does work.

You do know about the scripts/get_maintainer.pl script, right?

Hint, try it out :)
