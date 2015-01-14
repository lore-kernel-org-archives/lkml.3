Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbbANSr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:47:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47297 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbbANSrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:47:25 -0500
Date: Wed, 14 Jan 2015 19:47:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Message-ID: <20150114184714.GD6902@pd.tnic>
References: <5491B4A8.905@amacapital.net>
 <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org>
 <20150114165151.GA3479@codeblueprint.co.uk>
 <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
 <20150114183546.GC6902@pd.tnic>
 <CALCETrUEfQY-hnmNV9-PfDbEYLa7bVoRcsZc2X0V+mEAbfNH2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUEfQY-hnmNV9-PfDbEYLa7bVoRcsZc2X0V+mEAbfNH2g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 10:38:25AM -0800, Andy Lutomirski wrote:
> That's not a real MCE, though -- it happens synchronously instead of

MCE can be synchronous in a sense too, as a result of executing an insn,
for example, i.e., EIPV bit set.

> at MCE priority with all the associated messiness.  Or is the idea to
> just stick that in after switching to the 32-bit mode being tested?

Yes, the idea was to simply trigger a real exception after switching to
32-bit while still with 64-bit IDT handlers.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
