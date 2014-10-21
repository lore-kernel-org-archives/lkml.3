Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaJUNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:16:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:55631 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932170AbaJUNQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:16:25 -0400
Date: Tue, 21 Oct 2014 09:16:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kprobes: introduce weak
 arch_check_ftrace_location() helper function
Message-ID: <20141021091605.1d91b77a@gandalf.local.home>
In-Reply-To: <54464D64.9090409@hitachi.com>
References: <1413880229-4796-1-git-send-email-heiko.carstens@de.ibm.com>
	<1413880229-4796-2-git-send-email-heiko.carstens@de.ibm.com>
	<544627D0.60309@hitachi.com>
	<20141021120046.GC4161@osiris>
	<54464D64.9090409@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014 21:11:16 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/10/21 21:00), Heiko Carstens wrote:
> > On Tue, Oct 21, 2014 at 06:30:56PM +0900, Masami Hiramatsu wrote:
> >> (2014/10/21 17:30), Heiko Carstens wrote:
> >>> Introduce weak arch_check_ftrace_location() helper function which
> >>> architectures can override in order to implement handling of kprobes
> >>> on function tracer call sites on their own, without depending on
> >>> common code or implementing the KPROBES_ON_FTRACE feature.
> >>>
> >>> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> >>
> >> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> >>
> >> Thanks!
> > 
> > Ok, thanks!
> > 
> > If there are no objections, this patch and the s390 only patch will
> > go upstream via the s390 tree. Is that ok?
> 
> Yeah, I think it's OK for me.
> 

Fine with me.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
