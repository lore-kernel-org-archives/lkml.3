Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3KGMIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:08:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45750 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3KGMIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:08:06 -0500
Date: Thu, 7 Nov 2013 13:10:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arjan van de Ven <arjanvandeven@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: kernel bugzilla #64531: intel microcode information
Message-ID: <20131107121014.GB27116@x1.alien8.de>
References: <527B28BB.9070400@infradead.org>
 <20131107073438.GA26654@gmail.com>
 <CADyApD25k63K1t9SXv7EERopk3sCE9Wq65fiGiFAn_zuPHsd5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADyApD25k63K1t9SXv7EERopk3sCE9Wq65fiGiFAn_zuPHsd5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 09:46:40AM +0100, Arjan van de Ven wrote:
> fwiw this file lives on intel.com for a while now.. unfortunately it's
> one of these websites with fancy downloading stuff for which I suspect
> the URLs are not long term stable ;-(
> but if you type "microcode" into the search box its the first entry...
> 
> On Thu, Nov 7, 2013 at 8:34 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> >> Re: https://bugzilla.kernel.org/show_bug.cgi?id=64531
> >>
> >>
> >> arch/x86/Kconfig line 1053 (+/-), help section in CONFIG_MICROCODE_INTEL, says:
> >>
> >> For latest news and information on obtaining all the required
> >> Intel ingredients for this driver, check:
> >> <http://www.urbanmyth.org/microcode/>
> >>
> >> ==> 404  Page not found
> >>
> >>
> >> Is there a good replacement for this information or should we just
> >> delete that help text?
> >
> > I'd say let's delete the text. Mind sending a patch?

Yeah, all the distros are packaging those in some firmware-extra or
whatever package anyway.

-- 
Regards/Gruss,
Boris.
