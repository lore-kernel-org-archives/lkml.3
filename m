Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3EaMsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:48:23 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38013 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3EaMsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:48:10 -0400
Date: Fri, 31 May 2013 14:48:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Robert Richter <rric@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 0/4] perf tools: Persistent events, changes for perf tool
 integration
Message-ID: <20130531124805.GA8659@gmail.com>
References: <1369991785-10499-1-git-send-email-rric@kernel.org>
 <20130531120720.GA7885@gmail.com>
 <20130531122443.GB17843@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531122443.GB17843@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Fri, May 31, 2013 at 02:07:20PM +0200, Ingo Molnar wrote:
> > For that I'd like to create a persistent event that just keeps
> > running, and to which I can occasionally attach to read-only to see
> > what's going on and maybe attach to it read-write to drain the trace
> > entries. I.e. basically a global trace buffer. How do I achieve that
> > with this new tooling?
> 
> I have a patch which adds persistent_events= kernel command line param 
> and uses the same syntax as trace_event=. Rostedt has seen it already, I 
> need to incorporate his comments and send it out next week.

A kernel command line does not make it very practical - this needs to be 
accessible from tooling ...

Thanks,

	Ingo
