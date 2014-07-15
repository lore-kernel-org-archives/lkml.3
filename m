Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaGOPgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:36:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60137 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaGOPgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:36:16 -0400
Date: Tue, 15 Jul 2014 17:36:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: Re: linux-next: manual merge of the char-misc tree with the ia64 tree
Message-ID: <20140715153613.GA4775@pd.tnic>
References: <20140715164349.5807b892@canb.auug.org.au>
 <20140715134458.GB17795@kroah.com>
 <20140715134920.GC17795@kroah.com>
 <3908561D78D1C84285E8C5FCA982C28F3285CF7A@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3285CF7A@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 03:22:31PM +0000, Luck, Tony wrote:
> > Wait, do we really need a drivers/ras directory for one single driver?
> > Why not put it in drivers/misc/ instead?  A whole subdir at the top of
> > drivers seems overkill and odd.
> >
> > As it's a memory driver, what about drivers/firmware/ or drivers/edac/
> > or drivers/platform?
> 
> It isn't really a firmware driver, and definitely not an EDAC driver.
> 
> drivers/platform/x86 seems at least plausible.
> 
> Adding Boris as drivers/ras was his idea. I think he has plans
> for more stuff to go here.

Actually what I'd really like is to have a separate RAS subsystem where
we pull in all things RAS. Possibly arch-independent as I'm assuming
other arches would need RAS functionality at some point too.

Currently, all the stuff we're doing is x86-only so arch/x86/ras/ might
be a good place too, if other arches wanna do their own thing or if x86
RAS facilities turn out to be PITA to make arch-independent.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
