Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab3DYRJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:09:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab3DYRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:09:41 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=P6hlpVgoKeYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ayLHJbDuenQA:10 a=3ts_00xt4goXv3Z-YG4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366909777.10248.17.camel@gandalf.local.home>
Subject: Re: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for
 PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, John Kacur <jkacur@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 25 Apr 2013 13:09:37 -0400
In-Reply-To: <20130425164441.GG5561@linutronix.de>
References: <1365705214.9609.58.camel@gandalf.local.home>
	 <20130425164441.GG5561@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 18:44 +0200, Sebastian Andrzej Siewior wrote:
> * Steven Rostedt | 2013-04-11 14:33:34 [-0400]:
> 
> >Comments?
> 
> So you don't mind if I take this for v3.8?
> I fixed
> 
> |arch/x86/kernel/cpu/mcheck/mce.c:1392:13: warning: function declaration isn’t a prototype [-Wstrict-prototypes]
> 
> >+static void mce_notify_work()

Thanks, I didn't look hard at the warnings.

-- Steve


