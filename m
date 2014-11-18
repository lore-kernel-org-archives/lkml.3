Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaKRQmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:42:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44199 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbaKRQmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:42:08 -0500
Date: Tue, 18 Nov 2014 17:42:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Liang, Kan" <kan.liang@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug
 workaround
Message-ID: <20141118164205.GE5238@pd.tnic>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
 <1416251225-17721-14-git-send-email-eranian@google.com>
 <20141117230232.GC25157@pd.tnic>
 <alpine.DEB.2.11.1411180025270.3909@nanos>
 <20141117235841.GD25157@pd.tnic>
 <alpine.DEB.2.11.1411180115420.3909@nanos>
 <CABPqkBQp36s=cKgy0e9hpARgY=z1AucXyToBVtykOvyuAr8AyQ@mail.gmail.com>
 <20141118154308.GB5238@pd.tnic>
 <CABPqkBQMCDzN4r8-3vj1EqOuF28pT63iPfnP9M_ry3CL-Sy7xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBQMCDzN4r8-3vj1EqOuF28pT63iPfnP9M_ry3CL-Sy7xw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 05:37:26PM +0100, Stephane Eranian wrote:
> Does it need to bit a bitmask, as opposed to just a bug number (which could
> be implemented as a bitmask)?
> 
> >> enable_workaround:
> >>    - provide the bit number (of the workaround) to enable the workaround
> >
> > Right, writing the bit number could be part of the description message
> > above - just so that users know how to control the interface.
> >
> writing the bug number....

Ah, ok, I see what you mean. I guess we can do increasing bug numbers.
The mapping internally to bits in bitmasks or whatever fancy thing we
do should remain hidden. So I'd guess assigning bug numbers to the bugs
should be the only thing that's stable and user-visible...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
