Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826Ab3DIPMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:12:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934797Ab3DIPMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:12:06 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Nx0--Y5ztT8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YNzZoMN0o1AA:10 a=OyLrJ06T-UMFwgDY2ukA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365520325.25498.64.camel@gandalf.local.home>
Subject: Re: [PATCH 3/4] uprobes/tracing: Kill the pointless
 local_save_flags/preempt_count calls
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 11:12:05 -0400
In-Reply-To: <20130409145851.GB22913@redhat.com>
References: <20130329181545.GA20697@redhat.com>
	 <1365436722.25498.14.camel@gandalf.local.home>
	 <20130409145851.GB22913@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 16:58 +0200, Oleg Nesterov wrote:

> Hmm, just to remind which arguments trace_current_buffer_*() has?
> 
> Personally I disagree. And, for example, ftrace_syscall_enter/exit just
> use 0,0 for the same reason.
> 
> So please tell me if you really want the dummy variables/arguments, in
> this case I'll change this code even if I do not like it.

I'm not attached to it, so if you really don't like it, then sure, go
ahead and scrap it. I was just fueled by the hatred of "1" and "2" in
your other patch that it carried over to this one ;-)

-- Steve


