Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab3HODX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 23:23:27 -0400
Received: from ozlabs.org ([203.10.76.45]:54150 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758311Ab3HODX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 23:23:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
In-Reply-To: <20130813111442.632f3421@gandalf.local.home>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com> <877hc64klm.fsf@rustcorp.com.au> <20130813111442.632f3421@gandalf.local.home>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 15 Aug 2013 11:32:10 +0930
Message-ID: <87siybk8yl.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> But the thing about this that bothers me is that there's no way to say,
> "Enable all tracepoints in this module on load". I would like a way to
> do that, but I don't know of a way to do that without modifying the
> module code. Have any ideas? Basically, I would love to have:
>
> insmod foo tracepoints=all
>
> or something and have all tracepoints enabled.

"without modifying the module code"?  Why?  The code isn't that scary,
and this seems useful.

Cheers,
Rusty.

