Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935099AbaFTRRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:17:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:24411 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756835AbaFTRRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:17:44 -0400
Date: Fri, 20 Jun 2014 13:17:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
Message-ID: <20140620131736.192cc072@gandalf.local.home>
In-Reply-To: <20140620101244.a1f4534e.akpm@linux-foundation.org>
References: <20140619213329.478113470@goodmis.org>
	<20140619213952.058255809@goodmis.org>
	<20140619220607.c6da2540.akpm@linux-foundation.org>
	<20140620125823.5acb12dd@gandalf.local.home>
	<20140620101244.a1f4534e.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014 10:12:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:


> > Comment? What? Git blame isn't good enough for ya? ;-)
> 
> There's always that.  There's also googling for the original list
> dicsussion.  But it's a bit user-unfriendly, particularly when then
> code has aged was subsequently altered many times.

I was replying mostly in jest as that was what I did to remember why we
added it.

> 
> >
> > ...
> >
> > 
> > Hey! Thanks for the review. Much appreciated. And maybe you should read
> > those messages in your /dev/null folder that I cc you with. :-)
> 
> I sometimes do.

Ah, the lurker.

-- Steve
