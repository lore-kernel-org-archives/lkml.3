Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab3DJL4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:56:53 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:61197 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3DJL4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:56:51 -0400
Date: Wed, 10 Apr 2013 13:56:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Jacob Shin <jacob.shin@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
Message-ID: <20130410115647.GA8083@gmail.com>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
 <1365586878.30071.33.camel@laptop>
 <CABPqkBRTaMV9FNmX6qRJAHaO8yTyiqF=EzmeC7Gp7=e-7Bo-gA@mail.gmail.com>
 <1365594552.30071.63.camel@laptop>
 <1365594957.30071.66.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365594957.30071.66.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2013-04-10 at 13:49 +0200, Peter Zijlstra wrote:
> 
> > Hmm.. the 15h old interface bits got merged? I thought I kept telling
> > that should be done like the intel uncore stuff since the hardware
> > interface wasn't retarded anymore.
> 
> Ah well, that crap seems to have slipped in in Feb when I was still a
> near vegetable and not paying much attention.
> 
> /me curses a bit.
> 
> I don't suppose we can deprecate it and remove this stuff? 

I think we can - if there's a functional replacement.

Thanks,

	Ingo
