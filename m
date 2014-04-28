Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbaD1Ogi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:36:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:28569 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752587AbaD1Ogg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:36:36 -0400
Date: Mon, 28 Apr 2014 10:36:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] ftrace/module: Hardcode ftrace_module_init() call into
 load_module()
Message-ID: <20140428103632.21f6de1c@gandalf.local.home>
In-Reply-To: <87lhuqtfej.fsf@rustcorp.com.au>
References: <20140424105417.7407bb72@gandalf.local.home>
	<87lhuqtfej.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 10:54:20 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> > [
> >   Rusty, you can take this patch, or if you want, you can give me 
> >   an Acked-by, and I'll push this through my tree.
> > ]
> 
> Assuming you want this in the current kernel, I'll just ack:
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Since I've got my "make RO/NX earlier" patch queued for *next*
> window, and yours need to go in before that...
> 

OK, thanks!

I'll start running it through my full test suite and then send it off
with a stable tag to Linus.

-- Steve
