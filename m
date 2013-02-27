Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3B0QIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:08:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40900 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3B0QIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:08:40 -0500
Date: Wed, 27 Feb 2013 17:08:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Wim Van Sebroeck <wim@iguana.be>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-watchdog@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [next-20130227] kernel NULL pointer dereference [ watchdog |
 perf related ? ]
Message-ID: <20130227160833.GF5530@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sedat Dilek <sedat.dilek@gmail.com>, Tejun Heo <tj@kernel.org>,
	Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-watchdog@vger.kernel.org, x86@kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>
References: <CA+icZUUsedHPqZc5jXQ_AqAbfmTMu5WW8CJ+vnHwL69ofw7uTw@mail.gmail.com>
 <20130227122302.GA5678@pd.tnic>
 <CA+icZUVXDfOhztQtrOxyYaHutpx=iVpPGmRT0PzP7045_mjh6w@mail.gmail.com>
 <CA+icZUXJb5O7ML-xnQq8Zoa46NmaGZp2Xaqj6fJL+vudPeQTLw@mail.gmail.com>
 <20130227150733.GB22383@htj.dyndns.org>
 <CA+icZUUFCOPJ=TAE-5=suUqPy0NjA+BSToiZxX=Xm7u=30GdOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUUFCOPJ=TAE-5=suUqPy0NjA+BSToiZxX=Xm7u=30GdOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 04:56:27PM +0100, Sedat Dilek wrote:
> Hmm, I am not very amused to read all this, really.
> 
> If such fixes are around why aren't they applied quickly?

Sedat, you need to relax a little. You're testing a linux next tree
right during the merge window where patches are flying back and forth.
Things like that can happen and you, if you're really willing to test
such bleeding edge kernels, also would have to accept the fact that
fixes don't magically appear where they have to in no time.

I debugged an issue which apparently got fixed already but I'm not
complaining. People are trying their best and screaming at them is not
constructive. At all.

I'd suggest simply reporting the issue, maybe trying to debug it
yourself and patiently waiting. I'm sure you can find anything else to
do in the meantime :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
