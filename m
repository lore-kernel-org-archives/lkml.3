Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030781AbaDJNDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:03:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:48269 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030588AbaDJNDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:03:16 -0400
Date: Thu, 10 Apr 2014 09:03:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/2] Was: Convert process iteration to use
 for_each_process_thread()
Message-ID: <20140410090309.3f353f93@gandalf.local.home>
In-Reply-To: <20140409170505.GA27638@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
	<1397059882-23063-3-git-send-email-fweisbec@gmail.com>
	<360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
	<20140409124249.4081e665@gandalf.local.home>
	<20140409170505.GA27638@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014 19:05:05 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/09, Steven Rostedt wrote:
> >
> > The tasklist_lock is all that is needed.
> 
> Yes, but not _irq. Plus this code is buggy ;)
> 
> Steven, I sent these patches twice (at least!). This time I didn't
> bother to recheck this code, but the patches still apply so perhaps
> you can take a look?
> 
> Last attempt, I promise ;)

Ah OK, and I actually have time to look at them now :-)

-- Steve
