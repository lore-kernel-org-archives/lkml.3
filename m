Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbaFZRRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:17:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785AbaFZRRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:17:16 -0400
Date: Thu, 26 Jun 2014 19:15:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Christopher Covington <cov@codeaurora.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [PATCH] RFC: Add signal command to trace events
Message-ID: <20140626171530.GB28565@redhat.com>
References: <1403791044-2214-1-git-send-email-cov@codeaurora.org> <20140626111749.3234d4d4@gandalf.local.home> <20140626162943.GA9970@redhat.com> <20140626124832.6ecd327d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626124832.6ecd327d@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Steven Rostedt wrote:
>
> On Thu, 26 Jun 2014 18:29:43 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 06/26, Steven Rostedt wrote:
> > >
> > > [ Added Oleg who is the guru of signals ;-) ]
> >
> > Thanks,
> >
> > I didn't see the patch, so I can only guess what it does,
> >
>
> I didn't crop the patch on my reply. But if you want me to bounce it to
> you I can.

I was going to find it on lkml.org, but yes, thanks, please forward it to me ;)

Oleg.

