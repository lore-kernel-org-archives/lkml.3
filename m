Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3GUTTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 15:19:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab3GUTTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 15:19:46 -0400
Date: Sun, 21 Jul 2013 21:14:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tracing: Simplify trace_array_get()
Message-ID: <20130721191440.GA31598@redhat.com>
References: <20130719155041.GA19501@redhat.com> <20130719155101.GA19509@redhat.com> <1374251217.3356.12.camel@gandalf.local.home> <20130719163312.GA21544@redhat.com> <20130719172053.GA4845@redhat.com> <1374255311.3356.15.camel@gandalf.local.home> <20130719182407.GA9363@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719182407.GA9363@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19, Oleg Nesterov wrote:
>
> On 07/19, Steven Rostedt wrote:
> >
> > Correct, but I don't see that as a major problem, do you?
>
> Neither me. I should have mentioned this.
>
> Except "might get a strange result" as you said.
>
> But I have to admit, I am still trying to find something really bad ;)

And it seems I have found... I'll try to report tomorrow.

Steven, Masami. I do remember I promised to finish/resend the RFC
patches on Friday.

But I decided to take a break and try to see what else we should
fix, and it seems that we have the bugs we did not discuss yet.
And _I hope_ the fixes should not be "controversial", so I'll try
to send them first.

Oleg.

