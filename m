Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbaFZQsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:48:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:32516 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757085AbaFZQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:48:42 -0400
Date: Thu, 26 Jun 2014 12:48:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Cc: Christopher Covington <cov@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: Re: [PATCH] RFC: Add signal command to trace events
Message-ID: <20140626124832.6ecd327d@gandalf.local.home>
In-Reply-To: <20140626162943.GA9970@redhat.com>
References: <1403791044-2214-1-git-send-email-cov@codeaurora.org>
	<20140626111749.3234d4d4@gandalf.local.home>
	<20140626162943.GA9970@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 18:29:43 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 06/26, Steven Rostedt wrote:
> >
> > [ Added Oleg who is the guru of signals ;-) ]
> 
> Thanks,
> 
> I didn't see the patch, so I can only guess what it does,
> 

I didn't crop the patch on my reply. But if you want me to bounce it to
you I can.

-- Steve
