Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936683Ab3DJM3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:29:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52408 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab3DJM3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:29:04 -0400
Date: Wed, 10 Apr 2013 14:29:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Robert Richter <rric@kernel.org>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
Message-ID: <20130410122901.GA13676@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stephane Eranian <eranian@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>, x86 <x86@kernel.org>,
	Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Robert Richter <rric@kernel.org>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
 <1365586878.30071.33.camel@laptop>
 <CABPqkBRTaMV9FNmX6qRJAHaO8yTyiqF=EzmeC7Gp7=e-7Bo-gA@mail.gmail.com>
 <1365594552.30071.63.camel@laptop>
 <1365594957.30071.66.camel@laptop>
 <20130410115647.GA8083@gmail.com>
 <CABPqkBQS3ikJWd6yXjjSKdEW3M2pNYzTSs2d56=VTx=aomWUYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBQS3ikJWd6yXjjSKdEW3M2pNYzTSs2d56=VTx=aomWUYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 02:12:42PM +0200, Stephane Eranian wrote:
> >> Ah well, that crap seems to have slipped in in Feb when I was still a
> >> near vegetable and not paying much attention.
> >>
> >> /me curses a bit.
> >>
> >> I don't suppose we can deprecate it and remove this stuff?
> >
> > I think we can - if there's a functional replacement.
> >
> Does the existing code expose a type in sysfs?
> If not then you cannot do this transparently, I am afraid
> because the syntax would be different, i.e., not cpu/...
> 
> I reviewed the code and tested it. But at the time, I thought
> you had agreed on the approach used.

Btw, Robert is away this week. I'll CC him - he might still read email.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
