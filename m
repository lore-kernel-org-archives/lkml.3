Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3ELMuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 08:50:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3ELMuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 08:50:51 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MHtc-6IHmuYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=nVE_FSFTGkgA:10 a=p8jDcoIEoWLYLN9mOdcA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368363048.6828.16.camel@gandalf.local.home>
Subject: Re: [PATCH 00/18] tracing/kprobes: Update kprobes with new ftrace
 changes
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Sun, 12 May 2013 08:50:48 -0400
In-Reply-To: <1368325352.6828.14.camel@gandalf.local.home>
References: <20130511001206.477862307@goodmis.org>
	 <CA+55aFyftw6uxJ=pO4DgN7ZrKxE5X-cbQahMjKKu6Rb++EGhqQ@mail.gmail.com>
	 <1368324689.6828.13.camel@gandalf.local.home>
	 <1368325352.6828.14.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-11 at 22:22 -0400, Steven Rostedt wrote:
> On Sat, 2013-05-11 at 22:11 -0400, Steven Rostedt wrote:
> 
> > I'll take a look when my allmodconfig test finishes.
> 
> It just finished with no warnings about this. But I did it against the
> branch you pulled, not to 3.10-rc1. I'll start that now.

Hmm, I'm still not able to reproduce this. Can you do a make mrproper
and rebuild and see if you still get that warning.

I'm trying a couple more things (like doing a make mrproper myself ;-).
I'm also building with an older 4.6 gcc. I wonder if the version of gcc
matters.

Thanks,

-- Steve


