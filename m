Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaKESnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:43:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:56155 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750894AbaKESnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:43:02 -0500
Date: Wed, 5 Nov 2014 13:42:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 03/12 v3] tracing: Create seq_buf layer in
 trace_seq
Message-ID: <20141105134259.1382ec70@gandalf.local.home>
In-Reply-To: <20141105142620.GD4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160221.864997179@goodmis.org>
	<20141105142620.GD4570@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 15:26:20 +0100
Petr Mladek <pmladek@suse.cz> wrote:


> > index 000000000000..97872154d51c
> > --- /dev/null
> > +++ b/include/linux/seq_buf.h
> > @@ -0,0 +1,72 @@
> > +#ifndef _LINUX_SEQ_BUF_H
> > +#define _LINUX_SEQ_BUF_H
> > +
> > +#include <linux/fs.h>
> > +
> > +#include <asm/page.h>
> 
> One more small thing. We do not need this include because
> seq_buf does not use the PAGE_SIZE.

Good catch.

I'll remove it.

-- Steve

