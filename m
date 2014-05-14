Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaENQHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:07:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:55210 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751608AbaENQHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:07:12 -0400
Date: Wed, 14 May 2014 12:07:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH v2] tracing: Add __bitmask() macro to trace events
 to cpumasks and other bitmasks
Message-ID: <20140514120709.6d31ea02@gandalf.local.home>
In-Reply-To: <20140514155053.GB3052@e102654-lin.cambridge.arm.com>
References: <1399377998-14870-1-git-send-email-javi.merino@arm.com>
	<1399377998-14870-6-git-send-email-javi.merino@arm.com>
	<20140506132238.22e136d1@gandalf.local.home>
	<484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
	<20140506231238.246c7d3e@gandalf.local.home>
	<20140514142324.GA10024@e102654-lin.cambridge.arm.com>
	<20140514113623.171f2a39@gandalf.local.home>
	<20140514155053.GB3052@e102654-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 16:50:53 +0100
Javi Merino <javi.merino@arm.com> wrote:


> > OK, let me pull this patch out of my tree (thank god I never pushed
> > it), and work on it a bit more.
> 
> Ok, well keep me posted on this, I've tried to use it but trace-cmd
> says "[FAILED TO PARSE]" and I'm still trying to figure out if it's me
> not using it properly or some bug in the code.

Oh, it's going to require a trace-cmd patch. But that's rather trivial.
(actually, it will require a update to libtraceevent).

I can send you a patch for trace-cmd after I get this figured out. I
think I have an idea that can still keep this as 3.16 material.

Thanks,

-- Steve
