Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaE1LXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:23:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35751 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbaE1LXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:23:49 -0400
Date: Wed, 28 May 2014 13:23:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Subject: Re: ACPI Error: Could not enable RealTimeClock event
 (20140214/evxfevnt-212)
Message-ID: <20140528112344.GC17196@pd.tnic>
References: <20140526160403.GA26531@pd.tnic>
 <CALAqxLWSLq8vgkcs3-Cu-coMB9L=eL-gmBPfsZ+ZuxF0LuY5LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALAqxLWSLq8vgkcs3-Cu-coMB9L=eL-gmBPfsZ+ZuxF0LuY5LA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 11:56:29AM -0700, John Stultz wrote:
> On Mon, May 26, 2014 at 9:04 AM, Borislav Petkov <bp@alien8.de> wrote:
> > Hi guys,
> >
> > so I get this with rc7+tip but not with rc6+tip:
> >
> > ACPI Error: Could not enable RealTimeClock event (20140214/evxfevnt-212)
> > ACPI Warning: Could not enable fixed event - RealTimeClock (4) (20140214/evxface-628)
> 
> Does it happen on -rc7 w/o tip?
> 
> Looking at the -rc6 to -rc7 commit list, I don't see anything that
> pops out at me.  There's no changes to drivers/rtc nor drivers/acpi.
> 
> The only change that might be relevant from arch/x86/ is:
> a4b4f11b2783ec678cccb4ce7e4ce9665aa04a24 (perf/x86/intel: Fix
> Silvermont's event constraints).  Any other hardware details, etc?

Yeah, I just did a fresh merge of Linus' master + tip/master and the
error message is gone. It could've been a glitch so I'll watch out for
it if it reappears.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
