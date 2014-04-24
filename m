Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbaDXMh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:37:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:63655 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753282AbaDXMhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:37:55 -0400
Date: Thu, 24 Apr 2014 08:37:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] uprobes/tracing:
 uprobe_perf_open()->uprobe_apply() fix
Message-ID: <20140424083753.427bd54b@gandalf.local.home>
In-Reply-To: <20140424115458.GA8882@redhat.com>
References: <20140423165808.GA29485@redhat.com>
	<20140423165830.GA29493@redhat.com>
	<20140423231728.1b95e37c@gandalf.local.home>
	<20140424115458.GA8882@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014 13:54:58 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/23, Steven Rostedt wrote:
> >
> > Egad, this confused the heck out of me. I didn't notice the swap in
> > functions and was wondering what you were doing. I didn't realize this
> > is what you meant by moving the uprobe_perf_close() up. I was thinking
> > you moved the call up or something, not the function itself physically
> > in the file.
> ...
> >
> > You can add by Acked-by, but next time, please make this into two
> > patches. One to do the move, the other to do the change.
> 
> OK...
> 
> I tried to lessen the number of patches I have ;) But I agree, this simple
> fix looks too complicated without preparation which only moves the code.

Yeah, sometimes a simple fix just seems wrong to break into two. But if
it helps in code review, it's definitely worth it.


> 
> Let me split it then. Result is the same do I preserved the acks, this is
> what I am going to add to my tree.

They look good (and much easier to review).

-- Steve
