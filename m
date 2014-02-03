Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaBCOyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:54:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35747 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaBCOyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:54:40 -0500
Date: Mon, 3 Feb 2014 15:54:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: 3.13.0: crash on boot
Message-ID: <20140203145438.GA4281@pd.tnic>
References: <20140131083707.GA9968@oktetlabs.ru>
 <CAErSpo6PaX2BcTqF4GD5ez3wDaPizUCNZJEjy_5EozAd3epoaA@mail.gmail.com>
 <20140203144120.GA15384@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140203144120.GA15384@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 02:41:20PM +0000, Matt Fleming wrote:
> On Fri, 31 Jan, at 11:29:39AM, Bjorn Helgaas wrote:
> > [+cc Matt and Matthew; maybe EFI related?]
>  
> (Pulling in Borislav too)
> 
> Yeah, looks EFI related.
> 
> > On Fri, Jan 31, 2014 at 1:37 AM, Alexandra N. Kossovsky
> > <Alexandra.Kossovsky@oktetlabs.ru> wrote:
> > > Hello.
> > >
> > > I've got 3.13.0 kernel creshed on boot.  A lot of debug options are on.
> > > Crash:
> > > BUG: unable to handle kernel paging request at 000000012a53f020
> > > IP: [<00000000cf038cc6>] 0xcf038cc6
> > > PGD 2962067 PUD 2965067 PMD 12fe8f067 PTE 800000012a53f962
> > > Oops: 0000 [#1] SMP
> > > Modules linked in:
> > > CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-debug-amd64 #2
> > > Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0b 09/17/2012

Also, if you have a BIOS update for your box, that could be worth
another try.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
