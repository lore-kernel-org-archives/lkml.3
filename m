Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaBGRm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:42:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33003 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaBGRmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:42:25 -0500
Date: Fri, 7 Feb 2014 18:42:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Cc: Matt Fleming <matt@console-pimps.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: 3.13.0: crash on boot
Message-ID: <20140207174219.GA17003@pd.tnic>
References: <20140131083707.GA9968@oktetlabs.ru>
 <CAErSpo6PaX2BcTqF4GD5ez3wDaPizUCNZJEjy_5EozAd3epoaA@mail.gmail.com>
 <20140203144120.GA15384@console-pimps.org>
 <20140204133046.GA24536@oktetlabs.ru>
 <20140205013206.GA5711@pd.tnic>
 <20140207090043.GB24536@oktetlabs.ru>
 <20140207144447.GJ24395@pd.tnic>
 <20140207172618.GA8385@sanechka.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140207172618.GA8385@sanechka.spb.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 09:26:18PM +0400, Alexandra N. Kossovsky wrote:
> On Feb 07 15:44, Borislav Petkov wrote:
> > On Fri, Feb 07, 2014 at 01:00:45PM +0400, Alexandra N. Kossovsky wrote:
> > > > Btw, did this box boot any kernels successfully in EFI mode at all?
> > > 
> > > Yes.  It booted, for example, the same 3.13 kernel from Debian - without
> > > debug options.
> > 
> > Huh, what debug options?
> 
> Debug options in the kernel config.

Thanks, I'll take a look. I just had another idea which you could try
in the meantime:

Checkout latest Linus kernel and merge

git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git#next

into it, enable CONFIG_EFI_PGT_DUMP and try booting then. Catch dmesg
too and send it to me.

If anything above is unclear, please ask.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
