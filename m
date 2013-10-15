Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3JOHPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:15:13 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:41604 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3JOHPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:15:11 -0400
Date: Tue, 15 Oct 2013 09:15:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Len Brown <len.brown@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20131015071508.GA25059@gmail.com>
References: <20131012171553.GA17548@gmail.com>
 <CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>
 <52599277.3090502@zytor.com>
 <20131012184920.GA19065@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131012184920.GA19065@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 10/12/2013 11:05 AM, Linus Torvalds wrote:
> > > On Sat, Oct 12, 2013 at 10:15 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >>
> > >> Ville Syrjälä (1):
> > >>       x86/reboot: Add reboot quirk for Dell Latitude E5410
> > > 
> > > So we have a number of these quirks, and Dell seems to be one of the
> > > more common factors.
> 
> I raised this with hpa when the latest round of Dell quirks were added, 
> but I agree that the quirk frequency sucks (for every quirk there's 
> likely 5 times as many boxes still out there that we haven't applied a 
> quirk for yet ...) and I agree that this needs to be discussed more 
> widely.

One problem we have is that we have sporadic end user reports only, with 
no systematic testing done by Dell on these systems apparently. Is there 
anyone at Dell who cares about these reboot problems that upstream kernels 
exhibit with VT-d enabled?

Thanks,

	Ingo
