Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaAHCH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:07:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20389 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753749AbaAHCHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:07:22 -0500
Date: Tue, 7 Jan 2014 21:07:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH] tracing: Show available event triggers when no
 trigger is set
Message-ID: <20140107210719.3bc0af29@gandalf.local.home>
In-Reply-To: <1389137696.3040.145.camel@empanada>
References: <20140107103548.0a84536d@gandalf.local.home>
	<1389137696.3040.145.camel@empanada>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jan 2014 17:34:56 -0600
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:


> Nice idea - very helpful and makes use of that 'unused space'.  ;-)

I came up with it when I was writing my tests against the event
triggers, and didn't know what triggers I had, and realized there was
no easy way to figure it out.

> 
> Even better might be printing the full event formats and examples as in
> tracing/README, but that would probably mean adding a new event-specific
> description function to event_command, and it might get unwieldy with
> too many events.  Just a thought...

I had that same thought, but then thought against it. It would make
things too complicated, and that's what text documentation is for. Or
we can even add it to the tracing/README too.

-- Steve

