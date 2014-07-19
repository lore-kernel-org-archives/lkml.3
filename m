Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbaGSV74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 17:59:56 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52190 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaGSV7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 17:59:54 -0400
Date: Sat, 19 Jul 2014 17:59:52 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: add IPI tracepoints
In-Reply-To: <CAKv+Gu_71vJFf3aUZso1X7m7fULUMhxj+MZVYq+LGNRLJvGyAA@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1407191758190.3647@knanqh.ubzr>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org> <1405660735-13408-3-git-send-email-nicolas.pitre@linaro.org> <20140718160418.54d11f6a@gandalf.local.home> <alpine.LFD.2.11.1407181652080.3647@knanqh.ubzr> <20140718172221.6dbe83e4@gandalf.local.home>
 <CAKv+Gu_71vJFf3aUZso1X7m7fULUMhxj+MZVYq+LGNRLJvGyAA@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2014, Ard Biesheuvel wrote:

> On 18 July 2014 23:22, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 18 Jul 2014 16:55:42 -0400 (EDT)
> > Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> >
> >>
> >> Here's the patch I have at the head of the series now, with the above
> >> ugliness changed to an unconditional __tracepoint_string attribute.
> >>
> >
> > I was thinking of something like this. Feel free to add this to your
> > series.
> >
> > -- Steve
> >
> 
> Nico,
> 
> If this patch addresses the issue where 3 RCU related tracepoint
> strings turn up /after/ _edata on !CONFIG_TRACING, there is already a
> patch queued up here
> 
> http://marc.info/?l=linux-kernel&m=140518452623148&w=2

No, that doesn't help my case.  Please see the initial comment from 
Steven in this thread and you'll understand.


Nicolas
