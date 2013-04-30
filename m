Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689Ab3D3Ir0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:47:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44116 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617Ab3D3IrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:47:23 -0400
Date: Tue, 30 Apr 2013 10:47:14 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org
Subject: Re: [ANNOUNCE] 3.8.10-rt6
In-Reply-To: <20130429161925.2a6ea78a@riff.lan>
Message-ID: <alpine.LFD.2.03.1304301045080.23877@tycho>
References: <20130429201202.GB7979@linutronix.de> <20130429161925.2a6ea78a@riff.lan>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Apr 2013, Clark Williams wrote:

> On Mon, 29 Apr 2013 22:12:02 +0200
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> >     - suspend / resume seems to program program the timer wrong and wait
> >       ages until it continues.
> > 
> 
> It has to be something we're doing when we apply RT to v3.8.x, since
> v3.8.x suspends/resumes with no issues and I was able to suspend and
> resume fine with the 3.6-rt series.

Our v3.8x series is currently no different than "vanilla" rt.
quilt-import on top of v3.8.10, with no RH patches. So, I know you said 
that just as a polite way to say, "maybe we messed up, but...", however 
I'm confident we didn't.

Also, that must be a typo, you meant to say that v3.8.x does have issues 
with suspend / resume right?
 
> 
> I'm looking at a git diff between 3.6.11-rt30 and 3.8.9-rt4,
> specifically in kernel/time* and arch/x86/kernel but so far I'm not
> seeing much that's RT specific.
> 
> Clark
> 
