Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab3BLVmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:42:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31662 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3BLVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:42:05 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=aenFFsPXAxYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=jYsbpZmz910A:10 a=xIqg3xUteD1LzczNy-YA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360705324.21867.100.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH v2] tracing/syscalls: Allow archs to ignore tracing
 compat syscalls
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 12 Feb 2013 16:42:04 -0500
In-Reply-To: <511AB525.4050300@linux.intel.com>
References: <1360692087.21867.42.camel@gandalf.local.home>
	   <511A85E8.7030303@linux.intel.com>
	  <1360694555.21867.69.camel@gandalf.local.home>
	  <511A9A64.3040108@linux.intel.com> <511A9DD9.7090805@linux.intel.com>
	 <1360703939.21867.99.camel@gandalf.local.home>
	 <511AB525.4050300@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 13:33 -0800, H. Peter Anvin wrote:
> On 02/12/2013 01:18 PM, Steven Rostedt wrote:
> > [
> >   Peter, how about this patch. Instead of showing garbage, just never
> >   trace compat syscalls, if the arch needs to ignore it.
> > 
> >   However, users can still use the raw_syscall interface if they need to
> >   trace them.
> > ]
> > 
> 
> I can go for that.  At least it doesn't make the current situation any
> messier than it currently is, and it prevents incorrect information from
> being output.
> 

Great, can I have your Acked-by. Then I'll start testing it and get it
ready to push for 3.9.

-- Steve


