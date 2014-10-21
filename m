Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaJUMAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:00:54 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:56476 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbaJUMAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:00:52 -0400
Date: Tue, 21 Oct 2014 14:00:46 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kprobes: introduce weak
 arch_check_ftrace_location() helper function
Message-ID: <20141021120046.GC4161@osiris>
References: <1413880229-4796-1-git-send-email-heiko.carstens@de.ibm.com>
 <1413880229-4796-2-git-send-email-heiko.carstens@de.ibm.com>
 <544627D0.60309@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544627D0.60309@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102112-0021-0000-0000-0000017A8104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 06:30:56PM +0900, Masami Hiramatsu wrote:
> (2014/10/21 17:30), Heiko Carstens wrote:
> > Introduce weak arch_check_ftrace_location() helper function which
> > architectures can override in order to implement handling of kprobes
> > on function tracer call sites on their own, without depending on
> > common code or implementing the KPROBES_ON_FTRACE feature.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Thanks!

Ok, thanks!

If there are no objections, this patch and the s390 only patch will
go upstream via the s390 tree. Is that ok?

Thanks,
Heiko

