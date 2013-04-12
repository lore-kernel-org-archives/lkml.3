Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3DLNmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:42:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18179 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab3DLNmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:42:46 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=P6hlpVgoKeYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ayLHJbDuenQA:10 a=DWZekSpwSNPSmUazbnQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365774163.9609.80.camel@gandalf.local.home>
Subject: Re: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for
 PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Apr 2013 09:42:43 -0400
In-Reply-To: <20130412133118.GC2368@pd.tnic>
References: <1365705214.9609.58.camel@gandalf.local.home>
	 <20130412133118.GC2368@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 15:31 +0200, Borislav Petkov wrote:
> On Thu, Apr 11, 2013 at 02:33:34PM -0400, Steven Rostedt wrote:
> > Comments?
> 
> I don't have a problem with it except with the yelling - I think I've
> gone deaf. And for Rostedt code it is pretty clean and even *I* can
> understand it :-).
> 
> Tony?
> 
> Steve, stupid question: since this is -rt only, why even push it
> upstream?
> 

I'm not (yet). But I just wanted to make sure there wasn't any little
subtleties that I might be missing.

When -rt goes mainline, code like this will be going mainline too, thus
the maintainers will see it then.

Thanks!

-- Steve
  

