Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3H0M12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:27:28 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49516 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3H0M11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:27:27 -0400
Date: Tue, 27 Aug 2013 14:27:21 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/12] perf, persistent: Add persistent events
Message-ID: <20130827122721.GF15884@rric.localhost>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <20130824093826.GB28383@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824093826.GB28383@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.08.13 11:38:26, Borislav Petkov wrote:
> this text is very nicely written and should be in a README somewhere.
> :-)

Yeah, will put it under tools/perf/Documentation/...

> > There are ioctl functions to control persistent events that can be
> > used to detach or attach an event to or from a process. The
> > PERF_EVENT_IOC_DETACH ioctl call makes an event persistent.
> 
> Yeah, we probably want to abstract this a step further by allowing
> to attach/detach fds to/from events. Then "persistent" is only one
> incarnation of us always detaching from the event during its lifetime.
> 
> If we close an event while it is attached, it gets destroyed - i.e.,
> current functionality, etc. See the other thread.

I don't know what you mean here exactly, please explain.

> But we probably need more input on this from people. Ingo, Peter?

Yes, that would be great.

Thanks,

-Robert
