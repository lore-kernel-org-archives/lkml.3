Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934624AbaFTQVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:21:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:60376 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932155AbaFTQVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:21:37 -0400
Date: Fri, 20 Jun 2014 12:21:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
Message-ID: <20140620122135.17a90bfb@gandalf.local.home>
In-Reply-To: <CA+55aFx_BVK6EvMTcTy218coYEhvMdw3AkygDtiZk5aHxa-fuA@mail.gmail.com>
References: <20140619213329.478113470@goodmis.org>
	<20140619213952.058255809@goodmis.org>
	<CA+55aFx_BVK6EvMTcTy218coYEhvMdw3AkygDtiZk5aHxa-fuA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 18:45:57 -1000
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jun 19, 2014 at 11:33 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> >
> > The trace_seq functions are rather useful outside of tracing.
> 
> They are?

They will be.

> Why and where?

Why? for NMI safe output.

Where? Well, in patch 3. :-)

> And why are they still called "trace_xyz()" then?

Good point, I'd like to rename it too. It was designed like seq_file,
so what about seq_buffer_xxx()?


> 
> That commit message is useless and contains no actual information.

Yeah, it was rather weak. It was quick and not a stand alone. It was
dependent on reading the rest of the patches.

OK, I can update the name and make a better change log on the move.

Of course if you hate this patch series, I can just not waste any time
on it.

-- Steve

