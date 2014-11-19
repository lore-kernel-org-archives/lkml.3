Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbaKSPBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:01:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:50723 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754736AbaKSPB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:01:29 -0500
Date: Wed, 19 Nov 2014 10:01:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/2] tracing: Use trace_seq_used() and seq_buf_used()
 instead of len
Message-ID: <20141119100108.1e091afc@gandalf.local.home>
In-Reply-To: <20141119144004.GB2332@dhcp128.suse.cz>
References: <20141115045847.712848224@goodmis.org>
	<20141115050603.904875201@goodmis.org>
	<20141117123250.10f6f57c@gandalf.local.home>
	<20141117141215.2dbd5f12@gandalf.local.home>
	<20141118163354.GK23958@pathway.suse.cz>
	<20141118123732.462b1ad8@gandalf.local.home>
	<20141119114017.GA2332@dhcp128.suse.cz>
	<20141119084800.524beb62@gandalf.local.home>
	<20141119144004.GB2332@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 15:40:05 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> > s->seq.len will never be more than s->seq.size after the test against
> > TRACE_MAX_PRINT. So I see no harm here.
> 
> Ah, I see. Well, I would feel more comfortable if it uses
> trace_seq_used() or if there is some explanation in a comment.
> But you are right, it is safe as it is. Feel free to leave it.

Yeah, a comment would be nice. I may add it late.

> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>

Thanks,

-- Steve
