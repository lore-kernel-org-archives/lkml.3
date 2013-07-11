Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3GKTzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:55:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26746 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3GKTy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:54:58 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=s37gdL-KhCUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=P1PPt9p6O00A:10 a=eSDXXFJvoOXYmkEMY6QA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373572497.17876.60.camel@gandalf.local.home>
Subject: Re: [RFC] [PATCH 0/2] x86: make jump labels use int3-based
 breakpoint instead of stop_machine()
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jason Baron <jbaron@akamai.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mathieu.desnoyers@efficios.com
Date: Thu, 11 Jul 2013 15:54:57 -0400
In-Reply-To: <alpine.LNX.2.00.1307112122020.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	  <51DDDFB3.3020004@akamai.com>
	  <alpine.LNX.2.00.1307110159490.25858@pobox.suse.cz>
	 <1373560944.17876.41.camel@gandalf.local.home>
	 <alpine.LNX.2.00.1307112122020.29788@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 21:23 +0200, Jiri Kosina wrote:

> > Thus you would need to do something like:
> 
> Yup, I have been looking at the ftrace implementation and came to this 
> conclusion; thanks for confirmation.
> That's exactly why I wanted to postpone converting ftrace before agreement 
> on text_poke_bp() is reached and jump labels are converted.

Note, there's also debug output that ftrace prints when things go wrong.
As really strange things can happen when things don't work, those debug
prints are crucial, and I don't want to lose them.

But we'll discuss that after we get this first round in.

-- Steve


